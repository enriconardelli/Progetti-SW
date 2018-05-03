note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

deferred class
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
		    create a_path.make_current
			test_data_dir.append_character(a_path.directory_separator)
		    create nomi_files_prova.make_filled ("", 1, 2)
		end

end


