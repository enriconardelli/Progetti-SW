note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	CONFIGURAZIONE_TEST

inherit
	EQA_TEST_SET
		redefine
			on_prepare
		end

feature {NONE} -- Supporto

	nomi_files_prova: ARRAY [STRING]
	esecutore_prova: detachable ESECUTORE

feature -- Test routines

	on_prepare
		do
			create nomi_files_prova.make_filled ("", 1, 2)
			nomi_files_prova[1] := "esempio_cronometro_1_per_esecutore_test.xml"
		end

feature -- Test routines

	t_evolvi_cronometro_1
			-- Il processo dovrebbe arrestarsi nello stato "running"
		do
			nomi_files_prova[2] := "eventi_cronometro_1_per_esecutore_test_verifica.txt"
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (RUNNING)", ep.state_chart.stato_corrente.id.is_equal ("running"))
			end

		end

	t_evolvi_cronometro_2
			-- Il processo dovrebbe arrestarsi nello stato "stopped"
		do
			nomi_files_prova[2] := "eventi_cronometro_2_per_esecutore_test_verifica.txt"
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (STOPPED)", ep.state_chart.stato_corrente.id.is_equal ("stopped"))
			end
		end

	t_evolvi_cronometro_3
			-- Il processo dovrebbe arrestarsi nello stato "reset"
		do
			nomi_files_prova[2] := "eventi_cronometro_3_per_esecutore_test_verifica.txt"
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (RESET)", ep.state_chart.stato_corrente.id.is_equal ("reset"))
			end
		end

	t_evolvi_cronometro_4
			-- Il processo dovrebbe arrestarsi nello stato "paused"
		do
			nomi_files_prova[2] := "eventi_cronometro_4_per_esecutore_test_verifica.txt"
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (PAUSED)", ep.state_chart.stato_corrente.id.is_equal ("paused"))
			end
		end

	t_evolvi_cronometro_5
			-- Il processo dovrebbe arrestarsi nello stato "running"
		do
			nomi_files_prova[2] := "eventi_cronometro_5_per_esecutore_test_verifica.txt"
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (RUNNING)", ep.state_chart.stato_corrente.id.is_equal ("running"))
			end
		end

	t_evolvi_cronometro_6
			-- Il processo dovrebbe arrestarsi nello stato "paused"
		do
			nomi_files_prova[2] := "eventi_cronometro_1_per_esecutore_test.txt"
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (PAUSED)", ep.state_chart.stato_corrente.id.is_equal ("paused"))
			end
		end

	t_evolvi_cronometro_7
			-- Il processo dovrebbe arrestarsi nello stato "stopped"
		do
			nomi_files_prova[2] := "eventi_cronometro_2_per_esecutore_test.txt"
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (STOPPED)", ep.state_chart.stato_corrente.id.is_equal ("stopped"))
			end
		end

end


