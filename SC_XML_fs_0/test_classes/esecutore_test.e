note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	ESECUTORE_TEST

inherit

	EQA_TEST_SET
		redefine
			on_prepare
		end

feature {NONE} -- Supporto

	nomi_files_prova: ARRAY [STRING]
	altro_esecutore_prova, esecutore_prova: ESECUTORE
	a_path: PATH
	test_data_dir: STRING = "test_data"

feature -- Test routines

	on_prepare
		do
			create a_path.make_current
			test_data_dir.append_character(a_path.directory_separator)
			create nomi_files_prova.make_filled ("", 1, 2)
			nomi_files_prova [1] := test_data_dir + "esempio_per_esecutore_test.xml"
			nomi_files_prova [2] := test_data_dir + "eventi_per_esecutore_test.txt"

			create esecutore_prova.start (nomi_files_prova)

			create nomi_files_prova.make_filled ("", 1, 2)
			nomi_files_prova[1] := test_data_dir + "esempio_per_altro_esecutore_test.xml"
			nomi_files_prova[2] := test_data_dir + "eventi_per_altro_esecutore_test.txt"

			create altro_esecutore_prova.start (nomi_files_prova)

		end

	esecutore_ha_3_stati
		do
			assert ("gli stati sono 3", esecutore_prova.state_chart.stati.count = 3)
		end

	esecutore_ha_nomi_stati
		do
			assert("non ha one", esecutore_prova.state_chart.stati.has ("one"))
			assert("non ha two", esecutore_prova.state_chart.stati.has ("two"))
			assert("non ha three", esecutore_prova.state_chart.stati.has ("three"))
		end

	esecutore_ha_nomi_cond
	do
			assert("non ha alfa", esecutore_prova.state_chart.condizioni.has ("alfa"))
			assert("non ha beta", esecutore_prova.state_chart.condizioni.has ("beta"))
			assert("non ha gamma", esecutore_prova.state_chart.condizioni.has ("gamma"))
	end

	altro_esecutore_ha_4_stati
		do
			assert ("gli stati sono 4", altro_esecutore_prova.state_chart.stati.count = 4)
		end

	altro_esecutore_ha_nomi_stati
		do
			assert("non ha reset", altro_esecutore_prova.state_chart.stati.has ("reset"))
			assert("non ha paused",  altro_esecutore_prova.state_chart.stati.has ("paused"))
			assert("non ha running", altro_esecutore_prova.state_chart.stati.has ("running"))
			assert("non ha stopped", altro_esecutore_prova.state_chart.stati.has ("stopped"))
		end

	altro_esecutore_ha_nomi_cond
	do
			assert("non ha running$value",  altro_esecutore_prova.state_chart.condizioni.has ("running$value"))
			assert("non ha paused$value", altro_esecutore_prova.state_chart.condizioni.has ("paused$value"))
			assert("non ha stopped$value", altro_esecutore_prova.state_chart.condizioni.has ("stopped$value"))
			assert("non ha reset$value", altro_esecutore_prova.state_chart.condizioni.has ("reset$value"))
	end

end
