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
	esecutore_prova: ESECUTORE

feature -- Test routines

	on_prepare
		do
			create nomi_files_prova.make_filled ("", 1, 2)
			nomi_files_prova[1] := "esempio_cronometro_1_per_esecutore_test.xml"
			nomi_files_prova[2] := "eventi_cronometro_1_per_esecutore_test.txt"
			create esecutore_prova.start (nomi_files_prova)
		end

feature -- Test routines

	t_evolvi_cronometro
			-- New test routine
		do
			assert ("not_implemented", False)
		end

end


