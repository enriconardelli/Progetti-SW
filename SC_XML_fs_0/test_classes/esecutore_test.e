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
		redefine
			on_prepare
		end

feature {NONE} -- Supporto

	nomi_files_prova: ARRAY [STRING]
	altro_esecutore_prova, esecutore_prova: ESECUTORE

feature -- Test routines

	on_prepare
		do
			create nomi_files_prova.make_filled ("", 1, 2)
			nomi_files_prova [1] := "esempio_per_esecutore_test.xml"
			nomi_files_prova [2] := "eventi_per_esecutore_test.txt"

			create esecutore_prova.start (nomi_files_prova)

			create nomi_files_prova.make_filled ("", 1, 2)
			nomi_files_prova[1] := "esempio_per_altro_esecutore.xml"
			nomi_files_prova[2] := "eventi_per_altro_esecutore.txt"

			create altro_esecutore_prova.start (nomi_files_prova)

		end


	esecutore_verifica_eventi
		local
			v: ARRAY [STRING]
			v_v: ARRAY [STRING]
			i:INTEGER
			flag,flag_1:BOOLEAN
		do
			v := esecutore_prova.eventi
			v_v := esecutore_prova.verifica_eventi
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
			assert("Fatto male flag_1", not flag_1)
		end

	esecutore_ha_3_stati
		do
			assert ("gli stati sono 3", esecutore_prova.state_chart.stati.count = 3)
		end

	esecutore_ha_nomi_stati
		do
			assert("non ha one", esecutore_prova.state_chart.stati.has ("one"))
			assert("non ha two", esecutore_prova.state_chart.stati.has ("two"))
			assert("non ha three", esecutore_prova.state_chart.stati.has ("three"))
		end

	esecutore_ha_nomi_cond
	do
			assert("non ha alfa", esecutore_prova.state_chart.condizioni.has ("alfa"))
			assert("non ha beta", esecutore_prova.state_chart.condizioni.has ("beta"))
			assert("non ha gamma", esecutore_prova.state_chart.condizioni.has ("gamma"))
	end

	altro_esecutore_ha_4_stati
		do
			assert ("gli stati sono 4", altro_esecutore_prova.state_chart.stati.count /= 4)
		end

	altro_esecutore_ha_nomi_stati
		do
			assert("non ha reset", not altro_esecutore_prova.state_chart.stati.has ("reset"))
			assert("non ha paused",  not altro_esecutore_prova.state_chart.stati.has ("paused"))
			assert("non ha running", not altro_esecutore_prova.state_chart.stati.has ("running"))
			assert("non ha stopped", not altro_esecutore_prova.state_chart.stati.has ("stopped"))
		end

	altro_esecutore_ha_nomi_cond
	do
			assert("non ha running$value",not  altro_esecutore_prova.state_chart.condizioni.has ("running$value"))
			assert("non ha paused$value",not altro_esecutore_prova.state_chart.condizioni.has ("paused$value"))
			assert("non ha stopped$value",not altro_esecutore_prova.state_chart.condizioni.has ("stopped$value"))
			assert("non ha reset$value",not altro_esecutore_prova.state_chart.condizioni.has ("reset$value"))
	end

end
