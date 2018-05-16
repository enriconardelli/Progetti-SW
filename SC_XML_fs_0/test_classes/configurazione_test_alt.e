note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	CONFIGURAZIONE_TEST_ALT

inherit
	EQA_TEST_SET
		redefine
			on_prepare
		end

feature {NONE} -- Supporto

	nomi_files: ARRAY [STRING]
	state_chart: CONFIGURAZIONE
--	eventi_esterni: ARRAY [LINKED_SET [STRING]]
	a_path: PATH
	test_data_dir: STRING = "test_data"

feature -- Test routines

	on_prepare
		do
		    create a_path.make_current
			test_data_dir.append_character(a_path.directory_separator)
		    create nomi_files.make_filled ("", 1, 2)
			nomi_files[1] := test_data_dir + "esempio_cronometro_per_esecutore_test.xml"
			nomi_files[2] := test_data_dir
			print ("crea la SC in " + nomi_files [1] + "%N")
			create state_chart.make (nomi_files [1])
		end

feature -- Test Cronometro

	t_evolvi_cronometro_1
			-- Il processo dovrebbe arrestarsi nello stato "running"
		do
--			nomi_files[2] := test_data_dir + "eventi_cronometro_1_per_esecutore_test_verifica.txt"
--			print ("e la esegue con gli eventi in " + nomi_files [2] + "%N")
--			create eventi_esterni.make_empty
--			acquisisci_eventi (nomi_files [2])
--			print ("acquisiti eventi %N")
--			if not verifica_eventi_esterni then
--				print ("WARNING nel file ci sono eventi che la SC non conosce %N")
--			end
--			print ("eventi verificati, si esegue la SC %N")
--			state_chart.evolvi_SC (eventi_esterni)
--			assert ("ERRORE il sistema non ha terminato nello stato corretto (RUNNING)", state_chart.stato_corrente.id.is_equal ("running"))
		end


--	t_evolvi_cronometro_2
--			-- Il processo dovrebbe arrestarsi nello stato "stopped"
--		do
--			nomi_files_prova[2] := test_data_dir + "eventi_cronometro_2_per_esecutore_test_verifica.txt"
--			create esecutore_prova.start (nomi_files_prova)
--			if attached esecutore_prova as ep then
--				assert ("ERRORE il sistema non ha terminato nello stato corretto (STOPPED)", ep.state_chart.stato_corrente.id.is_equal ("stopped"))
--			end
--		end

--	t_evolvi_cronometro_3
--			-- Il processo dovrebbe arrestarsi nello stato "reset"
--		do
--			nomi_files_prova[2] := test_data_dir + "eventi_cronometro_3_per_esecutore_test_verifica.txt"
--			create esecutore_prova.start (nomi_files_prova)
--			if attached esecutore_prova as ep then
--				assert ("ERRORE il sistema non ha terminato nello stato corretto (RESET)", ep.state_chart.stato_corrente.id.is_equal ("reset"))
--			end
--		end

--	t_evolvi_cronometro_4
--			-- Il processo dovrebbe arrestarsi nello stato "paused"
--		do
--			nomi_files_prova[2] := test_data_dir + "eventi_cronometro_4_per_esecutore_test_verifica.txt"
--			create esecutore_prova.start (nomi_files_prova)
--			if attached esecutore_prova as ep then
--				assert ("ERRORE il sistema non ha terminato nello stato corretto (PAUSED)", ep.state_chart.stato_corrente.id.is_equal ("paused"))
--			end
--		end

--	t_evolvi_cronometro_5
--			-- Il processo dovrebbe arrestarsi nello stato "running"
--		do
--			nomi_files_prova[2] := test_data_dir + "eventi_cronometro_5_per_esecutore_test_verifica.txt"
--			create esecutore_prova.start (nomi_files_prova)
--			if attached esecutore_prova as ep then
--				assert ("ERRORE il sistema non ha terminato nello stato corretto (RUNNING)", ep.state_chart.stato_corrente.id.is_equal ("running"))
--			end
--		end

--	t_evolvi_cronometro_6
--			-- Il processo dovrebbe arrestarsi nello stato "paused"
--		do
--			nomi_files_prova[2] := test_data_dir + "eventi_cronometro_1_per_esecutore_test.txt"
--			create esecutore_prova.start (nomi_files_prova)
--			if attached esecutore_prova as ep then
--				assert ("ERRORE il sistema non ha terminato nello stato corretto (PAUSED)", ep.state_chart.stato_corrente.id.is_equal ("paused"))
--			end
--		end

--	t_evolvi_cronometro_7
--			-- Il processo dovrebbe arrestarsi nello stato "stopped"
--		do
--			nomi_files_prova[2] := test_data_dir + "eventi_cronometro_2_per_esecutore_test.txt"
--			create esecutore_prova.start (nomi_files_prova)
--			if attached esecutore_prova as ep then
--				assert ("ERRORE il sistema non ha terminato nello stato corretto (STOPPED)", ep.state_chart.stato_corrente.id.is_equal ("stopped"))
--			end
--		end

-- feature -- Test "Esempio"

--	t_esempio_1
--			-- Il processo dovrebbe arrestarsi nello stato "three" con le condizioni "alfa" e "beta" vere e "gamma" falsa.
--		do
--			nomi_files_prova[1] := "esempio.xml"
--			nomi_files_prova[2] := "eventi_1.txt"
--			create esecutore_prova.start (nomi_files_prova)
--			if attached esecutore_prova as ep then
--				assert ("ERRORE il sistema non ha terminato nello stato corretto (three)", ep.state_chart.stato_corrente.id.is_equal ("three") )
--				assert ("ERRORE il sistema non ha aggiornato correttamente le condizioni", ep.state_chart.condizioni.item ("alfa") and ep.state_chart.condizioni.item ("beta") and not ep.state_chart.condizioni.item ("gamma") )
--			end
--		end

--	t_esempio_2
--			-- Il processo dovrebbe arrestarsi nello stato "one" con le condizioni "alfa" e "beta" vere e "gamma" falsa.
--		do
--			nomi_files_prova[1] := "esempio.xml"
--			nomi_files_prova[2] := "eventi_2.txt"
--			create esecutore_prova.start (nomi_files_prova)
--			if attached esecutore_prova as ep then
--				assert ("ERRORE il sistema non ha terminato nello stato corretto (one)", ep.state_chart.stato_corrente.id.is_equal ("one") )
--				assert ("ERRORE il sistema non ha aggiornato correttamente le condizioni", ep.state_chart.condizioni.item ("alfa") and ep.state_chart.condizioni.item ("beta") and not ep.state_chart.condizioni.item ("gamma") )
--			end
--		end

--	t_esempio_3
--			-- Il processo dovrebbe arrestarsi nello stato "one" con le condizioni "alfa" e "gamma" false e "beta" vera.
--		do
--			nomi_files_prova[1] := "esempio.xml"
--			nomi_files_prova[2] := "eventi_3.txt"
--			create esecutore_prova.start (nomi_files_prova)
--			if attached esecutore_prova as ep then
--				assert ("ERRORE il sistema non ha terminato nello stato corretto (one)", ep.state_chart.stato_corrente.id.is_equal ("one") )
--				assert ("ERRORE il sistema non ha aggiornato correttamente le condizioni", not ep.state_chart.condizioni.item ("alfa") and ep.state_chart.condizioni.item ("beta") and not ep.state_chart.condizioni.item ("gamma") )
--			end
--		end

--	t_esempio_4
--			-- Il processo dovrebbe arrestarsi nello stato "two" con le condizioni "alfa" e "gamma" false e "beta" vera.
--		do
--			nomi_files_prova[1] := "esempio.xml"
--			nomi_files_prova[2] := "eventi_4.txt"
--			create esecutore_prova.start (nomi_files_prova)
--			if attached esecutore_prova as ep then
--				assert ("ERRORE il sistema non ha terminato nello stato corretto (one)", ep.state_chart.stato_corrente.id.is_equal ("one") )
--				assert ("ERRORE il sistema non ha aggiornato alfa", not ep.state_chart.condizioni.item ("alfa") )
--				assert ("ERRORE il sistema non ha aggiornato beta", ep.state_chart.condizioni.item ("beta") )
--				assert ("ERRORE il sistema non ha aggiornato gamma", not ep.state_chart.condizioni.item ("gamma") )
--			end
--		end

--	t_esempio_5
--			-- Il processo dovrebbe arrestarsi nello stato "one" con le condizioni "alfa", "beta" e "gamma" false.
--			-- Verifica se posso compiere più azioni.
--		do
--			nomi_files_prova[1] := "esempio.xml"
--			nomi_files_prova[2] := "eventi_5.txt"
--			create esecutore_prova.start (nomi_files_prova)
--			if attached esecutore_prova as ep then
--				assert ("ERRORE il sistema non ha terminato nello stato corretto (one)", ep.state_chart.stato_corrente.id.is_equal ("one") )
--				assert ("ERRORE il sistema non ha aggiornato alfa", not ep.state_chart.condizioni.item ("alfa") )
--				assert ("ERRORE il sistema non ha aggiornato beta", not ep.state_chart.condizioni.item ("beta") )
--				assert ("ERRORE il sistema non ha aggiornato gamma", not ep.state_chart.condizioni.item ("gamma") )
--			end
--		end

--	t_esempio_6
--			-- Il processo dovrebbe arrestarsi nello stato "one" con le condizioni "alfa", "beta" e "gamma" false.
--			-- Verifica funzionamento con evento non esistente.
--		do
--			nomi_files_prova[1] := "esempio.xml"
--			nomi_files_prova[2] := "eventi_verifica.txt"
--			create esecutore_prova.start (nomi_files_prova)
--			if attached esecutore_prova as ep then
--				assert ("ERRORE il sistema non ha terminato nello stato corretto (one)", ep.state_chart.stato_corrente.id.is_equal ("one") )
--				assert ("ERRORE il sistema non ha aggiornato alfa", not ep.state_chart.condizioni.item ("alfa") )
--				assert ("ERRORE il sistema non ha aggiornato beta", not ep.state_chart.condizioni.item ("beta") )
--				assert ("ERRORE il sistema non ha aggiornato gamma", not ep.state_chart.condizioni.item ("gamma") )
--			end
--		end

end


