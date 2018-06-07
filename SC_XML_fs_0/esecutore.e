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
	stato_corrente: STATO
	transizione_corrente: detachable TRANSIZIONE
--	prova: detachable STATO_XOR
			-- da cancellare, solo per avere l'elenco delle features di STATO_XOR in EiffelStudio

			-- memorizza gli eventi letti dal file
			-- l'array rappresenta gli istanti mentre ogni hash_table l'insieme degli eventi che occorrono nell'istante specifico

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
			stato_corrente := state_chart.stato_iniziale
			print ("e la esegue con gli eventi in " + nomi_files [2] + "%N")
			create eventi.make_empty
			eventi.acquisisci_eventi (nomi_files [2])
			print ("acquisiti eventi %N")
			if not eventi.verifica_eventi_esterni(state_chart) then
				print ("WARNING nel file ci sono eventi che la SC non conosce %N")
			end
			print ("eventi verificati, si esegue la SC %N")
			evolvi_SC (eventi.eventi_esterni)
		end

feature --evoluzione SC

	evolvi_SC (istanti: ARRAY [LINKED_SET [STRING]])
		local
			count_istante_corrente: INTEGER
--			nuovo_stato: detachable STATO
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
					transizione_corrente := stato_corrente.transizione_abilitata (istante_corrente, state_chart.condizioni)
					count_istante_corrente := count_istante_corrente + 1
					if attached transizione_corrente as tc then
						esegui_azioni (tc)
						stato_corrente := trova_default (tc.target)
					end
				end
			end
			print ("%N%NHo terminato l'elaborazione degli eventi nello stato = " + stato_corrente.id + "%N")
		end

	trova_default (stato: STATO): STATO
		do
			if stato /= stato.stato_default then
				if attached stato.stato_default.onentry as oe then
					oe.action (state_chart.condizioni)
				end
				result := trova_default( stato.stato_default )
			else
				result := stato
			end
		end

	esegui_azioni (transizione: TRANSIZIONE)
		local
			contesto: detachable STATO
		do
			contesto := trova_contesto (stato_corrente, transizione.target)
			esegui_azioni_onexit (stato_corrente, contesto)
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

end
