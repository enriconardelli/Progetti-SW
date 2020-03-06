note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	STATIC_TESTS

inherit
	EQA_TEST_SET

feature -- Test routines

	t_has
			-- New test routine
		local
			t: INT_LINKED_LIST
		do
			create t
			assert("t e' vuota, t contiene 3?", not t.has (3))
			t.append (3)
			assert("t contiene 3, t contiene 3?", t.has (3))
			assert("t contiene 3, t contiene 4?", not t.has (4))
			t.append (7)
			assert("t contiene 3 e 7, t contiene 3? ", t.has (3))
			assert("t contiene 3 e 7, t contiene 4? ", not t.has (4))
			assert("t contiene 3 e 7, t contiene 7? ", t.has (7))
		end

	t_append
			-- New test routine
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (0)
			assert("t contiene 0, t contiene 0?", t.has (0))
			t.append (-4)
			assert("t contiene 0 e -4, t contiene -4?", t.has (-4))
		end

end


