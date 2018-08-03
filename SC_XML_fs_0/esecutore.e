note
	description: "Classe radice del progetto"
	author: " Daniele Fakhoury & Eloisa Scarsella "
	date: "$Date$"
	revision: "  "

class
	ESECUTORE

create
	start --, make

feature -- Attributi

	state_chart: CONFIGURAZIONE
			-- rappresenta la SC durante la sua esecuzione

	eventi: AMBIENTE

	stato_corrente: ARRAY [STATO]

	transizione_corrente: detachable TRANSIZIONE

feature {NONE} -- Inizializzazione

	start (nomi_files: ARRAY [STRING])
			-- prepara la SC e avvia la sua esecuzione
			-- i parametri vanno scritti con la loro estensione in Eiffel Studio con
			-- menu "Execution" -> "Execution Parameters" -> "Add"
			-- doppio click su spazio bianco accanto a "Arguments"
			-- scrivere i parametri ognuno tra doppi apici
		do
			print ("INIZIO!%N")
			print ("crea la SC in " + nomi_files [1] + "%N")
			create state_chart.make (nomi_files [1])
			create stato_corrente.make_empty
			stato_corrente.copy (state_chart.stato_iniziale)
			create eventi.make_empty
			if not state_chart.ha_problemi_con_il_file_della_sc then
				print ("e la esegue con gli eventi in " + nomi_files [2] + "%N")
				eventi.acquisisci_eventi (nomi_files [2])
				print ("acquisiti eventi %N")
				if not eventi.verifica_eventi_esterni (state_chart) then
					print ("WARNING nel file ci sono eventi che la SC non conosce %N")
				end
				print ("eventi verificati, si esegue la SC %N")
				evolvi_SC (eventi.eventi_esterni)
			else
				print ("Ci sono problemi con il file xml.%N")
				print ("Programma terminato.%N")
			end
		end

feature --evoluzione SC

	evolvi_SC (istanti: ARRAY [LINKED_SET [STRING]])
		local
			count_istante_corrente: INTEGER
			i: INTEGER
			nuovo_stato_corrente: ARRAY [STATO]
			condizioni_correnti: HASH_TABLE [BOOLEAN, STRING]
		do
			print ("%Nentrato in evolvi_SC:  %N %N")
			print ("stato iniziale:  ")
			stampa_stati (stato_corrente)
			create condizioni_correnti.make (1)
			from
				count_istante_corrente := 1
			until
				stato_final (stato_corrente) or count_istante_corrente > istanti.count
			loop
				if attached istanti [count_istante_corrente] as istante_corrente then
					print ("Stampa indice istante corrente = ")
					print (count_istante_corrente)
					print ("   %N")
					condizioni_correnti.copy (state_chart.condizioni)
					create nuovo_stato_corrente.make_empty
					from
						i := stato_corrente.lower
					until
						i = stato_corrente.upper + 1
					loop
						transizione_corrente := stato_corrente [i].transizione_abilitata (istante_corrente, condizioni_correnti)
						if attached transizione_corrente as tc then
							esegui_azioni (tc, stato_corrente [i])
							trova_default (tc.target, nuovo_stato_corrente)
						else
							nuovo_stato_corrente.force (stato_corrente [i], nuovo_stato_corrente.count + 1)
						end
						i := i + 1
					end
					if not nuovo_stato_corrente.is_empty then
						stato_corrente.copy (nuovo_stato_corrente)
					end
				end
				count_istante_corrente := count_istante_corrente + 1
				stampa_stati (stato_corrente)
			end
			print ("%N%NHo terminato l'elaborazione degli eventi nello stato = ")
			stampa_stati (stato_corrente)
		end

	trova_default (stato: STATO; nuovo_stato_corrente: ARRAY [STATO])
		local
			i: INTEGER
		do
			if not stato.stato_default.is_empty then
				from
					i := stato.stato_default.lower
				until
					i = stato.stato_default.upper + 1
				loop
					if attached stato.stato_default [i].onentry as oe then
						oe.action (state_chart.condizioni)
					end
					trova_default (stato.stato_default [i], nuovo_stato_corrente)
					i := i + 1
				end
			else
				nuovo_stato_corrente.force (stato, nuovo_stato_corrente.count + 1)
			end
		end

--	trova_stato_corrente (target: STATO)
--	local
--		nuovo_stato: ARRAY[STATO]
--		stati_figli_temp: ARRAY[STATO]
--	do
--		create nuovo_stato.make_empty
--		create stati_figli_temp.make_empty
--		if attached target.stato_genitore as sg then
--			if attached {STATO_XOR} sg.stato_genitore as sgg then
--				nuovo_stato.force (target, nuovo_stato.count + 1)
--				stato_corrente.copy (nuovo_stato)
--			elseif attached {STATO_AND} sg.stato_genitore as sgg then
--				stati_figli_temp.copy (sgg.stati_figli)
--				nuovo_stato.force (stati_figli_temp.item (0).stato_default, nuovo_stato.count + 1)
--				nuovo_stato.force (stati_figli_temp.item (1).stato_default, nuovo_stato.count + 1)
--				stato_corrente.copy (nuovo_stato)
--			else
--				nuovo_stato.force (target, nuovo_stato.count + 1)
--				stato_corrente.copy (nuovo_stato)
--			end
--		else
--			nuovo_stato.force (target, nuovo_stato.count + 1)
--			stato_corrente.copy (nuovo_stato)
--		end
--	end

	esegui_azioni (transizione: TRANSIZIONE; stato: STATO)
		local
			contesto: detachable STATO
		do
			if transizione.internal then
				contesto := transizione.sorgente
			else
				contesto := trova_contesto (transizione.sorgente, transizione.target)
			end
			esegui_azioni_onexit (stato, contesto)
			esegui_azioni_transizione (transizione.azioni)
			esegui_azioni_onentry (contesto, transizione.target)
		end

	trova_contesto (p_sorgente, p_destinazione: STATO): detachable STATO
			-- trova il contesto in base alla specifica SCXML secondo cui il contesto
			-- è il minimo antenato comune PROPRIO a p_sorgente e p_destinazione
		local
			antenati: HASH_TABLE [STRING, STRING]
			corrente: STATO
		do
			create antenati.make (0)
				-- "marca" tutti gli antenati di p_sorgente incluso
			from
				corrente := p_sorgente.stato_genitore
			until
				corrente = Void
			loop
				antenati.put (corrente.id, corrente.id)
				corrente := corrente.stato_genitore
			end
				-- trova il più basso antenato di p_destinazione in "antenati"
			from
				corrente := p_destinazione
			until
				corrente = Void or else antenati.has (corrente.id)
			loop
				corrente := corrente.stato_genitore
			end
			Result := corrente
		end

	esegui_azioni_onexit (p_stato_corrente: STATO; p_contesto: detachable STATO)
		do
			if p_stato_corrente /= p_contesto then
				if attached p_stato_corrente.onexit as ox then
					ox.action (state_chart.condizioni)
				end
				if attached p_stato_corrente.stato_genitore as sg then
					esegui_azioni_onexit (sg, p_contesto)
				end
			end
		end

	esegui_azioni_transizione (p_azioni: ARRAY [AZIONE])
		local
			i: INTEGER
		do
			from
				i := p_azioni.lower
			until
				i = p_azioni.upper + 1
			loop
				p_azioni [i].action (state_chart.condizioni)
				i := i + 1
			end
		end

	esegui_azioni_onentry (p_contesto: detachable STATO; p_target: STATO)
		do
			if p_target /= p_contesto and then attached p_target.stato_genitore as sg then
				esegui_azioni_onentry (p_contesto, sg)
			end
			if p_target /= p_contesto and then attached p_target.onentry as oe then
				oe.action (state_chart.condizioni)
			end
		end

	stato_final (stato: ARRAY [STATO]): BOOLEAN
		require
			contesto: stato_corrente /= VOID
		local
			i: INTEGER
		do
			from
				i := stato_corrente.lower
			until
				i = stato_corrente.upper + 1
			loop
				if stato_corrente [i].finale then
					result := TRUE
				end
				i := i + 1
			end
		end

	stampa_stati (stati: ARRAY [STATO])
		local
			i: INTEGER
		do
			from
				i := stati.lower
			until
				i = stati.upper + 1
			loop
				print (stati [i].id + " ")
				i := i + 1
			end
			print (" %N")
		end

end
