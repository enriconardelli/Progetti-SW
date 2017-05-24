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
	esecutore_prova: ESECUTORE

feature -- Test routines

	on_prepare
		do
			create nomi_files_prova.make_filled ("", 1, 2)
			nomi_files_prova [1] := "esempio_per_esecutore_test.xml"
			nomi_files_prova [2] := "eventi_per_esecutore_test.txt"

			create esecutore_prova.start (nomi_files_prova)
		end


	test_verifica_eventi
		local
			v: ARRAY [STRING]
			v_v: ARRAY [STRING]
			i:INTEGER
			flag,flag_1:BOOLEAN
		do
			v := esecutore_prova.eventi
			v_v := esecutore_prova.verifica_eventi
			assert ("Fatto male e si vede dal count", v_v.count < v.count)
			from
				i:=1
			until
				i=v_v.count+1
			loop
				if v_v[i]~"25" then
					flag:=true
				end
				if v_v[i]~"watch_reset" then
					flag_1:=true
				end
				i:=i+1
			end
			assert ("Fatto male flag", not flag)
			assert("Fatto male flag_1", not flag_1)
		end



end
