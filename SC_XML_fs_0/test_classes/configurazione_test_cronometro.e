note
	description: "Summary description for {CONFIGURAZIONE_TEST_CRONOMETRO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ESECUTORE_TEST_CRONOMETRO

inherit
	ESECUTORE_TEST
		redefine on_prepare end
feature -- Test routines

	on_prepare
		do
		    precursor
			nomi_files_prova[1] := test_data_dir + "esempio_cronometro_per_esecutore_test.xml"
			nomi_files_prova[2] := test_data_dir
		end

feature -- Test Cronometro

	t_evolvi_cronometro_1
			-- Il processo dovrebbe arrestarsi nello stato "running"
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_cronometro_1_per_esecutore_test_verifica.txt"
			create esecutore.start(nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto (RUNNING)", esecutore.stato_corrente[0].id.is_equal("running") )
		end

	t_evolvi_cronometro_2
			-- Il processo dovrebbe arrestarsi nello stato "stopped"
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_cronometro_2_per_esecutore_test_verifica.txt"
			create esecutore.start(nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto (STOPPED)", esecutore.stato_corrente[0].id.is_equal ("stopped"))
		end

	t_evolvi_cronometro_3
			-- Il processo dovrebbe arrestarsi nello stato "reset"
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_cronometro_3_per_esecutore_test_verifica.txt"
			create esecutore.start(nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto (RESET)", esecutore.stato_corrente[0].id.is_equal ("reset"))
		end

	t_evolvi_cronometro_4
			-- Il processo dovrebbe arrestarsi nello stato "paused"
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_cronometro_4_per_esecutore_test_verifica.txt"
			create esecutore.start(nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto (PAUSED)", esecutore.stato_corrente[0].id.is_equal ("paused"))
		end

	t_evolvi_cronometro_5
			-- Il processo dovrebbe arrestarsi nello stato "running"
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_cronometro_5_per_esecutore_test_verifica.txt"
			create esecutore.start(nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto (RUNNING)", esecutore.stato_corrente[0].id.is_equal ("running"))
		end

	t_evolvi_cronometro_6
			-- Il processo dovrebbe arrestarsi nello stato "paused"
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_cronometro_1_per_esecutore_test.txt"
			create esecutore.start(nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto (PAUSED)", esecutore.stato_corrente[0].id.is_equal ("paused"))
		end

	t_evolvi_cronometro_7
			-- Il processo dovrebbe arrestarsi nello stato "stopped"
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_cronometro_2_per_esecutore_test.txt"
			create esecutore.start(nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato nello stato corretto (STOPPED)", esecutore.stato_corrente[0].id.is_equal ("stopped"))
		end

end
