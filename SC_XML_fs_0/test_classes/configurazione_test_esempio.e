note
	description: "Summary description for {CONFIGURAZIONE_TEST_ESEMPIO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONFIGURAZIONE_TEST_ESEMPIO

inherit
	CONFIGURAZIONE_TEST
		redefine on_prepare end

feature -- Test routines

	on_prepare
		do
		    precursor
			nomi_files_prova[1] := test_data_dir + "esempio.xml"
			nomi_files_prova[2] := test_data_dir
		end

 feature -- Test "Esempio"

	t_esempio_1
			-- Il processo dovrebbe arrestarsi nello stato "three" con le condizioni "alfa" e "beta" vere e "gamma" falsa.
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_1.txt"
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (three)", ep.state_chart.stato_corrente.id.is_equal ("three") )
				assert ("ERRORE il sistema non ha aggiornato correttamente le condizioni", ep.state_chart.condizioni.item ("alfa") and ep.state_chart.condizioni.item ("beta") and not ep.state_chart.condizioni.item ("gamma") )
			end
		end

	t_esempio_2
			-- Il processo dovrebbe arrestarsi nello stato "one" con le condizioni "alfa" e "beta" vere e "gamma" falsa.
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_2.txt"
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (one)", ep.state_chart.stato_corrente.id.is_equal ("one") )
				assert ("ERRORE il sistema non ha aggiornato correttamente le condizioni", ep.state_chart.condizioni.item ("alfa") and ep.state_chart.condizioni.item ("beta") and not ep.state_chart.condizioni.item ("gamma") )
			end
		end

	t_esempio_3
			-- Il processo dovrebbe arrestarsi nello stato "one" con le condizioni "alfa" e "gamma" false e "beta" vera.
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_3.txt"
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (one)", ep.state_chart.stato_corrente.id.is_equal ("one") )
				assert ("ERRORE il sistema non ha aggiornato correttamente le condizioni", not ep.state_chart.condizioni.item ("alfa") and ep.state_chart.condizioni.item ("beta") and not ep.state_chart.condizioni.item ("gamma") )
			end
		end

	t_esempio_4
			-- Il processo dovrebbe arrestarsi nello stato "two" con le condizioni "alfa" e "gamma" false e "beta" vera.
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_4.txt"
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (one)", ep.state_chart.stato_corrente.id.is_equal ("one") )
				assert ("ERRORE il sistema non ha aggiornato alfa", not ep.state_chart.condizioni.item ("alfa") )
				assert ("ERRORE il sistema non ha aggiornato beta", ep.state_chart.condizioni.item ("beta") )
				assert ("ERRORE il sistema non ha aggiornato gamma", not ep.state_chart.condizioni.item ("gamma") )
			end
		end

	t_esempio_5
			-- Il processo dovrebbe arrestarsi nello stato "one" con le condizioni "alfa", "beta" e "gamma" false.
			-- Verifica se posso compiere più azioni.
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_5.txt"
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (one)", ep.state_chart.stato_corrente.id.is_equal ("one") )
				assert ("ERRORE il sistema non ha aggiornato alfa", not ep.state_chart.condizioni.item ("alfa") )
				assert ("ERRORE il sistema non ha aggiornato beta", not ep.state_chart.condizioni.item ("beta") )
				assert ("ERRORE il sistema non ha aggiornato gamma", not ep.state_chart.condizioni.item ("gamma") )
			end
		end

	t_esempio_6
			-- Il processo dovrebbe arrestarsi nello stato "one" con le condizioni "alfa", "beta" e "gamma" false.
			-- Verifica funzionamento con evento non esistente.
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_verifica.txt"
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (one)", ep.state_chart.stato_corrente.id.is_equal ("one") )
				assert ("ERRORE il sistema non ha aggiornato alfa", not ep.state_chart.condizioni.item ("alfa") )
				assert ("ERRORE il sistema non ha aggiornato beta", not ep.state_chart.condizioni.item ("beta") )
				assert ("ERRORE il sistema non ha aggiornato gamma", not ep.state_chart.condizioni.item ("gamma") )
			end
		end

end
