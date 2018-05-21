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
			create configurazione_prova.make(nomi_files_prova[1])
		end

 feature -- Test "Esempio"

	t_esempio_1
			-- Il processo dovrebbe arrestarsi nello stato "three" con le condizioni "alfa" e "beta" vere e "gamma" falsa.
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_1.txt"
			ambiente_prova.acquisisci_eventi (nomi_files_prova[2])
			configurazione_prova.evolvi_SC (ambiente_prova.eventi_esterni)
			if attached configurazione_prova as cp then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (three)", cp.stato_corrente.id.is_equal ("three") )
				assert ("ERRORE il sistema non ha aggiornato correttamente le condizioni", cp.condizioni.item ("alfa") and cp.condizioni.item ("beta") and not cp.condizioni.item ("gamma") )
			end
		end

	t_esempio_2
			-- Il processo dovrebbe arrestarsi nello stato "one" con le condizioni "alfa" e "beta" vere e "gamma" falsa.
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_2.txt"
			ambiente_prova.acquisisci_eventi (nomi_files_prova[2])
			configurazione_prova.evolvi_SC (ambiente_prova.eventi_esterni)
			if attached configurazione_prova as cp then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (one)", cp.stato_corrente.id.is_equal ("one") )
				assert ("ERRORE il sistema non ha aggiornato correttamente le condizioni", cp.condizioni.item ("alfa") and cp.condizioni.item ("beta") and not cp.condizioni.item ("gamma") )
			end
		end

	t_esempio_3
			-- Il processo dovrebbe arrestarsi nello stato "one" con le condizioni "alfa" e "gamma" false e "beta" vera.
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_3.txt"
			ambiente_prova.acquisisci_eventi (nomi_files_prova[2])
			configurazione_prova.evolvi_SC (ambiente_prova.eventi_esterni)
			if attached configurazione_prova as cp then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (one)", cp.stato_corrente.id.is_equal ("one") )
				assert ("ERRORE il sistema non ha aggiornato correttamente le condizioni", not cp.condizioni.item ("alfa") and cp.condizioni.item ("beta") and not cp.condizioni.item ("gamma") )
			end
		end

	t_esempio_4
			-- Il processo dovrebbe arrestarsi nello stato "two" con le condizioni "alfa" e "gamma" false e "beta" vera.
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_4.txt"
			ambiente_prova.acquisisci_eventi (nomi_files_prova[2])
			configurazione_prova.evolvi_SC (ambiente_prova.eventi_esterni)
			if attached configurazione_prova as cp then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (one)", cp.stato_corrente.id.is_equal ("one") )
				assert ("ERRORE il sistema non ha aggiornato alfa", not cp.condizioni.item ("alfa") )
				assert ("ERRORE il sistema non ha aggiornato beta", cp.condizioni.item ("beta") )
				assert ("ERRORE il sistema non ha aggiornato gamma", not cp.condizioni.item ("gamma") )
			end
		end

	t_esempio_5
			-- Il processo dovrebbe arrestarsi nello stato "one" con le condizioni "alfa", "beta" e "gamma" false.
			-- Verifica se posso compiere più azioni.
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_5.txt"
			ambiente_prova.acquisisci_eventi (nomi_files_prova[2])
			configurazione_prova.evolvi_SC (ambiente_prova.eventi_esterni)
			if attached configurazione_prova as cp then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (one)", cp.stato_corrente.id.is_equal ("one") )
				assert ("ERRORE il sistema non ha aggiornato alfa", not cp.condizioni.item ("alfa") )
				assert ("ERRORE il sistema non ha aggiornato beta", not cp.condizioni.item ("beta") )
				assert ("ERRORE il sistema non ha aggiornato gamma", not cp.condizioni.item ("gamma") )
			end
		end

	t_esempio_6
			-- Il processo dovrebbe arrestarsi nello stato "one" con le condizioni "alfa", "beta" e "gamma" false.
			-- Verifica funzionamento con evento non esistente.
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_verifica.txt"
			ambiente_prova.acquisisci_eventi (nomi_files_prova[2])
			configurazione_prova.evolvi_SC (ambiente_prova.eventi_esterni)
			if attached configurazione_prova as cp then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (one)", cp.stato_corrente.id.is_equal ("one") )
				assert ("ERRORE il sistema non ha aggiornato alfa", not cp.condizioni.item ("alfa") )
				assert ("ERRORE il sistema non ha aggiornato beta", not cp.condizioni.item ("beta") )
				assert ("ERRORE il sistema non ha aggiornato gamma", not cp.condizioni.item ("gamma") )
			end
		end

end
