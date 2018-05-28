note
	description: "La classe che rappresenta la statechart"
	author: "Daniele Fakhoury & Eloisa Scarsella & Luca Biondo & Simone Longhi"
	date: "20 aprile 2018"
	revision: "2"

class
	CONFIGURAZIONE

create
	make

feature --attributi

	stato_corrente: STATO

	stato_iniziale: STATO

	transizione_corrente: detachable TRANSIZIONE
			-- la transizione che deve essere eseguita

		--	eventi: ARRAY [STRING]
		--			-- serve durante la lettura degli eventi dal file

	stati: HASH_TABLE [STATO, STRING]
			-- serve durante l'istanziazione iniziale di stati, transizione e configurazione
			-- una volta che è terminata non serve più

	condizioni: HASH_TABLE [BOOLEAN, STRING]
			-- serve durante l'istanziazione iniziale di stati, transizione e configurazione
			-- una volta che è terminata non serve più

	albero: XML_CALLBACKS_NULL_FILTER_DOCUMENT
			-- rappresenta sotto forma di un albero la SC letta dal file

feature --creazione

	make (nome_SC: STRING)
		do
			create stato_iniziale.make_with_id(create {STRING}.make_empty)
			stato_iniziale.set_final
			crea_albero (nome_SC)
			create stati.make (1)
			create condizioni.make (1)
			crea_stati_e_condizioni
			stato_corrente := stato_iniziale
		end

feature --evoluzione SC

	crea_albero (nome_file_SC: STRING)
			-- crea e inizializza `albero'
		local
			parser: XML_PARSER
		do
				--| Instantiate parser
			create {XML_STANDARD_PARSER} parser.make
				--| Build tree callbacks
			create albero.make_null
			parser.set_callbacks (albero)
				--| Parse the `file_name' content
			parser.parse_from_filename (nome_file_SC)
			if parser.error_occurred then
				print ("Parsing error!!! %N")
			else
				print ("Parsing OK. %N")
			end
		end

	evolvi_SC (istanti: ARRAY [LINKED_SET [STRING]])
		local
			count_istante_corrente: INTEGER
			nuovo_stato: detachable STATO
		do
			print ("%Nentrato in evolvi_SC:  %N %N")
			print ("stato iniziale:  " + stato_corrente.id + "       %N")
			FROM
				count_istante_corrente := 1
			UNTIL
				stato_corrente.finale or count_istante_corrente > istanti.count
			LOOP
				if attached istanti [count_istante_corrente] as istante_corrente then
					print ("Stampa indice istante corrente = ")
					print (count_istante_corrente)
					print ("   %N")
					transizione_corrente := stato_corrente.transizione_abilitata (istante_corrente, condizioni)
					count_istante_corrente := count_istante_corrente + 1
					if attached transizione_corrente as tc then
						esegui_azioni (tc)
						stato_corrente := tc.target.stato_default
					end
				end
			end
			print ("%N%NHo terminato l'elaborazione degli eventi nello stato = " + stato_corrente.id + "%N")
		end

	esegui_azioni (transizione: TRANSIZIONE)
		local
			i: INTEGER
			azioni_nel_percorso: detachable ARRAY [AZIONE]
		do
			if attached stato_corrente.onexit as oe then
				oe.action (condizioni)
			end
			azioni_nel_percorso := calcola_azioni
			from
				i := 1
			until
				i = transizione.azioni.count + 1
			loop
				transizione.azioni [i].action (condizioni)
				i := i + 1
			end
			if attached azioni_nel_percorso as ap then
				from
					i := 1
				until
					i = azioni_nel_percorso.count + 1
				loop
					azioni_nel_percorso.item (i).action (condizioni)
				end
			end
			if attached transizione.target.onexit as ox then
				ox.action (condizioni)
			end
		end

	calcola_azioni: detachable ARRAY [AZIONE]
		local
			azioni: ARRAY [AZIONE]
			stop: BOOLEAN
			stato_gen_corrente: STATO
			stato_gen_target: STATO
		do
			create azioni.make_empty
			create stato_gen_corrente.make_with_id(create {STRING}.make_empty)
			create stato_gen_target.make_with_id(create {STRING}.make_empty)
			stop := FALSE
			if attached stato_corrente.stato_genitore as ssg then
				if attached transizione_corrente as tc then
					if attached tc.target.stato_genitore as tsg then
						stato_gen_corrente := ssg
						stato_gen_target := tsg
						if ssg.id ~ tsg.id then
							stop := TRUE
						end
					end
				end
			end
			from
			until
				stop = TRUE
			loop
				if attached stato_gen_corrente.onexit as ox then
					azioni.force (ox, azioni.count + 1)
				end
				if attached stato_gen_target.onentry as oe then
					azioni.force (oe, azioni.count + 1)
				end
				if attached stato_gen_corrente.stato_genitore as ssg then
					if attached stato_gen_target.stato_genitore as tsg then
						stato_gen_corrente := ssg
						stato_gen_target := tsg
						if ssg.id ~ tsg.id then
							stop := TRUE
						end
					end
				end
				if stato_gen_corrente.stato_genitore = VOID and stato_gen_target.stato_genitore = VOID then
					stop := TRUE
				end
			end
		end

	stabilizza_stato
			-- assicura che stato_stabile sia stabile eseguendo tutte le transizioni
		local
			evento: detachable STRING
			-- 	require  stato_corrente.numero_transizioni_abilitate(evento,condizioni) <2
		do
				--			if attached evento as e then
				--				if attached stato_corrente.target (e, condizioni) as sc_tse then
				--					set_stato_corrente (sc_tse)
				--					if stato_corrente.numero_transizioni_abilitate (e, condizioni) = 1 then
				--						stabilizza_stato
				--					end
				--				end
				--			end
		end

feature -- inizializzazione SC

	set_stato_corrente (uno_stato: STATO)
		require
			stato_corrente_not_void: stato_corrente /= Void
		do
			stato_corrente := uno_stato
			print ("%N %Nnuovo stato corrente = " + stato_corrente.id + "    %N")
		end

	istanzia_condizioni (lis_data: LIST [XML_ELEMENT])
			-- istanzia nella SC le condizioni presenti in <datamodel>
		do
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
				-- condizione_vuota è una condizione sempre true che si applica alle transizioni che hanno condizione void (cfr riempi_stato)
		end

	istanzia_condizioni_e_final (lis_el: LIST [XML_ELEMENT])
			-- istanzia nella SC gli stati presenti in <state> e le condizioni presenti in <datamodel>
		do
			from
				lis_el.start
			until
				lis_el.after
			loop
				if lis_el.item_for_iteration.name ~ "final" and then attached lis_el.item_for_iteration.attribute_by_name ("id") as att then
					stati.extend (create {STATO}.make_final_with_id (att.value), att.value)
--				elseif lis_el.item_for_iteration.name ~ "state" and then attached lis_el.item_for_iteration.attribute_by_name ("id") as att then
--					stati.extend (create {STATO}.make_with_id (att.value), att.value)
				elseif lis_el.item_for_iteration.name ~ "datamodel" and then attached lis_el.item_for_iteration.elements as lis_data then
					istanzia_condizioni (lis_data)
				end
				lis_el.forth
			end
		end

istanzia_stati (lis_el: LIST [XML_ELEMENT]; p_genitore: detachable STATO)
	local stato_temp: STATO
	do
			from
				lis_el.start
			until
				lis_el.after
			loop
				if lis_el.item_for_iteration.name ~ "state" and then attached lis_el.item_for_iteration.attribute_by_name ("id") as att then
					if lis_el.item_for_iteration.has_element_by_name ("state") then -- elemento corrente ha figli
						-- se p_genitore diverso da Void va aggiunta la relazione genitore-figlio
						if attached {STATO_XOR} p_genitore as pg then
							stato_temp := create {STATO_XOR}.make_with_id(att.value)
							stato_temp.set_genitore (pg)
							stati.extend (stato_temp, att.value)
							pg.add_figlio (stato_temp)
						else
							stati.extend (create {STATO_XOR}.make_with_id (att.value), att.value)
						end
							istanzia_stati (lis_el.item_for_iteration.elements, stati.item (att.value))
					else -- elemento corrente non ha figli
						if attached {STATO_XOR} p_genitore as pg then -- elemento corrente ha genitore
							stato_temp := create {STATO}.make_with_id_and_parent (att.value, pg)
							stati.extend (stato_temp, att.value)
							pg.add_figlio (stato_temp)
						else -- elemento corrente non ha neanche genitore
							stati.extend (create {STATO}.make_with_id (att.value), att.value)
						end
					end
				end
				lis_el.forth
			end
		end

	inizializza_stati (lis_el: LIST [XML_ELEMENT])
			-- assegna agli stati presenti nella SC le transizioni con eventi e azioni
		do
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

	set_stati_default (lis_el: LIST [XML_ELEMENT])
			-- assegna agli stati presenti nella SC le transizioni con eventi e azioni
		do
			from
				lis_el.start
			until
				lis_el.after
			loop
				if lis_el.item_for_iteration.name ~ "state" and then attached lis_el.item_for_iteration.attribute_by_name ("id") as stato then
					if attached lis_el.item_for_iteration.attribute_by_name ("initial") as df then
						if attached stati.item (df.value) as st_df then
							if attached stati.item (stato.value) as pr then
								pr.set_stato_default(st_df)
							end
						end
					end
					if lis_el.item_for_iteration.has_element_by_name ("state") then -- elemento corrente ha figli
						set_stati_default (lis_el.item_for_iteration.elements)
					end
				end
				lis_el.forth
			end
		end

	imposta_stato_iniziale (radice: XML_ELEMENT)
		do
			if attached radice.attribute_by_name ("initial") as si then
				if attached stati.item (si.value) as v then
					if attached v.stato_default as df then
						if not df.id.is_equal (v.id) then
							inizializza_stati_ricorsivo (df)
						else
							stato_iniziale := v
						end
					else
						stato_iniziale := v
					end
				else
					print ("ERRORE: lo stato indicato come 'initial' non è uno degli stati in <state>")
				end
			else
				-- l'assenza di "initial" deve essere gestita scegliendo il primo dei figli se lo stato ha figli
				-- oppure scegliendo sé stesso se lo stato non ha figli
				-- oppure segnalando errore se il nodo è la radice <scxml>
				print ("ERRORE: manca lo stato 'initial' nel file e non c'è la gestione della sua assenza")
					-- TODO gestire la scelta dello stato iniziale in caso di assenza dell'attributo 'initial' nel file .xml
			end
		end

	inizializza_stati_ricorsivo ( stato: STATO)
		do
			if attached stato.stato_default as df then
				if not df.id.is_equal (stato.id) then
					inizializza_stati_ricorsivo (df)
				else
					stato_iniziale := stato
				end
			end
		end

	crea_stati_e_condizioni
			--	riempie le hashtable degli stati e delle condizioni
			--	inizializza ogni stato con le sue transizioni con eventi ed azioni
		do
			if attached {XML_ELEMENT} albero.document.first as f and then attached f.elements as lis_el then
				istanzia_condizioni_e_final (lis_el)
				istanzia_stati (lis_el, Void)
				set_stati_default (lis_el)
				imposta_stato_iniziale (f)
				inizializza_stati (lis_el)
			end
		end

	assegnazione_azioni (assign_list: LIST [XML_ELEMENT]; transizione: TRANSIZIONE)
			--viene richiamata in riempi_stato; assegna le azioni alla transizione

		local
			i: INTEGER
		do
			i := 1
			from
				assign_list.start
			until
				assign_list.after
			loop
				if assign_list.item_for_iteration.name ~ "assign" then
					if attached assign_list.item_for_iteration.attribute_by_name ("location") as luogo and then attached assign_list.item_for_iteration.attribute_by_name ("expr") as expr then
						if expr.value ~ "false" then
							transizione.azioni.force (create {ASSEGNAZIONE}.make_with_cond_and_value (luogo.value, FALSE), i)
						elseif expr.value ~ "true" then
							transizione.azioni.force (create {ASSEGNAZIONE}.make_with_cond_and_value (luogo.value, TRUE), i)
						end
					end
				end
				if assign_list.item_for_iteration.name ~ "log" and then attached assign_list.item_for_iteration.attribute_by_name ("name") as name then
					if attached name.value then
						transizione.azioni.force (create {STAMPA}.make_with_text (name.value), i)
					end
				end
				i := i + 1
				assign_list.forth
			end
				--TODO: creare vettore di azioni generiche
		end

	assegnazione_evento (transition_list: LIST [XML_ELEMENT]; transizione: TRANSIZIONE)
		do
			if attached transition_list.item_for_iteration.attribute_by_name ("event") as event then
				transizione.set_evento (event.value)
			end
		end

	assegnazione_condizione (transition_list: LIST [XML_ELEMENT]; transizione: TRANSIZIONE)
		do
			if attached transition_list.item_for_iteration.attribute_by_name ("cond") as cond then
				transizione.set_condizione (cond.value)
			else
				transizione.set_condizione ("condizione_vuota")
			end
		end

	riempi_stato (id_stato: STRING; element: XML_ELEMENT)
		local
			transition_list: LIST [XML_ELEMENT]
			assign_list: LIST [XML_ELEMENT]
			transizione: TRANSIZIONE
		do
			transition_list := element.elements
			from
				transition_list.start
			until
				transition_list.after
			loop

					-- TODO gestire separatamente feature di creazione transizione che torna o transizione o errore
				if transition_list.item_for_iteration.name ~ "transition" and then attached transition_list.item_for_iteration.attribute_by_name ("target") as tt then
						-- TODO gestire fallimento del test per assenza clausola target
					if attached stati.item (tt.value) as ts then
						create transizione.make_with_target (ts)
						assegnazione_evento (transition_list, transizione)
						assegnazione_condizione (transition_list, transizione)
						assign_list := transition_list.item_for_iteration.elements
						assegnazione_azioni (assign_list, transizione)
						if attached stati.item (id_stato) as si then
							si.aggiungi_transizione (transizione)
						end
					else
						if attached stati.item (id_stato) as si then
							print ("lo stato" + si.id + "ha una transizione non valida %N")
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

end
