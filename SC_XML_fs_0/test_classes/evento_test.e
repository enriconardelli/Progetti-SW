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

feature -- Test routines

test_contenuto_eventi
		local
			e:esecutore
		do
			create e.start
			assert("Fatto male", e.eventi[1]~"25")
		end
end


