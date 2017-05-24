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

feature {NONE} -- Supporto

	nomi_files_prova: ARRAY[STRING]

feature {NONE} -- Events
e: ESECUTORE
a: ESECUTORE
	on_prepare
			-- <Precursor>
		do
			create nomi_files_prova.make_filled ("", 1, 2)
			nomi_files_prova[1] := "esempio.xml"
			nomi_files_prova[2] := "eventi.txt"

			create e.start(nomi_files_prova)
--			create a.start_new("esempio.xml")
			create a.start(nomi_files_prova)

		end

feature -- Test routines

	test_ha_4_stati
			-- New test routine
		do
			assert ("gli stati sono 4", e.state_chart.stati.count /= 4)
		end
	test_ha_gli_stati
		do
			assert("non ha reset", not e.state_chart.stati.has ("reset"))
			assert("non ha paused",  not e.state_chart.stati.has ("paused"))
			assert("non ha running", not e.state_chart.stati.has ("running"))
			assert("non ha stopped", not e.state_chart.stati.has ("stopped"))
		end
	test_ha_le_cond
	do
			assert("non ha running$value",not  e.state_chart.condizioni.has ("running$value"))
			assert("non ha paused$value",not e.state_chart.condizioni.has ("paused$value"))
			assert("non ha stopped$value",not e.state_chart.condizioni.has ("stopped$value"))
			assert("non ha reset$value",not e.state_chart.condizioni.has ("reset$value"))
	end



	esempio_ha_3_stati
			-- New test routine
		do
			assert ("gli stati sono 3", a.state_chart.stati.count = 3)
		end

	esempio_ha_gli_stati
		do
			assert("non ha one", a.state_chart.stati.has ("one"))
			assert("non ha two", a.state_chart.stati.has ("two"))
			assert("non ha three", a.state_chart.stati.has ("three"))
		end

	esempio_ha_le_cond
	do
			assert("non ha alfa", a.state_chart.condizioni.has ("alfa"))
			assert("non ha beta", a.state_chart.condizioni.has ("beta"))
			assert("non ha gamma", a.state_chart.condizioni.has ("gamma"))
	end
end

