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
	altra_configurazione_prova, configurazione_prova: CONFIGURAZIONE
	ambiente_prova: AMBIENTE
	a_path: PATH
	test_data_dir: STRING = "test_data"

feature -- Test routines

	on_prepare
		do
		    create a_path.make_current
			test_data_dir.append_character(a_path.directory_separator)
		    create nomi_files_prova.make_filled ("", 1, 2)
		    create ambiente_prova.make_empty
			nomi_files_prova [1] := test_data_dir + "esempio_per_esecutore_test.xml"
			nomi_files_prova [2] := test_data_dir + "eventi_per_esecutore_test.txt"

			create configurazione_prova.make (nomi_files_prova [1])

			create nomi_files_prova.make_filled ("", 1, 2)
			nomi_files_prova[1] := test_data_dir + "esempio_per_altro_esecutore_test.xml"
			nomi_files_prova[2] := test_data_dir + "eventi_per_altro_esecutore_test.txt"

			create altra_configurazione_prova.make (nomi_files_prova [1])
		end

feature -- Test

	configurazione_ha_3_stati
		do
			assert ("gli stati sono 3", configurazione_prova.stati.count = 3)
		end

	configurazione_ha_nomi_stati
		do
			assert("non ha one", configurazione_prova.stati.has ("one"))
			assert("non ha two", configurazione_prova.stati.has ("two"))
			assert("non ha three", configurazione_prova.stati.has ("three"))
		end

	configurazione_ha_nomi_cond
	do
			assert("non ha alfa", configurazione_prova.condizioni.has ("alfa"))
			assert("non ha beta", configurazione_prova.condizioni.has ("beta"))
			assert("non ha gamma", configurazione_prova.condizioni.has ("gamma"))
	end

	altra_configurazione_ha_4_stati
		do
			assert ("gli stati sono 4", altra_configurazione_prova.stati.count = 4)
		end

	altra_configurazione_ha_nomi_stati
		do
			assert("non ha reset", altra_configurazione_prova.stati.has ("reset"))
			assert("non ha paused",  altra_configurazione_prova.stati.has ("paused"))
			assert("non ha running", altra_configurazione_prova.stati.has ("running"))
			assert("non ha stopped", altra_configurazione_prova.stati.has ("stopped"))
		end

	altra_configurazione_ha_nomi_cond
	do
			assert("non ha running$value",  altra_configurazione_prova.condizioni.has ("running$value"))
			assert("non ha paused$value", altra_configurazione_prova.condizioni.has ("paused$value"))
			assert("non ha stopped$value", altra_configurazione_prova.condizioni.has ("stopped$value"))
			assert("non ha reset$value", altra_configurazione_prova.condizioni.has ("reset$value"))
	end

end


