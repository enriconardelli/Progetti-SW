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

feature -- Test routines

	esecutore_test: detachable ESECUTORE

	on_prepare
		do
			create nomi_files_prova.make_filled ("", 1, 2)
			nomi_files_prova [1] := "esempio.xml"
			nomi_files_prova [2] := "eventi.txt"
		end

	t_start_con_test
			-- New test routine
		do
				--			create esecutore_test.start_new ("test.xml")
			create esecutore_test.start (nomi_files_prova)
				--assert ("not_implemented", False)
		end

end
