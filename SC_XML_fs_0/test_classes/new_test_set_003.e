note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	STATO_TEST

inherit

	EQA_TEST_SET
		redefine
			on_prepare
		end

feature {NONE} -- Supporto

	stato_prova: detachable STATO
	target_prova_1, target_prova_2: detachable STATO
	transizione_prova_1, transizione_prova_2: detachable TRANSIZIONE

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
				--			assert ("not_implemented", False)
		end

feature -- Test routines

	t_stato_make_with_id
		do
			create stato_prova.make_with_id ("stato_prova")
			if attached stato_prova as sp then
				assert ("id NON è 'stato_prova'", sp.id ~ "stato_prova")
				assert ("final NON è 'false'", not sp.finale)
			end
		end

	t_stato_set_final
		do
			create stato_prova.make_with_id ("stato_prova")
			if attached stato_prova as sp then
				sp.set_final
				assert ("final NON è 'true'", sp.finale)
			end
		end

	t_stato_determinismo
--  QUESTO TEST VA RISCRITTO CREANDO UNO STATO CON DUE TRANSIZIONI
--  CON EVENTI DIFFERENTI E VERIFICANDO CHE numero_transizioni_abilitate RESTITUISCE 1
--  QUANDO VIENE INVOCATA CON UNO DEI DUE EVENTI
--  INOLTRE VA CREATO IL TEST SIMMETRICO t_stato_non_determinismo CHE CREA UNO STATO
--  CON DUE TRANSIZIONI CON LO STESSO EVENTO E VERIFICANDO CHE numero_transizioni_abilitate RESTITUISCE 2
--  QUANDO VIENE INVOCATA CON L'EVENTO
--  IL CASO PIU' SEMPLICE E' SE LA TRANSIZIONE HA SOLO EVENTO OPPURE SOLO CONDIZIONE (CHE SONO DUE CASI)
--  IL CASO PIU' COMPLESSO E' SE LA TRANSIZIONE HA SIA EVENTO CHE CONDIZIONE
		local
			hash_di_prova: HASH_TABLE [BOOLEAN, STRING]
		do
			create stato_prova.make_with_id ("stato_prova")
			create target_prova_1.make_with_id ("target_prova_1")
			create target_prova_2.make_with_id ("target_prova_2")
			if attached target_prova_1 as tp1 then create transizione_prova_1.make_with_target(tp1) end
			if attached target_prova_2 as tp2 then create transizione_prova_2.make_with_target(tp2) end
			if attached transizione_prova_1 as trp1 then trp1.set_evento ("effe") trp1.set_condizione ("alfa") end
			if attached transizione_prova_2 as trp2 then trp2.set_evento ("effe") trp2.set_condizione ("beta") end

			create hash_di_prova.make (2)
			hash_di_prova.p
			hash_di_prova.put (FALSE, "acca")
			hash_di_prova.put (FALSE, "emme")
			if attached stato_prova as sp then
				assert("c'è determinismo", sp.numero_transizioni_abilitate ("effe", hash_di_prova)=1)
			end

--			create hash_di_prova.make (2)
--			hash_di_prova.put (TRUE, "Pippo" )
--			hash_di_prova.put (FALSE, "Pluto" )
--			hash_di_prova.put (TRUE, "Minnie" )
--			if attached stato_prova as sp then
--				assert ("non c'è determinismo, invece dovrebbe esserci!!!",
--				sp.numero_transizioni_abilitate ("stringa che non esiste", hash_di_prova) > 0)
--			end
		end

		--	t_stato_target

		--		do
		--			create stato_prova.make_with_id ("stato_prova")

		--			if attached stato_prova as sp then
		--				assert ("restituito target non void, mentre doveva restituirlo void", sp.target("ti sfido a trovare uno stato con questo nome")=Void)
		--			end

		--		end

	t_stato_get_events
		local
			e: ESECUTORE
			eventi: ARRAY [STRING]
		do
			create e.start
			if attached e.state_chart.stati.item ("reset") as reset then
				eventi := reset.get_events
				assert ("Fatto male count", eventi.count = 1)
				assert ("Fatto male contenuto", eventi [1] ~ "watch_start")
			end
		end

end
