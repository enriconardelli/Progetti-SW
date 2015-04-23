note
	description: "Summary description for {ESECUTORE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ESECUTORE

create
	start

feature --Attributi
	--	conf: CONFIGURAZIONE

	stati: HASH_TABLE [STATO, STRING]

	condizioni: HASH_TABLE [BOOLEAN, STRING]
			-- serve durante l'istanziazione iniziale di stati, transizione e configurazione
			-- una volta che è terminata non serve più
			--	condizioni: HASH_TABLE [STRING, STRING]
			--eventi: ARRAY[STRING]
			-- serve durante la lettura degli eventi dal file

	count_evento_corrente: INTEGER --tiene il conto del numero di eventi già processati,
			--serve per la leggi_prossimo_evento

	eventi: ARRAY [STRING]

feature {NONE} -- Inizializzazione

	start
			-- Run application.
		local
				--	s: SIMPLE
			s_orig: SIMPLE_MODIFIED
			albero: XML_CALLBACKS_NULL_FILTER_DOCUMENT
		do
			create stati.make (1)
			create condizioni.make (1)
			print ("INIZIO!%N")
				--			create s.make
				--			print ("FINITO 1 !%N")
				--			io.read_character
			create s_orig.make
			print ("FINE!%N")
			albero := s_orig.tree
			crea_stati_e_cond (albero)
			eventi := acquisisci_eventi
			print ("cristiano è brutto")
		end

feature -- Cose che si possono fare

	evolvi_SC
		do
				--  FROM
				--  UNTIL
				--    conf.stato_corrente.finale
				--  LOOP
				--    conf.chiusura
				--  IF evento_corrente /= "" THEN
				--    IF NOT conf.stato_corrente.determinismo(evento_corrente) THEN
				--      messaggio_di_errore
				--    ELSE
				--      conf.stato_corrente := conf.stato_corrente.target(evento_corrente)
		end

	crea_stati_e_cond (albero: XML_CALLBACKS_NULL_FILTER_DOCUMENT)
			--				questa feature dovra creare l'hashtable con gli stati istanziati e le transizioni,
			--				anche garantendo che le transizioni hanno target leciti
		local
			temp_stato: STATO
			first: XML_NODE
			tempatt: detachable XML_ATTRIBUTE
			lis_el: LIST [XML_ELEMENT]
			lis_data: LIST [XML_ELEMENT]
		do
			first := albero.document.first
			if attached {XML_ELEMENT} first as f then
				lis_el := f.elements
				from
					lis_el.start
				until
					lis_el.after
				loop
					if lis_el.item_for_iteration.name ~ "state" then
						tempatt := lis_el.item_for_iteration.attribute_by_name ("id")
						if attached tempatt as asd then
							create temp_stato.make_with_id (asd.value)
							stati.extend (temp_stato, asd.value)
						end
					elseif lis_el.item_for_iteration.name ~ "datamodel" then
						lis_data := lis_el.item_for_iteration.elements
						from
							lis_data.start
						until
							lis_data.after
						loop
							if attached {XML_ATTRIBUTE} lis_data.item_for_iteration.attribute_by_name ("id") as nome then
								if attached {XML_ATTRIBUTE} lis_data.item_for_iteration.attribute_by_name ("expr") as valore then
									condizioni.extend (valore.value ~ "1", nome.value)
								end
							end
							lis_data.forth
						end
					end
					lis_el.forth
				end
					--stati istanziati, ora li riempiamo
				from
					lis_el.start
				until
					lis_el.after
				loop
					if lis_el.item_for_iteration.name ~ "state" then
						tempatt := lis_el.item_for_iteration.attribute_by_name ("id")
						if attached tempatt as asd then
							riempi_stato (asd.value, lis_el.item_for_iteration)
						end
					end
					lis_el.forth
				end
			end
		end

	riempi_stato (chiave: STRING; element: XML_ELEMENT)
		local
			temp_stato: DETACHABLE STATO
			lis_el: LIST [XML_ELEMENT]
			transizione: TRANSIZIONE
			azione: detachable XML_ATTRIBUTE
			event: detachable XML_ATTRIBUTE
			con: detachable XML_ATTRIBUTE
			target: detachable XML_ATTRIBUTE
		do
			lis_el := element.elements
			from
				lis_el.start
			until
				lis_el.after
			loop
				if lis_el.item_for_iteration.name ~ "transition" then
					target := lis_el.item_for_iteration.attribute_by_name ("target")
					if attached target then
						if attached stati.item (target.value) as fabio then
							create transizione.make_with_target (fabio)
							event := lis_el.item_for_iteration.attribute_by_name ("event")
							if attached event then
								transizione.set_evento (event.value)
							end
							con := lis_el.item_for_iteration.attribute_by_name ("condition") -- non sappiamo come l'xml chiama le condizioni
							if attached con then
								transizione.set_condizione (con.value)
							end
							azione := lis_el.item_for_iteration.attribute_by_name ("action")
								--							if attached azione then
								--								transizione.set_azione (azione.value)
								--							end
							temp_stato := stati.item (chiave)
							if attached temp_stato then
								temp_stato.agg_trans (transizione)
							end
						else
							temp_stato := stati.item (chiave)
							if attached temp_stato then
								print ("lo stato" + temp_stato.id + "ha una transizione non valida %N")
							end
						end
					end
				end
				lis_el.forth
			end
		end

		-- Aggiungere 'feature' per tracciare quanto accade scrivendo su file model_out.txt:
		--la SC costruita dal programma (cioè il file model.xml letto)
		--la configurazione iniziale in termini di stato e nomi-valori delle condizioni
		--l'evoluzione della SC in termini di sequenza di quintuple:
		--stato, evento, condizione, azione, target

feature --eventi

	leggi_prossimo_evento: STRING
			-- Questa serve a leggere l'evento corrente

		do
			Result := eventi [count_evento_corrente]
			count_evento_corrente := count_evento_corrente + 1
		end

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
			--serve a verificare che tutti gli eventi nel file eventi.txt compaiano effettivamente tra gli eventi di qualche transizione
		local
			v_new: ARRAY [STRING]
			v_old: ARRAY [STRING]
			n: INTEGER
			h_stati: HASH_TABLE [STATO, STRING]
			k: INTEGER
			i: INTEGER
			flag: BOOLEAN
			de_bug: STRING
		do
			create v_new.make_empty
			h_stati := current.stati
			v_old := current.eventi
			n := current.eventi.count
			k := 1
			from
				i := 1
			until
				i = n + 1
			loop
				flag := False
				from
					h_stati.start
				until
					h_stati.after OR flag
				loop
					if attached h_stati.item_for_iteration as stato then
						if attached stato.get_events as tp then
							de_bug := v_old [i].twin    --QUI STA IL PROBLEMA, de_bug non è la stringa che ci aspettiamo
							if tp.has (v_old [i]) then
								v_new.force (v_old [i].twin, k)
								k := k + 1
								flag := True
							else
								h_stati.forth
							end
						end
					end
				end
				if h_stati.after then
					print ("%N SANTIDDIO!! L'evento " + v_old [i] + " non va bene!")
				end
				i := i + 1
			end
			Result := v_new
		end

end
