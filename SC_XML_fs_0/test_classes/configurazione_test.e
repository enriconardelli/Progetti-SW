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
			-- New test routine
		do
			nomi_files_prova[2] := "eventi_cronometro_1_per_esecutore_test.txt"
			create esecutore_prova.start (nomi_files_prova)
			if attached esecutore_prova as ep then
				ep.state_chart.evolvi_sc (ep.eventi_esterni)
			end
			assert ("not_implemented", False)
		end

	t_evolvi_cronometro_2
			-- New test routine
		do
			nomi_files_prova[2] := "eventi_cronometro_2_per_esecutore_test.txt"
			create esecutore_prova.start (nomi_files_prova)
			assert ("not_implemented", False)
		end
end


