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

feature -- Test routines

	esecutore_test: detachable ESECUTORE

	t_start_new
			-- New test routine
		do
			create esecutore_test.start_new
			--assert ("not_implemented", False)
		end

end


