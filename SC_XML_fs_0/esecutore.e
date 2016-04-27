note
	description: "Summary description for {ESECUTORE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ESECUTORE

create
	start, start_new

feature --Attributi
	--	conf: CONFIGURAZIONE

	state_chart: CONFIGURAZIONE

	stato_iniziale: STATO

	stati: HASH_TABLE [STATO, STRING]
			-- serve durante l'istanziazione iniziale di stati, transizione e configurazione
			-- una volta che è terminata non serve più

	condizioni: HASH_TABLE [BOOLEAN, STRING]
			-- serve durante l'istanziazione iniziale di stati, transizione e configurazione
			-- una volta che è terminata non serve più

--	count_evento_corrente: INTEGER --tiene il conto del numero di eventi già processati,
--			--serve per la leggi_prossimo_evento

	eventi: ARRAY [STRING]
			-- serve durante la lettura degli eventi dal file

feature {NONE} -- Inizializzazione

	start
			-- Run application.
		local
			s_orig: SIMPLE_MODIFIED
			albero: XML_CALLBACKS_NULL_FILTER_DOCUMENT
		do
			create stato_iniziale.make_empty
			stato_iniziale.set_final
			create stati.make (1)
			create condizioni.make (1)
--			count_evento_corrente := 1
			print ("INIZIO!%N")
			create s_orig.make
			print ("FINE!%N")
			albero := s_orig.tree
			crea_stati_e_condizioni (albero)
			create state_chart.make_with_condition (stato_iniziale, condizioni)
			eventi := acquisisci_eventi
--			print ("cristiano è brutto")
			evolvi_SC
		end

	start_new
	-- TODO finire di verificare se questa feature può diventare la nuova feature di start
		local
			parser: XML_PARSER
			albero: XML_CALLBACKS_TREE
			un_file: STRING
		do
				--| Instantiate parser
			create {XML_STANDARD_PARSER} parser.make
				--| Build tree callbacks
			create albero.make_null
			parser.set_callbacks (albero)
			un_file := "esempio.xml"
				--| Parse the `file_name' content
			parser.parse_from_filename (un_file)
			if parser.error_occurred then
				print ("Parsing error!!! %N")
			else
				print ("Parsing OK. %N")
			end
			create stato_iniziale.make_empty
			create eventi.make_empty
			create stati.make (1)
			create condizioni.make (1)
--			create configuratore.make_with_condition (stato_iniziale, condizioni)
			print ("INIZIO!%N")
			crea_stati_e_condizioni (albero)
			eventi := acquisisci_eventi
			print ("acquisiti eventi")
			create state_chart.make_with_condition (stato_iniziale, condizioni)
			evolvi_SC
		end

feature -- Cose che si possono fare

	evolvi_SC
		local
			count_evento_corrente: INTEGER
			evento_corrente: STRING
			st: detachable STATO
		do
					print ("entrato in evolvi_SC: ")
			FROM
				count_evento_corrente := 1
			UNTIL
				state_chart.stato_corrente.finale or count_evento_corrente > eventi.count
			LOOP
				state_chart.stato_stabile
				evento_corrente := eventi [count_evento_corrente]
				count_evento_corrente := count_evento_corrente + 1
				print ("evento corrente = " + evento_corrente + "%N")
				IF NOT state_chart.stato_corrente.determinismo (evento_corrente, state_chart.condizioni) THEN
					print ("ERRORE!!! Non c'è determinismo!!!")
				ELSE
					st := state_chart.stato_corrente.target (evento_corrente, state_chart.condizioni)
					if attached st as s then
						state_chart.set_stato_corrente (s)
					print ("nuovo stato corrente = " + st.id + "%N")
					end
				end
			end
			if not state_chart.stato_corrente.finale then
				state_chart.stato_stabile
			end
		end

	crea_stati_e_condizioni (albero: XML_CALLBACKS_NULL_FILTER_DOCUMENT)
			--				questa feature dovra creare l'hashtable con gli stati istanziati e le transizioni,
			--				anche garantendo che le transizioni hanno target leciti
		local
			temp_stato: STATO
			flag: BOOLEAN
		do
			flag := false
			if attached {XML_ELEMENT} albero.document.first as f and then attached f.elements as lis_el then
				-- TODO gestire fallimento del test
				from
					lis_el.start
				until
					lis_el.after
				loop
					if lis_el.item_for_iteration.name ~ "final" and then attached lis_el.item_for_iteration.attribute_by_name ("id") as tempattr then
						-- TODO gestire fallimento del test
						create temp_stato.make_with_id (tempattr.value)
						stati.extend (temp_stato, tempattr.value)
						temp_stato.set_final
					elseif lis_el.item_for_iteration.name ~ "state" and then attached lis_el.item_for_iteration.attribute_by_name ("id") as asd then
						-- TODO gestire fallimento del test
						create temp_stato.make_with_id (asd.value)
						stati.extend (temp_stato, asd.value)
					elseif lis_el.item_for_iteration.name ~ "datamodel" and then attached lis_el.item_for_iteration.elements as lis_data then
						-- TODO gestire fallimento del test
						-- TODO separare creazione delle condizioni in feature a parte
						from
							lis_data.start
						until
							lis_data.after
						loop
							if attached {XML_ATTRIBUTE} lis_data.item_for_iteration.attribute_by_name ("id") as nome and then attached {XML_ATTRIBUTE} lis_data.item_for_iteration.attribute_by_name ("expr") as valore then
								condizioni.extend (valore.value ~ "true", nome.value)
							end
							lis_data.forth
						end
						condizioni.extend (true, "condizione_vuota")
--						condizione_vuota è una condizione sempre true che si applica alle transizioni che hanno condizione void (cfr riempi_stato)
					end
					lis_el.forth
				end
					--assegno chi è l'iniziale
				if attached f.attribute_by_name ("initial") as primo_stato and then attached stati.item (primo_stato.value) as valore_primo_stato then
					-- TODO gestire fallimento del test
					stato_iniziale := valore_primo_stato
				end

					--stati istanziati, ora li riempiamo
					-- TODO separare in feature autonoma
				from
					lis_el.start
				until
					lis_el.after
				loop
					if lis_el.item_for_iteration.name ~ "state" and then attached lis_el.item_for_iteration.attribute_by_name ("id") as stato_xml then
						riempi_stato (stato_xml.value, lis_el.item_for_iteration)
					end
					lis_el.forth
				end
			end
		end

	riempi_stato (id_stato: STRING; element: XML_ELEMENT)
		local
			temp_stato: DETACHABLE STATO
			transition_list: LIST [XML_ELEMENT]
			assign_list: LIST [XML_ELEMENT]
			transizione: TRANSIZIONE
			assegnazione: ASSEGNAZIONE
			finta: FITTIZIA
			val: BOOLEAN
		do
			transition_list := element.elements
			from
				transition_list.start
			until
				transition_list.after
			loop
				-- TODO gestire separatamente feature di creazione transizione che torna o transizione o errore
				if transition_list.item_for_iteration.name ~ "transition" and then attached transition_list.item_for_iteration.attribute_by_name ("target") as target then
					-- TODO gestire fallimento del test per assenza clausola target
					if attached stati.item (target.value) as target_state then
						create transizione.make_with_target (target_state)
						if attached transition_list.item_for_iteration.attribute_by_name ("event") as event then
							transizione.set_evento (event.value)
						end
						if attached transition_list.item_for_iteration.attribute_by_name ("cond") as cond then
							transizione.set_condizione (cond.value)
							else	transizione.set_condizione ("condizione_vuota")
						end
						assign_list := transition_list.item_for_iteration.elements
						-- TODO gestire assegnazione di azioni alla transizione corrente in feature separata
						from
							assign_list.start
						until
							assign_list.after
						loop
							if assign_list.item_for_iteration.name ~ "assign" then
								if attached assign_list.item_for_iteration.attribute_by_name ("location") as luogo and then attached assign_list.item_for_iteration.attribute_by_name ("expr") as expr then
									if expr.value ~ "false" then
										create assegnazione.make_with_cond_and_value (luogo.value, FALSE)
										transizione.set_azione (assegnazione)
									elseif expr.value ~ "true" then
										create assegnazione.make_with_cond_and_value (luogo.value, TRUE)
										transizione.set_azione (assegnazione)
									end
								end
							end
							if assign_list.item_for_iteration.name ~ "log" and then attached assign_list.item_for_iteration.attribute_by_name ("name") as name then
								create finta.make_with_id (name.value)
								transizione.set_azione (finta)
							end
							assign_list.forth
						end
						if attached stati.item (id_stato) as si_c then
							si_c.agg_trans (transizione)
						end
					else
						if attached stati.item (id_stato) as si_c then
							print ("lo stato" + si_c.id + "ha una transizione non valida %N")
						end
					end
				end
				transition_list.forth
			end
		end

	-- Aggiungere 'feature' per tracciare quanto accade scrivendo su file model_out.txt:
	--la SC costruita dal programma (cioè il file model.xml letto)
	--la configurazione iniziale in termini di stato e nomi-valori delle condizioni
	--l'evoluzione della SC in termini di sequenza di quintuple:
	--stato, evento, condizione, azione, target

feature --eventi

--	leggi_prossimo_evento: STRING
--			-- Questa serve a leggere l'evento corrente

--		do
--			Result := eventi [count_evento_corrente]
--			count_evento_corrente := count_evento_corrente + 1
--		end

	acquisisci_eventi: ARRAY [STRING]
			-- Legge gli eventi dal file 'eventi.txt' e li inserisce in un vettore

		local
			file: PLAIN_TEXT_FILE
			v_eventi: ARRAY [STRING]
			i: INTEGER
		do
			create v_eventi.make_empty
			create file.make_open_read ("eventi.txt")
			from
				i := 1
			until
				file.off
			loop
				file.read_line
				v_eventi.force (file.last_string.twin, i)
				i := i + 1
			end
			file.close
			Result := v_eventi
		end

		--			ottieni_evento: STRING --serve a verificare che tutti gli eventi nel file eventi.txt compaiano effettivamente
		--								   --tra gli eventi di qualche transizione
		--					  local
		--					    evento_letto: STRING
		--				do
		--					Result := ""
		--						  FROM
		--						    evento_letto := leggi_prossimo_evento
		--						  UNTIL
		--						    count_evento_corrente>eventi.count
		--						  LOOP
		--						    messaggio_di_errore(evento_letto non è un evento legale)
		--						    evento_letto := leggi_prossimo_evento
		--						  END
		--						  IF evento_letto IN eventi THEN
		--						    Result := evento_letto
		--				end

	verifica_eventi: ARRAY [STRING]
			--Serve a verificare che tutti gli eventi nel file eventi.txt compaiano effettivamente tra gli eventi di qualche transizione
			--Comunica a video se ci sono eventi incompatibili
		local
			v_new, v_old: ARRAY [STRING]
			h_stati: HASH_TABLE [STATO, STRING]
			i, j, k: INTEGER
			flag, flag_1: BOOLEAN
		do
			create v_new.make_empty
			h_stati := current.stati
			v_old := current.eventi
			k := 1
			from
				i := 1
			until
				i = eventi.count + 1
			loop
				flag := False
				from
					h_stati.start
				until
					h_stati.after OR flag
				loop
					flag_1 := False
					if attached h_stati.item_for_iteration.get_events as tp then
						from
							j := 1
						until
							j = tp.count + 1 or flag_1
						loop
							if tp [j] ~ v_old [i] then
								v_new.force (v_old [i].twin, k)
								k := k + 1
								flag_1 := True
								flag := True
							else
								j := j + 1
							end
						end
					end
					h_stati.forth
				end
				if NOT flag then
					print ("%N SANTIDDIO!! L'evento " + v_old [i] + " non viene utilizzato!")
				end
				i := i + 1
			end
			Result := v_new
		end

end
