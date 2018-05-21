note
	description: "Summary description for {CONFIGURAZIONE_TEST_CRONOMETRO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONFIGURAZIONE_TEST_CRONOMETRO

inherit
	CONFIGURAZIONE_TEST
		redefine on_prepare end
feature -- Test routines

	on_prepare
		do
		    precursor
			nomi_files_prova[1] := test_data_dir + "esempio_cronometro_per_esecutore_test.xml"
			nomi_files_prova[2] := test_data_dir
			create configurazione_prova.make(nomi_files_prova[1])
		end

feature -- Test Cronometro

	t_evolvi_cronometro_1
			-- Il processo dovrebbe arrestarsi nello stato "running"
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_cronometro_1_per_esecutore_test_verifica.txt"
			ambiente_prova.acquisisci_eventi (nomi_files_prova [2])
			configurazione_prova.evolvi_SC (ambiente_prova.eventi_esterni)
			if attached configurazione_prova as cp then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (RUNNING)", cp.stato_corrente.id.is_equal("running") )
			end
		end

	t_evolvi_cronometro_2
			-- Il processo dovrebbe arrestarsi nello stato "stopped"
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_cronometro_2_per_esecutore_test_verifica.txt"
			ambiente_prova.acquisisci_eventi (nomi_files_prova [2])
			configurazione_prova.evolvi_SC (ambiente_prova.eventi_esterni)
			if attached configurazione_prova as cp then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (STOPPED)", cp.stato_corrente.id.is_equal ("stopped"))
			end
		end

	t_evolvi_cronometro_3
			-- Il processo dovrebbe arrestarsi nello stato "reset"
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_cronometro_3_per_esecutore_test_verifica.txt"
			ambiente_prova.acquisisci_eventi (nomi_files_prova [2])
			configurazione_prova.evolvi_SC (ambiente_prova.eventi_esterni)
			if attached configurazione_prova as cp then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (RESET)", cp.stato_corrente.id.is_equal ("reset"))
			end
		end

	t_evolvi_cronometro_4
			-- Il processo dovrebbe arrestarsi nello stato "paused"
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_cronometro_4_per_esecutore_test_verifica.txt"
			ambiente_prova.acquisisci_eventi (nomi_files_prova[2])
			configurazione_prova.evolvi_SC (ambiente_prova.eventi_esterni)
			if attached configurazione_prova as cp then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (PAUSED)", cp.stato_corrente.id.is_equal ("paused"))
			end
		end

	t_evolvi_cronometro_5
			-- Il processo dovrebbe arrestarsi nello stato "running"
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_cronometro_5_per_esecutore_test_verifica.txt"
			ambiente_prova.acquisisci_eventi (nomi_files_prova [2])
			configurazione_prova.evolvi_SC (ambiente_prova.eventi_esterni)
			if attached configurazione_prova as cp then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (RUNNING)", cp.stato_corrente.id.is_equal ("running"))
			end
		end

	t_evolvi_cronometro_6
			-- Il processo dovrebbe arrestarsi nello stato "paused"
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_cronometro_1_per_esecutore_test.txt"
			ambiente_prova.acquisisci_eventi (nomi_files_prova [2])
			configurazione_prova.evolvi_SC (ambiente_prova.eventi_esterni)
			if attached configurazione_prova as cp then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (PAUSED)", cp.stato_corrente.id.is_equal ("paused"))
			end
		end

	t_evolvi_cronometro_7
			-- Il processo dovrebbe arrestarsi nello stato "stopped"
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_cronometro_2_per_esecutore_test.txt"
			ambiente_prova.acquisisci_eventi (nomi_files_prova [2])
			configurazione_prova.evolvi_SC (ambiente_prova.eventi_esterni)
			if attached configurazione_prova as cp then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (STOPPED)", cp.stato_corrente.id.is_equal ("stopped"))
			end
		end

end
