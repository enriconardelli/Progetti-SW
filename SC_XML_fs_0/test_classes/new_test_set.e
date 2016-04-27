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
a: ESECUTORE
	on_prepare
			-- <Precursor>
		do
			create e.start
--			create a.start_new("esempio.xml")
			create a.start_new
		end

feature -- Test routines

	testha4stati
			-- New test routine
		do
			assert ("gli stati so 4", e.stati.count=4)
		end
	testhaglistati
		do
			assert("non ha reset", e.stati.has ("reset"))
			assert("non ha paused", e.stati.has ("paused"))
			assert("non ha running", e.stati.has ("running"))
			assert("non ha stopped", e.stati.has ("stopped"))
		end
	testhalecond
	do
			assert("non ha running$value", e.condizioni.has ("running$value"))
			assert("non ha paused$value", e.condizioni.has ("paused$value"))
			assert("non ha stopped$value", e.condizioni.has ("stopped$value"))
			assert("non ha reset$value", e.condizioni.has ("reset$value"))
	end

	esempioha3stati
			-- New test routine
		do
			assert ("gli stati so 3", a.stati.count=3)
		end
	esempiohaglistati
		do
			assert("non ha one", a.stati.has ("one"))
			assert("non ha two", a.stati.has ("two"))
			assert("non ha three", a.stati.has ("three"))
		end
	esempiohalecond
	do
			assert("non ha alfa", a.condizioni.has ("alfa"))
			assert("non ha beta", a.condizioni.has ("beta"))
			assert("non ha gamma", a.condizioni.has ("gamma"))
	end
end


