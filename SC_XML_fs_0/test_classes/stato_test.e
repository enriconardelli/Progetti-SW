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
	target_prova_1, target_prova_2, target_prova_3: detachable STATO
	transizione_prova_1, transizione_prova_2,  transizione_prova_3: detachable TRANSIZIONE
	hash_di_prova: HASH_TABLE [BOOLEAN, STRING]

feature {NONE} -- Events

	on_prepare
			-- creo stato di prova
		do
			create stato_prova.make_with_id ("stato_prova")
			create target_prova_1.make_with_id ("target_prova_1")
			create target_prova_2.make_with_id ("target_prova_2")
			create target_prova_3.make_with_id ("target_prova_3")
			if attached target_prova_1 as tp1 then create transizione_prova_1.make_with_target(tp1) end
			if attached target_prova_2 as tp2 then create transizione_prova_2.make_with_target(tp2) end
			if attached target_prova_3 as tp3 then create transizione_prova_3.make_with_target(tp3) end
				if attached transizione_prova_1 as trp1 then
				trp1.set_evento ("evento1") trp1.set_condizione ("cond1")
				if attached stato_prova as sp then sp.aggiungi_transizione (trp1)  end
				end
			if attached transizione_prova_2 as trp2 then
				trp2.set_evento ("evento2") trp2.set_condizione ("cond2")
				if attached stato_prova as sp then sp.aggiungi_transizione (trp2)  end
				end
			if attached transizione_prova_3 as trp3 then
				trp3.set_evento ("evento1") trp3.set_condizione ("cond3")
				if attached stato_prova as sp then sp.aggiungi_transizione (trp3)  end
				end

			create hash_di_prova.make (3)
    		hash_di_prova.put (False, "cond1")
    		hash_di_prova.put (False, "cond2")
    		hash_di_prova.put (False, "cond3")

    		

		end


set_hash_di_prova(b1,b2,b3:BOOLEAN)
       do
       		hash_di_prova.replace (b1, "cond1")
			hash_di_prova.replace (b2, "cond2")
			hash_di_prova.replace (b3, "cond3")
       end


feature -- Test routines

	t_make_with_id
		do
			create stato_prova.make_with_id ("stato_prova")
			if attached stato_prova as sp then
				assert ("id NON è 'stato_prova'", sp.id ~ "stato_prova")
				assert ("final NON è 'false'", not sp.finale)
			end
		end

	t_set_final
		do
			create stato_prova.make_with_id ("stato_prova")
			if attached stato_prova as sp then
				sp.set_final
				assert ("final NON è 'true'", sp.finale)
			end
		end

	t_numero_transizioni_abilitate_non_determinismo
		do
			set_hash_di_prova(TRUE,TRUE,TRUE)
			if attached stato_prova as sp then
				assert("ci sono due transizioni abilitate non rilevate", sp.numero_transizioni_abilitate ("evento1", hash_di_prova)=2)
			end
		end

	t_numero_transizioni_abilitate_determinismo
		do
			set_hash_di_prova(TRUE,TRUE,FALSE)
			if attached stato_prova as sp then
					assert("unica transizione abilitata non rilevata", sp.numero_transizioni_abilitate ("evento1", hash_di_prova)=1)
			end
		end

	t_target
		do
			set_hash_di_prova(TRUE,TRUE,FALSE)
			if attached stato_prova as sp then
				if attached sp.target("evento_1",hash_di_prova) as st then
					assert ("target scorretto", st.id ~ "target_prova_1")
				end
				if attached sp.target("evento_2",hash_di_prova) as st then
					assert ("target scorretto", st.id ~ "target_prova_2")
				end
			end
			set_hash_di_prova(FALSE,TRUE,TRUE)
			if attached stato_prova as sp then
				if attached sp.target("evento_1",hash_di_prova) as st then
					assert ("target scorretto", st.id ~ "target_prova_3")
				end
				if attached sp.target("evento_2",hash_di_prova) as st then
					assert ("target scorretto", st.id ~ "target_prova_2")
				end
			end
			set_hash_di_prova(FALSE,FALSE,FALSE)
			if attached stato_prova as sp then
				if attached sp.target("evento_1",hash_di_prova) as st then
					assert ("target scorretto", st = Void)
				end
				if attached sp.target("evento_2",hash_di_prova) as st then
					assert ("target scorretto", st = Void)
				end
			end

		end

	t_numero_transizioni_abilitate_senza_evento_non_determinismo
	do
			set_hash_di_prova(TRUE,TRUE,TRUE)
			if attached stato_prova as sp then
				assert("ci sono due transizioni abilitate non rilevate", sp.numero_transizioni_abilitate_senza_evento (hash_di_prova)=2)
			end
		end




--	t_numero_transizioni_abilitate_non_determinismo
--		do
--			set_hash_di_prova(TRUE,TRUE,TRUE)
--			if attached stato_prova as sp then
--				assert("ci sono due transizioni abilitate non rilevate", sp.numero_transizioni_abilitate ("evento1", hash_di_prova)=2)
--			end
--		end




--	t_stato_get_events
--		local
--			esec: ESECUTORE
--			eventi: ARRAY [STRING]
--		do
--			create esec.start(nomi_files_prova)
--			if attached esec.state_chart.stati.item ("reset") as reset then
--				eventi := reset.get_events
--				assert ("Fatto male count", eventi.count = 1)
--				assert ("Fatto male contenuto", eventi [1] ~ "watch_start")
--			end
--		end


end
