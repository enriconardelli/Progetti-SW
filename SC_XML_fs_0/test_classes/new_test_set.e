note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
CREA_STATI_TEST

inherit
	EQA_TEST_SET
		redefine
			on_prepare
		end

feature {NONE} -- Events
e: ESECUTORE

	on_prepare
			-- <Precursor>
		do
			create e.start
		end

feature -- Test routines

	ha4stati
			-- New test routine
		do
			assert ("gli stati so 4", e.stati.count=4)
		end
	haglistati
		do
			assert("non ha reset", e.stati.has ("reset"))
			assert("non ha paused", e.stati.has ("paused"))
			assert("non ha running", e.stati.has ("running"))
			assert("non ha stopped", e.stati.has ("stopped"))
		end
	halecond
	do
			assert("non ha running$value", e.condizioni.has ("running$value"))
			assert("non ha paused$value", e.condizioni.has ("paused$value"))
			assert("non ha stopped$value", e.condizioni.has ("stopped$value"))
			assert("non ha reset$value", e.condizioni.has ("reset$value"))
	end

end


