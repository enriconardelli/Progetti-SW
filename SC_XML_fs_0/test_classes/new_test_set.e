note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
NEW_TEST_SET

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
			create e.start_new
--			create a.start_new("esempio.xml")
			create a.start_new
		end

feature -- Test routines

	testha4stati
			-- New test routine
		do
			assert ("gli stati sono 4", e.state_chart.stati.count=4)
		end
	testhaglistati
		do
			assert("non ha reset", e.state_chart.stati.has ("reset"))
			assert("non ha paused", e.state_chart.stati.has ("paused"))
			assert("non ha running", e.state_chart.stati.has ("running"))
			assert("non ha stopped", e.state_chart.stati.has ("stopped"))
		end
	testhalecond
	do
			assert("non ha running$value", e.state_chart.condizioni.has ("running$value"))
			assert("non ha paused$value", e.state_chart.condizioni.has ("paused$value"))
			assert("non ha stopped$value", e.state_chart.condizioni.has ("stopped$value"))
			assert("non ha reset$value", e.state_chart.condizioni.has ("reset$value"))
	end

	esempioha3stati
			-- New test routine
		do
			assert ("gli stati so 3", a.state_chart.stati.count=3)
		end
	esempiohaglistati
		do
			assert("non ha one", a.state_chart.stati.has ("one"))
			assert("non ha two", a.state_chart.stati.has ("two"))
			assert("non ha three", a.state_chart.stati.has ("three"))
		end
	esempiohalecond
	do
			assert("non ha alfa", a.state_chart.condizioni.has ("alfa"))
			assert("non ha beta", a.state_chart.condizioni.has ("beta"))
			assert("non ha gamma", a.state_chart.condizioni.has ("gamma"))
	end
end

