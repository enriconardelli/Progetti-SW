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
		do
			v := e.eventi
			v_v := e.verifica_eventi
			assert ("Fatto male e si vede dal count", v_v.count < v.count)
			assert ("Fatto male contenuto verificato.1", not v_v.has ("25"))
			assert("Fatto male contenuto verificato.2", v_v.has ("watch_start"))
		end

end
