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
	a_path: PATH
	test_data_dir: STRING = "test_data"

feature -- Test routines

	on_prepare
		do
<<<<<<< HEAD
			create nomi_files_prova.make_filled ("", 1, 2)
=======
		    create a_path.make_current
			test_data_dir.append_character(a_path.directory_separator)
		    create nomi_files_prova.make_filled ("", 1, 2)
			nomi_files_prova[1] := test_data_dir + "esempio_cronometro_per_esecutore_test.xml"
			nomi_files_prova[2] := test_data_dir
>>>>>>> a50e8cef1812f22b6795cf5c24d9f9ca4ecffa56
		end

feature -- Test Cronometro

	t_evolvi_cronometro_1
			-- Il processo dovrebbe arrestarsi nello stato "running"
		do
<<<<<<< HEAD
			nomi_files_prova[1] := "esempio_cronometro_1_per_esecutore_test.xml"
			nomi_files_prova[2] := "eventi_cronometro_1_per_esecutore_test_verifica.txt"
=======
			nomi_files_prova[2] := test_data_dir + "eventi_cronometro_1_per_esecutore_test_verifica.txt"
>>>>>>> a50e8cef1812f22b6795cf5c24d9f9ca4ecffa56
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (RUNNING)", ep.state_chart.stato_corrente.id.is_equal ("running"))
			end

		end

	t_evolvi_cronometro_2
			-- Il processo dovrebbe arrestarsi nello stato "stopped"
		do
<<<<<<< HEAD
			nomi_files_prova[1] := "esempio_cronometro_1_per_esecutore_test.xml"
			nomi_files_prova[2] := "eventi_cronometro_2_per_esecutore_test_verifica.txt"
=======
			nomi_files_prova[2] := test_data_dir + "eventi_cronometro_2_per_esecutore_test_verifica.txt"
>>>>>>> a50e8cef1812f22b6795cf5c24d9f9ca4ecffa56
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (STOPPED)", ep.state_chart.stato_corrente.id.is_equal ("stopped"))
			end
		end

	t_evolvi_cronometro_3
			-- Il processo dovrebbe arrestarsi nello stato "reset"
		do
<<<<<<< HEAD
			nomi_files_prova[1] := "esempio_cronometro_1_per_esecutore_test.xml"
			nomi_files_prova[2] := "eventi_cronometro_3_per_esecutore_test_verifica.txt"
=======
			nomi_files_prova[2] := test_data_dir + "eventi_cronometro_3_per_esecutore_test_verifica.txt"
>>>>>>> a50e8cef1812f22b6795cf5c24d9f9ca4ecffa56
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (RESET)", ep.state_chart.stato_corrente.id.is_equal ("reset"))
			end
		end

	t_evolvi_cronometro_4
			-- Il processo dovrebbe arrestarsi nello stato "paused"
		do
<<<<<<< HEAD
			nomi_files_prova[1] := "esempio_cronometro_1_per_esecutore_test.xml"
			nomi_files_prova[2] := "eventi_cronometro_4_per_esecutore_test_verifica.txt"
=======
			nomi_files_prova[2] := test_data_dir + "eventi_cronometro_4_per_esecutore_test_verifica.txt"
>>>>>>> a50e8cef1812f22b6795cf5c24d9f9ca4ecffa56
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (PAUSED)", ep.state_chart.stato_corrente.id.is_equal ("paused"))
			end
		end

	t_evolvi_cronometro_5
			-- Il processo dovrebbe arrestarsi nello stato "running"
		do
<<<<<<< HEAD
			nomi_files_prova[1] := "esempio_cronometro_1_per_esecutore_test.xml"
			nomi_files_prova[2] := "eventi_cronometro_5_per_esecutore_test_verifica.txt"
=======
			nomi_files_prova[2] := test_data_dir + "eventi_cronometro_5_per_esecutore_test_verifica.txt"
>>>>>>> a50e8cef1812f22b6795cf5c24d9f9ca4ecffa56
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (RUNNING)", ep.state_chart.stato_corrente.id.is_equal ("running"))
			end
		end

	t_evolvi_cronometro_6
			-- Il processo dovrebbe arrestarsi nello stato "paused"
		do
<<<<<<< HEAD
			nomi_files_prova[1] := "esempio_cronometro_1_per_esecutore_test.xml"
			nomi_files_prova[2] := "eventi_cronometro_1_per_esecutore_test.txt"
=======
			nomi_files_prova[2] := test_data_dir + "eventi_cronometro_1_per_esecutore_test.txt"
>>>>>>> a50e8cef1812f22b6795cf5c24d9f9ca4ecffa56
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (PAUSED)", ep.state_chart.stato_corrente.id.is_equal ("paused"))
			end
		end

	t_evolvi_cronometro_7
			-- Il processo dovrebbe arrestarsi nello stato "stopped"
		do
<<<<<<< HEAD
			nomi_files_prova[1] := "esempio_cronometro_1_per_esecutore_test.xml"
			nomi_files_prova[2] := "eventi_cronometro_2_per_esecutore_test.txt"
=======
			nomi_files_prova[2] := test_data_dir + "eventi_cronometro_2_per_esecutore_test.txt"
>>>>>>> a50e8cef1812f22b6795cf5c24d9f9ca4ecffa56
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (STOPPED)", ep.state_chart.stato_corrente.id.is_equal ("stopped"))
			end
		end

 feature -- Test "Esempio"

	t_esempio_1
			-- Il processo dovrebbe arrestarsi nello stato "three" con le condizioni "alfa" e "beta" vere e "gamma" falsa.
		do
			nomi_files_prova[1] := "esempio.xml"
			nomi_files_prova[2] := "eventi_1.txt"
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (three)", ep.state_chart.stato_corrente.id.is_equal ("three") )
				assert ("ERRORE il sistema non ha aggiornato correttamente le condizioni", ep.state_chart.condizioni.item ("alfa") and ep.state_chart.condizioni.item ("beta") and not ep.state_chart.condizioni.item ("gamma") )
			end
		end

	t_esempio_2
			-- Il processo dovrebbe arrestarsi nello stato "one" con le condizioni "alfa" e "beta" vere e "gamma" falsa.
		do
			nomi_files_prova[1] := "esempio.xml"
			nomi_files_prova[2] := "eventi_2.txt"
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (one)", ep.state_chart.stato_corrente.id.is_equal ("one") )
				assert ("ERRORE il sistema non ha aggiornato correttamente le condizioni", ep.state_chart.condizioni.item ("alfa") and ep.state_chart.condizioni.item ("beta") and not ep.state_chart.condizioni.item ("gamma") )
			end
		end

	t_esempio_3
			-- Il processo dovrebbe arrestarsi nello stato "one" con le condizioni "alfa" e "gamma" false e "beta" vera.
		do
			nomi_files_prova[1] := "esempio.xml"
			nomi_files_prova[2] := "eventi_3.txt"
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (one)", ep.state_chart.stato_corrente.id.is_equal ("one") )
				assert ("ERRORE il sistema non ha aggiornato correttamente le condizioni", not ep.state_chart.condizioni.item ("alfa") and ep.state_chart.condizioni.item ("beta") and not ep.state_chart.condizioni.item ("gamma") )
			end
		end

	t_esempio_4
			-- Il processo dovrebbe arrestarsi nello stato "two" con le condizioni "alfa" e "gamma" false e "beta" vera.
		do
			nomi_files_prova[1] := "esempio.xml"
			nomi_files_prova[2] := "eventi_4.txt"
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
			nomi_files_prova[1] := "esempio.xml"
			nomi_files_prova[2] := "eventi_5.txt"
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
			nomi_files_prova[1] := "esempio.xml"
			nomi_files_prova[2] := "eventi_verifica.txt"
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (one)", ep.state_chart.stato_corrente.id.is_equal ("one") )
				assert ("ERRORE il sistema non ha aggiornato alfa", not ep.state_chart.condizioni.item ("alfa") )
				assert ("ERRORE il sistema non ha aggiornato beta", not ep.state_chart.condizioni.item ("beta") )
				assert ("ERRORE il sistema non ha aggiornato gamma", not ep.state_chart.condizioni.item ("gamma") )
			end
		end

end


