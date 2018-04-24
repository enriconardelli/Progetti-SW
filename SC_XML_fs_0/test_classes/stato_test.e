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

	stato_prova, stato_prova_senza_evento: detachable STATO

	target_prova_1, target_prova_2, target_prova_3: detachable STATO

	target_prova_senza_evento_1, target_prova_senza_evento_2, target_prova_senza_evento_3: detachable STATO

	transizione_prova_1, transizione_prova_2, transizione_prova_3: detachable TRANSIZIONE

	transizione_prova_senza_evento_1, transizione_prova_senza_evento_2, transizione_prova_senza_evento_3: detachable TRANSIZIONE

	hash_di_prova, hash_di_prova_senza_evento: HASH_TABLE [BOOLEAN, STRING]

	hash_di_prova_evento: HASH_TABLE [STRING, STRING]

feature {NONE} -- Events

	on_prepare
		do
				-- creo stato di prova con evento
			create stato_prova.make_with_id ("stato_prova")
			create target_prova_1.make_with_id ("target_prova_1")
			create target_prova_2.make_with_id ("target_prova_2")
			create target_prova_3.make_with_id ("target_prova_3")
			if attached target_prova_1 as tp1 then
				create transizione_prova_1.make_with_target (tp1)
			end
			if attached target_prova_2 as tp2 then
				create transizione_prova_2.make_with_target (tp2)
			end
			if attached target_prova_3 as tp3 then
				create transizione_prova_3.make_with_target (tp3)
			end
			if attached transizione_prova_1 as trp1 then
				trp1.set_evento ("evento1")
				trp1.set_condizione ("cond1")
				if attached stato_prova as sp then
					sp.aggiungi_transizione (trp1)
				end
			end
			if attached transizione_prova_2 as trp2 then
				trp2.set_evento ("evento2")
				trp2.set_condizione ("cond2")
				if attached stato_prova as sp then
					sp.aggiungi_transizione (trp2)
				end
			end
			if attached transizione_prova_3 as trp3 then
				trp3.set_evento ("evento1")
				trp3.set_condizione ("cond3")
				if attached stato_prova as sp then
					sp.aggiungi_transizione (trp3)
				end
			end
			create hash_di_prova.make (3)
			hash_di_prova.put (False, "cond1")
			hash_di_prova.put (False, "cond2")
			hash_di_prova.put (False, "cond3")

				--creo stato di prova senza evento
			create stato_prova_senza_evento.make_final_with_id ("stato_prova_senza_evento")
			create target_prova_senza_evento_1.make_with_id ("target_prova_senza_evento_1")
			create target_prova_senza_evento_2.make_with_id ("target_prova_senza_evento_2")
			create target_prova_senza_evento_3.make_with_id ("target_prova_senza_evento_3")
			if attached target_prova_senza_evento_1 as tpse1 then
				create transizione_prova_senza_evento_1.make_with_target (tpse1)
			end
			if attached target_prova_senza_evento_2 as tpse2 then
				create transizione_prova_senza_evento_2.make_with_target (tpse2)
			end
			if attached target_prova_senza_evento_3 as tpse3 then
				create transizione_prova_senza_evento_3.make_with_target (tpse3)
			end
			if attached transizione_prova_senza_evento_1 as trpse1 then
				trpse1.set_condizione ("cond1")
				if attached stato_prova_senza_evento as spse then
					spse.aggiungi_transizione (trpse1)
				end
			end
			if attached transizione_prova_senza_evento_2 as trpse2 then
				trpse2.set_condizione ("cond2")
				if attached stato_prova_senza_evento as spse then
					spse.aggiungi_transizione (trpse2)
				end
			end
			if attached transizione_prova_senza_evento_3 as trpse3 then
				trpse3.set_condizione ("cond2")
				if attached stato_prova_senza_evento as spse then
					spse.aggiungi_transizione (trpse3)
				end
			end
			create hash_di_prova_senza_evento.make (2)
			hash_di_prova_senza_evento.put (False, "cond1")
			hash_di_prova_senza_evento.put (False, "cond2")

			create hash_di_prova_evento.make (3)
			hash_di_prova_evento.put ("evento1", "evento1")
			hash_di_prova_evento.put ("evento2", "evento2")
			hash_di_prova_evento.put ("evento3", "evento3")
		end

feature -- Test routines

	set_hash_di_prova (b1, b2, b3: BOOLEAN)
		do
			hash_di_prova.replace (b1, "cond1")
			hash_di_prova.replace (b2, "cond2")
			hash_di_prova.replace (b3, "cond3")
		end

	set_hash_di_prova_evento (b1, b2, b3: STRING)
		do
			hash_di_prova_evento.wipe_out
			hash_di_prova_evento.put (b1, b1)
			hash_di_prova_evento.put (b2, b2)
			hash_di_prova_evento.put (b3, b3)
		end

		--	set_hash_di_prova_senza_evento(b1,b2:BOOLEAN)
		--       do
		--       		hash_di_prova_senza_evento.replace (b1, "cond1")
		--			hash_di_prova_senza_evento.replace (b2, "cond2")
		--	   end

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

		-- Test per features con evento

	t_abilitata_con_evento_non_esistente
		do
			set_hash_di_prova_evento ("non", "non", "non")
			if attached stato_prova as sp then
				assert ("ERRORE: transizione abilitata con evento non_esistente", sp.transizione_abilitata (hash_di_prova_evento, hash_di_prova) = Void)
			end
		end

	t_abilitata_con_evento_unica
		do
			set_hash_di_prova (TRUE, TRUE, TRUE)
			set_hash_di_prova_evento ("non", "evento2", "non")
			if attached stato_prova as sp then
				assert ("ERRORE: transizione abilitata con evento unica non rilevata", sp.transizione_abilitata (hash_di_prova_evento, hash_di_prova) = transizione_prova_2)
			end
		end

	t_abilitata_con_evento_molteplici
		do
			set_hash_di_prova (TRUE, FALSE, TRUE)
			set_hash_di_prova_evento ("evento1", "evento2", "evento3")
			if attached stato_prova as sp then
				assert ("ERRORE: transizione abilitata con evento molteplici non rivela quella corretta", sp.transizione_abilitata (hash_di_prova_evento, hash_di_prova) = transizione_prova_1)
			end
		end

	t_attivabile_con_evento
		do
			if attached stato_prova as sp then
				set_hash_di_prova (TRUE, FALSE, FALSE)
				assert ("la prima transizione attivabile non e' rilevata", sp.attivabile (1, "evento1", hash_di_prova))
				set_hash_di_prova (TRUE, TRUE, FALSE)
				assert ("la seconda transizione attivabile non e' rilevata", sp.attivabile (2, "evento2", hash_di_prova))
				set_hash_di_prova (FALSE, FALSE, TRUE)
				assert ("la terza transizione attivabile non e' rilevata", sp.attivabile (3, "evento1", hash_di_prova))
			end
		end

	t_numero_transizioni_abilitate_con_evento_non_determinismo
		do
			set_hash_di_prova (TRUE, TRUE, TRUE)
			if attached stato_prova as sp then
				assert ("ci sono due transizioni abilitate non rilevate", sp.numero_transizioni_abilitate ("evento1", hash_di_prova) = 2)
			end
		end

	t_numero_transizioni_abilitate_con_evento_determinismo
		do
			set_hash_di_prova (TRUE, TRUE, FALSE)
			if attached stato_prova as sp then
				assert ("unica transizione abilitata non rilevata", sp.numero_transizioni_abilitate ("evento1", hash_di_prova) = 1)
			end
		end

--	t_target_con_evento
--		do
--			set_hash_di_prova (TRUE, TRUE, FALSE)
--			if attached stato_prova as sp then
--				if attached sp.target ("evento1", hash_di_prova) as st then
--					assert ("target scorretto: TTF + e1", st.id ~ "target_prova_1")
--				end
--				if attached sp.target ("evento2", hash_di_prova) as st then
--					assert ("target scorretto: TTF + e2", st.id ~ "target_prova_2")
--				end
--			end
--			set_hash_di_prova (FALSE, TRUE, TRUE)
--			if attached stato_prova as sp then
--				if attached sp.target ("evento1", hash_di_prova) as st then
--					assert ("target scorretto: FTT + e1", st.id ~ "target_prova_3")
--				end
--				if attached sp.target ("evento2", hash_di_prova) as st then
--					assert ("target scorretto: FTT + e2", st.id ~ "target_prova_2")
--				end
--			end
--			set_hash_di_prova (FALSE, FALSE, FALSE)
--			if attached stato_prova as sp then
--				if attached sp.target ("evento1", hash_di_prova) as st then
--					assert ("target scorretto: FFF + e1", st = sp)
--				end
--				if attached sp.target ("evento2", hash_di_prova) as st then
--					assert ("target scorretto: FFF + e2", st = sp)
--				end
--			end
--		end

		-- Test per features senza evento

		--	t_numero_transizioni_abilitate_senza_evento_non_determinismo
		--		do
		--			set_hash_di_prova_senza_evento(FALSE,TRUE)
		--			if attached stato_prova_senza_evento as spse then
		--				assert("ci sono due transizioni abilitate non rilevate", spse.numero_transizioni_abilitate_senza_evento (hash_di_prova_senza_evento)=2)
		--			end
		--		end

		--	t_numero_transizioni_abilitate_senza_evento_determinismo
		--		do
		--			set_hash_di_prova_senza_evento(TRUE,FALSE)
		--			if attached stato_prova_senza_evento as spse then
		--				assert("unica transizione abilitata non rilevata", spse.numero_transizioni_abilitate_senza_evento (hash_di_prova_senza_evento)=1)
		--			end
		--		end

		--	t_attivabile_senza_evento
		--		do
		--			if attached stato_prova_senza_evento as spse then
		--				set_hash_di_prova_senza_evento(TRUE,FALSE)
		--				assert("la prima transizione attivabile non e' rilevata", spse.attivabile_senza_evento (1, hash_di_prova_senza_evento))
		--			end
		--		end

		--	t_target_senza_evento
		--		do
		--			set_hash_di_prova_senza_evento(TRUE,FALSE)
		--			if attached stato_prova_senza_evento as spse then
		--				if attached spse.target_senza_evento (hash_di_prova_senza_evento)as stse then
		--					assert("target scorretto", stse.id ~ "target_prova_senza_evento_1")
		--				end
		--			end
		--			set_hash_di_prova_senza_evento(FALSE,FALSE)
		--			if attached stato_prova_senza_evento as spse then
		--				if attached spse.target_senza_evento (hash_di_prova_senza_evento)as stse then
		--					assert("target scorretto", stse.id = Void)
		--				end
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
