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
			assert ("Fatto male", e.eventi [1] ~ "25")
		end

	test_count_eventi
		do
			assert ("Fatto male", e.eventi.count = 4)
		end

end
