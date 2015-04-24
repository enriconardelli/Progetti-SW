note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "A&R"
	date: "$13/04$"
	revision: "$0$"

class
	EVENTO_TEST

inherit

	EQA_TEST_SET
		redefine
			on_prepare
		end

feature -- Test routines

	e: ESECUTORE

	on_prepare
		do
			create e.start
		end

	test_contenuto_eventi
		do
			assert ("Fatto male", e.eventi [1] ~ "watch_reset")
		end

	test_count_eventi
		do
			assert ("Fatto male", e.eventi.count = 4)
		end

	test_verifica_eventi
		local
			v: ARRAY [STRING]
			v_v: ARRAY [STRING]
			i:INTEGER
			flag,flag_1:BOOLEAN
		do
			v := e.eventi
			v_v := e.verifica_eventi
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
			assert("Fatto male flag_1", flag_1)
		end

	test_crea_stati
		local
			
		do

		end

end
