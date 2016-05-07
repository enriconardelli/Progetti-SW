note
	description: "Summary description for {CONFIGURAZIONE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONFIGURAZIONE

create
	make_with_condition

feature --attributi

	stato_corrente: STATO

	stato_iniziale: STATO

	eventi: ARRAY [STRING]
			-- serve durante la lettura degli eventi dal file

	stati: HASH_TABLE [STATO, STRING]
			-- serve durante l'istanziazione iniziale di stati, transizione e configurazione
			-- una volta che è terminata non serve più

	condizioni: HASH_TABLE [BOOLEAN, STRING]
			-- serve durante l'istanziazione iniziale di stati, transizione e configurazione
			-- una volta che è terminata non serve più

feature --creazione

	make_with_condition (gli_eventi: ARRAY [STRING]; albero: XML_CALLBACKS_NULL_FILTER_DOCUMENT)
		do
			create stato_iniziale.make_empty
			stato_iniziale.set_final
			create stati.make (1)
			create condizioni.make (1)
			crea_stati_e_condizioni (albero)
			stato_corrente := stato_iniziale
			eventi := gli_eventi
		end

feature --routines

	set_stato_corrente (uno_stato: STATO)
		require
			stato_corrente_not_void: stato_corrente /= Void
		do
			stato_corrente := uno_stato
		end

	evolvi_SC
		local
			count_evento_corrente: INTEGER
			evento_corrente: STRING
			nuovo_stato: detachable STATO
		do
			print ("%Nentrato in evolvi_SC:  %N %N")
			print ("stato iniziale:  " + stato_corrente.id + " %N %N")
			FROM
				count_evento_corrente := 1
			UNTIL
				stato_corrente.finale or count_evento_corrente > eventi.count
			LOOP
				stato_stabile
				evento_corrente := eventi [count_evento_corrente]
				count_evento_corrente := count_evento_corrente + 1
				print ("evento corrente = " + evento_corrente + "%N")
				IF NOT stato_corrente.determinismo (evento_corrente, condizioni) THEN
					print ("ERRORE!!! Non c'è determinismo!!!")
				ELSE
					nuovo_stato := stato_corrente.target (evento_corrente, condizioni)
					if attached nuovo_stato as ns then
						set_stato_corrente (ns)
						print ("nuovo stato corrente = " + ns.id + "%N")
							-- TODO inserire codice per eseguire azioni
					end
				end
			end
			if not stato_corrente.finale then
				stato_stabile
			end
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
				--						condizione_vuota è una condizione sempre true che si applica alle transizioni che hanno condizione void (cfr riempi_stato)
		end

	istanzia_stati_e_condizioni (lis_el: LIST [XML_ELEMENT])
			-- istanzia nella SC gli stati presenti in <state> e le condizioni presenti in <datamodel>
		do
			from
				lis_el.start
			until
				lis_el.after
			loop
				if lis_el.item_for_iteration.name ~ "final" and then attached lis_el.item_for_iteration.attribute_by_name ("id") as att then
						-- TODO gestire fallimento del test
					stati.extend (create {STATO}.make_final_with_id(att.value), att.value)
				elseif lis_el.item_for_iteration.name ~ "state" and then attached lis_el.item_for_iteration.attribute_by_name ("id") as att then
						-- TODO gestire fallimento del test
					stati.extend (create {STATO}.make_final_with_id(att.value), att.value)
				elseif lis_el.item_for_iteration.name ~ "datamodel" and then attached lis_el.item_for_iteration.elements as lis_data then
						-- TODO gestire fallimento del test
					istanzia_condizioni (lis_data)
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

	imposta_stato_iniziale (radice: XML_ELEMENT)
		do
			if attached radice.attribute_by_name ("initial") as si then
				if attached stati.item (si.value) as v then
					stato_iniziale := v
				else
					print ("ERRORE: lo stato indicato come 'initial' non è uno degli stati in <state>")
				end
			else
				print ("ERRORE: manca lo stato 'initial' nel file e non c'è la gestione della sua assenza")
					-- TODO gestire la scelta dello stato iniziale in caso di assenza dell'attributo 'initial' nel file .xml
			end
		end

	crea_stati_e_condizioni (albero: XML_CALLBACKS_NULL_FILTER_DOCUMENT)
			--	riempie le hashtable degli stati e delle condizioni
			--	inizializza ogni stato con le sue transizioni con eventi ed azioni
		do
			if attached {XML_ELEMENT} albero.document.first as f and then attached f.elements as lis_el then
					-- TODO gestire fallimento del test
				istanzia_stati_e_condizioni (lis_el)
				imposta_stato_iniziale (f)
				inizializza_stati (lis_el)
			end
		end


	assegnazione_azioni (assign_list: LIST [XML_ELEMENT]; transizione: TRANSIZIONE)
	--viene richiamata in riempi_stato; assegna le azioni alla transizione
		local
			assegnazione: ASSEGNAZIONE
			stampa: STAMPA
		do
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
					create stampa.make_with_text (name.value)
					transizione.set_azione (stampa)
				end
				assign_list.forth
			end
		end



assegnazione_eventi(transition_list: LIST [XML_ELEMENT]; transizione: TRANSIZIONE)
do
	if attached transition_list.item_for_iteration.attribute_by_name ("event") as event then
							transizione.set_evento (event.value)
						end
end




assegnazione_condizione(transition_list: LIST [XML_ELEMENT]; transizione: TRANSIZIONE)
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
				if transition_list.item_for_iteration.name ~ "transition" and then attached transition_list.item_for_iteration.attribute_by_name ("target") as target then
						-- TODO gestire fallimento del test per assenza clausola target
					if attached stati.item (target.value) as target_state then
						create transizione.make_with_target (target_state)
						assegnazione_eventi(transition_list, transizione)
				    	assegnazione_condizione(transition_list, transizione)
						assign_list := transition_list.item_for_iteration.elements
						assegnazione_azioni (assign_list, transizione)
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

	stato_stabile
			-- assicura che stato_stabile sia uno stato stabile eseguendo tutte le transizioni
		require
			controllo_determinismo: stato_corrente.determinismo_senza_evento (condizioni)
		do
			if attached stato_corrente.target_senza_evento (condizioni) as sc_tse then
				set_stato_corrente (sc_tse)
				if stato_corrente.determinismo_senza_evento (condizioni) then
					stato_stabile
				end
			end
		end

end
