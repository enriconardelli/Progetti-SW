note
	description: "Summary description for {NEW_LINKED_LIST}."
	author: "Project new_linked_list"
	date: "$Date$"
	revision: "$Revision$"

class
	INT_LINKED_LIST

feature -- Accesso

	first_element: detachable INT_LINKABLE
			-- Il primo elemento della lista.

	last_element: detachable INT_LINKABLE
			-- L'ultimo elemento della lista.

	active_element: detachable INT_LINKABLE
			-- L'elemento corrente della lista, cioè il cursore.
			-- Può essere Void anche se la lista non è vuota.
			-- Viene modificato solo dalle feature di spostamento del cursore
			-- o dalle feature di cancellazione che rimuovono l'elemento corrente.

	count: INTEGER
			-- Il numero di elementi della lista.

feature -- Spostamento del cursore

	start
			-- Sposta il cursore al primo elemento.
		do
			active_element := first_element
		ensure
			active_element = first_element
		end

	last
			-- Sposta il cursore all'ultimo elemento.
		do
			active_element := last_element
		ensure
			active_element = last_element
		end

	forth
			-- Sposta l'elemento corrente, se esiste, all'elemento successivo.
		require
			active_element /= Void
		do
			if attached active_element as ae then
				active_element := ae.next
			end
		ensure
			attached old active_element as ae implies active_element = ae.next
		end

feature -- Ricerca

	has (a_value: INTEGER): BOOLEAN
			-- La lista contiene `a_value'?
		local
			current_element, previous_element: detachable INT_LINKABLE -- like first_element
			k: INTEGER
		do
			from
				current_element := first_element
				previous_element := Void
				k := 0
			invariant
				not Result implies (previous_element /= Void implies previous_element.value /= a_value)
				Result implies (previous_element /= Void implies previous_element.value = a_value)
			until
				(current_element = Void) or Result
			loop
				if current_element.value = a_value then
					Result := True
				end
				previous_element := current_element
				current_element := current_element.next
				k := k + 1
			variant
				count - k
			end
		end

	has_CON_ACTIVE (a_value: INTEGER): BOOLEAN
			-- La lista contiene `a_value'?
		local
			currently_active, previous_element: like first_element
			k: INTEGER
		do
			currently_active := active_element
			from
				start
				previous_element := Void
				k := 0
			invariant
				not Result implies (previous_element /= Void implies previous_element.value /= a_value)
				Result implies (previous_element /= Void implies previous_element.value = a_value)
			until
				(active_element = Void) or Result
			loop
				if attached active_element as ae and then ae.value = a_value then
					Result := True
				end
				previous_element := active_element
				forth
				k := k + 1
			variant
				count - k
			end
			active_element := currently_active
		end

	get_element (a_value: INTEGER): detachable INT_LINKABLE
			-- Ritorna il primo elemento che contiene `a_value', se esiste.
		local
			current_element, previous_element: like first_element
			k: INTEGER
		do
			from
				current_element := first_element
				previous_element := Void
				k := 0
			invariant
				previous_element /= Void implies previous_element.value /= a_value
			until
				current_element = Void or else current_element.value = a_value
			loop
				previous_element := current_element
				current_element := current_element.next
				k := k + 1
			variant
				count - k
			end
			Result := current_element
		ensure
			Result /= Void implies Result.value = a_value
			Result = Void implies not has (a_value)
		end

feature -- Inserimento singolo libero

	append (a_value: INTEGER)
			-- Aggiunge `a_value' alla fine della lista.
		local
			new_element: like first_element
		do
			create new_element.set_value (a_value)
			if count = 0 then
				first_element := new_element
			else
				if attached last_element as le then
					le.link_to (new_element)
				end
			end
			last_element := new_element
			count := count + 1
		ensure
			uno_in_piu: count = old count + 1
			accodato: attached last_element as le implies le.value = a_value
			collegato: attached old last_element as ole implies ole.next = last_element
		end

	prepend (a_value: INTEGER)
			-- Aggiunge `a_value' all'inizio della lista.
		local
			new_element: like first_element
		do
			create new_element.set_value (a_value)
			if count /= 0 then
				new_element.link_to (first_element)
			else
				last_element := new_element
			end
			first_element := new_element
			count := count + 1
		ensure
			uno_in_piu: count = old count + 1
			messo_in_testa: attached first_element as fe implies fe.value = a_value
			collegato: attached first_element as fe implies fe.next = old first_element
		end

feature -- Inserimento singolo vincolato

	insert_after (a_value, target: INTEGER)
			-- Aggiunge `a_value' subito dopo la prima occorrenza di `target', se esiste,
			-- altrimenti lo aggiunge alla fine della lista.
		local
			current_element, pre_current, new_element: like first_element
		do
			create new_element.set_value (a_value)
			from
				pre_current := Void
				current_element := first_element
			until
				current_element = Void or else current_element.value = target
			loop
				pre_current := current_element
				current_element := current_element.next
			end
			if current_element /= Void then
				new_element.link_after (current_element)
				if last_element = current_element then
					last_element := new_element
				end
			else -- la list non contiene `target'
				if count = 0 then
					first_element := new_element
					last_element := new_element
				else
					if attached last_element as le then
						new_element.link_after (le)
					end
					last_element := new_element
				end
			end
			count := count + 1
		ensure
			uno_in_piu: count = old count + 1
			accodato_se_non_presente: not old has (target) implies (attached last_element as le implies le.value = a_value)
			collegato_se_presente: old has (target) implies (attached get_element (target) as ge implies (attached ge.next as gen implies gen.value = a_value))
		end

	insert_after_reusing (a_value, target: INTEGER)
			-- Aggiunge `a_value' subito dopo la prima occorrenza di `target', se esiste,
			-- altrimenti lo aggiunge alla fine della lista.
			-- Implementazione che riusa le feature `get_element' e `append'
		local
			current_element, new_element: like first_element
		do
			current_element := get_element (target)
			if current_element /= Void then
				create new_element.set_value (a_value)
				new_element.link_after (current_element)
				if current_element = last_element then
					last_element := new_element
				end
				count := count + 1
			else -- la lista non contiene `target'
				append (a_value)
			end
		ensure
			uno_in_piu: count = old count + 1
			accodato_se_non_presente: not old has (target) implies (attached last_element as le implies le.value = a_value)
			collegato_se_presente: old has (target) implies (attached get_element (target) as ge implies (attached ge.next as gen implies gen.value = a_value))
		end

	insert_before (a_value, target: INTEGER)
			-- Aggiunge `a_value' subito prima della prima occorrenza di `target', se esiste,
			-- altrimenti lo aggiunge all'inizio della lista.
		local
			current_element, new_element: like first_element
		do
			create new_element.set_value (a_value)
			if count = 0 then
				first_element := new_element
				last_element := first_element
			else
				if attached first_element as fe and then fe.value = target then
					new_element.link_to (first_element)
					first_element := new_element
				else -- la list contiene almeno un elemento e il primo elemento non ï¿½ `target'
					from
						current_element := first_element
					until
						attached current_element as ce implies ce.next = Void or else (attached ce.next as cen implies cen.value = target)
					loop
						current_element := ce.next
					end
					if attached current_element as ce then
						if ce.next = Void then
							 -- la lista non contiene `target'
							new_element.link_to (first_element)
							first_element := new_element
						else
							new_element.link_after (ce)
						end
					end
				end
			end
			count := count + 1
		ensure
			uno_in_piu: count = old count + 1
			valore_aggiunto: has (a_value)
			in_testa_se_non_presente: not (old has (target)) implies (attached first_element as fe implies fe.value = a_value)
			--	questo invariante sotto si puo' usare solo se a_value e' unico nella lista
			--	se invece posso aggiungere a_value piu' volte nella lista allora non e' piu' vero
			--		collegato_se_presente: old has (target) implies get_element (a_value).next.value = target
		end

	insert_before_with_2_cursors (a_value, target: INTEGER)
			-- Aggiunge `a_value' subito prima della prima occorrenza di `target', se esiste,
			-- altrimenti lo aggiunge all'inizio della lista.
		local
			previous_element, current_element, new_element: like first_element
		do
			create new_element.set_value (a_value)
			if count = 0 then
				first_element := new_element
				last_element := first_element
			else -- la list contiene almeno un elemento
				from
					previous_element := Void
					current_element := first_element
				until
					attached current_element as ce implies ce.value = target
				loop
					previous_element := current_element
					current_element := current_element.next
				end
				if current_element = Void then
					 -- la lista non contiene `target'
					new_element.link_to (first_element)
					first_element := new_element
				else -- `current_element' contiene `target'
					if previous_element = Void then
						new_element.link_to (first_element)
						first_element := new_element
					else
						previous_element.link_to (new_element)
						new_element.link_to (current_element)
					end
				end
--				end
			end
			count := count + 1
		ensure
			uno_in_piu: count = old count + 1
			valore_aggiunto: has (a_value)
			in_testa_se_non_presente: not (old has (target)) implies (attached first_element as fe implies fe.value = a_value)
			--	questo invariante sotto si puo' usare solo se a_value e' unico nella lista
			--	se invece posso aggiungere a_value piu' volte nella lista allora non e' piu' vero
			--		collegato_se_presente: old has (target) implies get_element (a_value).next.value = target
		end

		--  ALTERNATIVE (less efficient) implementation using feature `has'
		--	insert_before (new, target: INTEGER)
		--			-- Insert `new' before `target' if present otherwise add `new' at the end
		--		local
		--			previous_element, new_element: INT_LINKABLE
		--		do
		--			create new_element.make (new)
		--			if has (target) then
		--				if target = first_element.value then
		--					new_element.link_to (first_element)
		--					first_element := new_element
		--				else -- list has at least 2 elements and contains target from second position on
		--					from
		--						previous_element := first_element
		--					until
		--						previous_element.next.value = target
		--					loop
		--						previous_element := previous_element.next
		--					end
		--					new_element.insert_after (previous_element)
		--				end
		--			else -- list does not contain target
		--				if count = 0 then
		--					first_element := new_element
		--					last_element := first_element
		--				else
		--					new_element.link_to (first_element)
		--					first_element := new_element
		--				end
		--			end
		--			count := count + 1
		--		ensure
		--			one_more: count = old count + 1
		--			prepended_if_not_present: not (old has (target)) implies first_element.value = new
		--			linked_if_present: old has (target) implies get_item (new).next.value = target
		--		end

feature -- Status

	value_follows (a_value, target: INTEGER): BOOLEAN
			-- la lista contiene `a_value' in qualunque posizione dopo la prima occorrenza di `target'?
			-- Claudia Agulini, 2020/03/08
		require
			contiene_il_target: has(target)
		local
			previous_element, current_element: like first_element
		do
			from
				current_element := get_element(target)
				previous_element := Void
			invariant
				attached current_element as ce implies
					(ce.value /= a_value implies (attached previous_element as pe implies pe.value /= a_value))
			until
				(current_element = Void) or (attached current_element as ce and then ce.value = a_value)
			loop
				previous_element := current_element
				current_element := current_element.next
			end
			if attached current_element as ce and then ce.value = a_value then
				Result := True
			end
		ensure
--	TODO	serve una feature index_of(a_value) che fornisca l'indice della prima occorrenza di a_value e
--	TODO	che permetta quindi di verificare che index_of(value) sia maggiore di index_of(target)
		end

	value_after (a_value, target: INTEGER): BOOLEAN
			-- la lista contiene `a_value' subito dopo la prima occorrenza di `target'?
		require
			contiene_il_target: has(target)
		local
			current_element: like first_element
		do
			current_element := get_element(target)
			if attached current_element as ce then
				if attached ce.next as cen then
					if cen.value = a_value then
						Result := true
					end
				end
			end
		ensure
			Result implies attached get_element(target) as t and then (attached t.next as tn implies tn.value = a_value)
		end

	value_precedes (a_value, target: INTEGER): BOOLEAN
			--la lista contiene `a_value' prima della prima occorrenza di `target'?
			--Maria Ludovica Sarandrea, 2021/04/03
		require
			contiene_il_target: has(target)
		local
			previous_element, current_element: like first_element
		do
			from
				current_element := first_element
				previous_element := Void
			invariant
				attached current_element as ce implies
					(ce.value /= a_value and ce.value /= target)
						implies (attached previous_element as pe implies (pe.value /= a_value and pe.value /= target))
			until
				attached current_element as ce implies (ce.value = a_value or ce.value = target)
			loop
				previous_element := current_element
				current_element := current_element.next
			end
			if attached current_element as ce and then ce.value = a_value then
				Result := True
			end
--	TODO	serve una feature index_of(a_value) che fornisca l'indice della prima occorrenza di a_value e
--	TODO	che permetta quindi di verificare che index_of(value) sia minore di index_of(target)
		end

	value_before (a_value, target: INTEGER): BOOLEAN
			-- la lista contiene `a_value' subito prima della prima occorrenza di `target'?
			-- Sara Forte 2021/04/03
		require
			contiene_il_target: has(target)
		local
			 current_element, next_element: like first_element
		do
			current_element := get_element(a_value)
			if attached current_element as ce then
				next_element := ce.next
				if attached next_element as ne and then ne.value = target then
					Result := True
				end
			end
		ensure
			Result implies attached get_element(a_value) as t and then (attached t.next as tn implies tn.value = target)
		end

feature -- Insertion multiple targeted

	insert_multiple_after (a_value, target: INTEGER)
			-- inserisce `a_value' subito dopo ogni `target', se ne esistono
			-- altrimenti inserisce `a_value' alla fine
			-- Federico Fiorini 2020/03/08
		local
			new_element, current_element: INT_LINKABLE
			-- target_exist: BOOLEAN
		do
			if has (target) then
				from
					current_element := first_element
				until
					current_element = Void
				loop
					if current_element.value = target then
						create new_element.set_value (a_value)
						new_element.link_after (current_element)
						count := count + 1
						if current_element = last_element then
							last_element := new_element
						end
							-- salta elemento appena inserito
						current_element := new_element.next
					else
						current_element := current_element.next
					end
				end
			else -- la lista non contiene `target'
				create new_element.set_value (a_value)
				if count = 0 then
					first_element := new_element
					last_element := new_element
				else
					if attached last_element as le then
						new_element.link_after (le)
					end
					last_element := new_element
				end
				count := count + 1
			end
		ensure
			di_piu: count > old count
			appeso_se_non_presente: not (old has (target)) and attached last_element as le implies le.value = a_value
			collegato_se_presente: old has (target) and attached get_element (target) as ge and then attached ge.next as gen implies gen.value = a_value
		end

	insert_multiple_before (a_value, target: INTEGER)
			-- inserisce `a_value' subito prima di ogni occorrenza di `target' se esiste
			-- altrimenti inserisce `a_value' all'inizio
			-- Riccardo Malandruccolo, 2020/03/07
		local
			previous_element, current_element, new_element: like first_element
		do
			if has (target) then
				from
					previous_element := Void
					current_element := first_element
				until
					current_element = Void
				loop
					if current_element.value = target then
						create new_element.set_value (a_value)
						if current_element = first_element then
							new_element.link_to (first_element)
							first_element := new_element
						else
							new_element.link_to (current_element)
							if (attached previous_element as pe) then
								pe.link_to (new_element)
							end
						end
						count := count + 1
					end
					previous_element := current_element
					current_element := current_element.next
				end
			else -- la lista non contiene `target'
				create new_element.set_value (a_value)
				if count = 0 then
					first_element := new_element
					last_element := new_element
				else
					new_element.link_to (first_element)
					first_element := new_element
				end
				count := count + 1
			end
		ensure
			di_piu: count > old count
			uno_in_piu_se_non_presente: not (old has (target)) implies count = old count + 1
			in_testa_se_non_presente: (not (old has (target)) and attached first_element as fe) implies fe.value = a_value
			collegato_al_primo_se_non_presente: (not (old has (target)) and (attached first_element as fe)) implies fe.next = old first_element
			collegato_al_primo_se_presente: (old has (target) and (attached get_element (a_value) as el and then attached el.next as eln)) implies eln.value = target
				-- verificare il collegamento con le successive occorrenze di target richiede get_all_elements
		end

feature -- Removal single free

	remove_active
			-- Rimuove elemento accessibile mediante `active_element'
			-- Assegna ad `active_element' il successivo se esiste altrimenti il precedente
			-- Riccardo Malandruccolo, 2020/03/07
		require
			elemento_esiste: count > 0
			active_esiste: active_element /= Void
		local
			current_element, pre_current: like first_element
		do
			if count = 1 then
				first_element := Void
				active_element := Void
				last_element := Void
			else -- la lista ha almeno due elementi
				from
					current_element := first_element
					pre_current := Void
						--				invariant
						--						--invariante da ricontrollare perche' non funziona con remove_all
						--					current_element /= active_element and attached current_element as ce implies ce.next /= Void
				until
					(current_element = active_element)
				loop
					pre_current := current_element
					if attached current_element as ce then
						current_element := ce.next
					end
				end
					--qui `current_element' coincide con `active_element'
				if current_element = first_element then
						--`current_element' cioe' `active_element' e' il primo elemento della lista
					if attached first_element as fe then
						first_element := fe.next
					end
					active_element := first_element
				elseif current_element = last_element then
						--`current_element' cioe' `active_element' e' l'ultimo elemento della lista
					last_element := pre_current
					if attached last_element as le then
						le.link_to (Void)
					end
					active_element := last_element
				else
						--`current_element' cioe' `active_element' e' elemento intermedio della lista
					if attached pre_current as pc and attached current_element as ce then
						pc.link_to (ce.next)
					end
					if attached current_element as ce then
						active_element := ce.next
					end
				end
			end
			count := count - 1
		ensure
			rimosso_elemento: count = old count - 1
			attivo_primo: old active_element = old first_element implies active_element = first_element
			attivo_ultimo: old active_element = old last_element implies active_element = last_element
			attivo_scorre: (old active_element /= old last_element and attached old active_element as oae) implies active_element = oae.next
		end

	remove_first____da_cancellare (a_value: INTEGER)
			-- VIENE RIMPIAZZATA DA REMOVE_EARLIEST
			-- Rimuove il primo elemento che contiene `a_value', se esiste
			-- Aggiorna `active_element', se necessario, al suo successore, se esiste, altrimenti al suo predecessore
		require
			lista_non_vuota: count > 0
		local
			current_element, pre_current: like first_element
		do
				--			from
				--				current_element := first_element
				--				pre_current := Void
				--			invariant
				--				-- alternative version to the invariant in remove_last
				--				current_element /= Void implies (current_element.value /= a_value implies (pre_current /= Void implies pre_current.value /= a_value))
				--			until
				--				(current_element = Void) or else (current_element.value = a_value)
				--			loop
				--				pre_current := current_element
				--				current_element := current_element.next
				--			end
				--			if current_element /= Void then
				--			-- la lista contiene `a_value'
				--				if current_element = active_element then
				--					remove_active
				--				else -- la lista contiene almeno due elementi
				--					if current_element = first_element then
				--							-- `current_element' e' il primo elemento della lista
				--						first_element := first_element.next
				--					elseif current_element = last_element then
				--							-- `current_element' e' l'ultimo elemento della lista
				--						last_element := pre_current
				--						last_element.link_to (Void)
				--					else
				--							-- `current_element'  e' elemento intermedio della lista
				--						pre_current.link_to (current_element.next)
				--					end
				--				count := count - 1
				--				end
				--			end
				--		ensure
				--			rimosso_elemento_se_esiste: old has(a_value) implies count = old count - 1
				--			rimosso_se_primo: old first_element.value = a_value implies first_element = old first_element.next
		end


	remove_last____DA_CANCELLARE (a_value: INTEGER)
			-- GIA' SOSTITUITA RIMPIAZZATA DA REMOVE_LATEST
			-- Rimuove l'ultimo elemento che contiene `a_value', se esiste
			-- Aggiorna `active_element', se necessario, al suo successore, se esiste, altrimenti al suo predecessore
		require
			lista_non_vuota: count > 0
		local
			current_element, pre_current: like first_element
			candidate, pre_candidate: like first_element
		do
				--			from
				--				current_element := first_element
				--				pre_current := Void
				--			invariant
				--				-- alternative version to the invariant in remove_first
				--				attached current_element as a_ce implies (a_ce.value /= a_value implies (attached pre_current as a_pc implies a_pc.value /= a_value))
				--			until
				--				(current_element = Void) or else (current_element.value = a_value)
				--			loop
				--				pre_current := current_element
				--				current_element := current_element.next
				--			end
				--			if current_element /= Void then
				--				-- la lista contiene `a_value'
				--				from
				--					candidate := current_element
				--					pre_candidate := pre_current
				--				invariant
				--					-- non so bene come deve essere fatto questo invariante
				----					attached current_element as a_ce implies (a_ce.value /= a_value implies (attached pre_current as a_pc implies a_pc.value /= a_value))
				--				until
				--					current_element = Void
				--				loop
				--					pre_current := current_element
				--					current_element := current_element.next
				--					if attached current_element as a_ce then
				--						if a_ce.value = a_value then
				--							pre_candidate := pre_current
				--						end
				--					end
				--				end
				--				-- `candidate' e' l'ultimo elemento che contiene `a_value'
				--				if candidate = active_element then
				--					remove_active
				--				else -- la lista contiene almeno due elementi
				--					if candidate = first_element then
				--						-- `candidate' e' il primo elemento della lista
				--						first_element := first_element.next
				--					elseif candidate = last_element then
				--						-- `candidate' e' l'ultimo elemento della lista
				--						last_element := pre_current
				--						last_element.link_to (Void)
				--					else
				--						-- `candidate'  e' elemento intermedio della lista
				--						pre_current.link_to (current_element.next)
				--					end
				--				count := count - 1
				--				end
				--			end
				--		ensure
				--			rimosso_elemento_se_esiste: old has(a_value) implies count = old count - 1
		end

	remove_earliest (a_value: INTEGER)
			-- Rimuovere la prima occorrenza di `a_value', se esiste
			-- Aggiornare `active_element', se necessario, al suo successore, se esiste, altrimenti al suo predecessore
			-- Maria Ludovica Sarandrea, 2021/04/03
		require
			not_empty_list: count > 0
		local
			current_element, pre_current: like first_element
		do
			if count = 1 then
				if attached first_element as fe and then fe.value = a_value then
					first_element := Void
					active_element := Void
					last_element := Void
					count := 0
				end
			else
				from
					current_element := first_element
					pre_current := Void
				until
					(current_element = Void) or (attached current_element as ce implies ce.value = a_value)
				loop
					pre_current := ce
					current_element := ce.next
				end
				if current_element /= Void then
					if current_element = active_element then
						remove_active
					else
						if current_element = first_element then
							if attached first_element as fe then
								first_element:= fe.next
							end
						elseif current_element = last_element then
							last_element := pre_current
							if attached last_element as le then
								le.link_to (Void)
							end
						else -- `current_element' è un elemento intermedio della lista
							if attached pre_current as pe then
								pe.link_to (current_element.next)
							end
						end
						count := count - 1
					end
				end
			end
		end

	remove_latest (a_value: INTEGER)
			-- Rimuove l'ultima occorrenza di `a_value'
			-- Aggiorna `active_element', se necessario, al suo successore, se esiste, altrimenti al suo predecessore
		require
			elemento_esiste: count > 0
		local
			current_element, pre_current, pre_latest: like first_element
		do
			if count = 1 then
				if attached first_element as fe and then fe.value = a_value then
					first_element := Void
					active_element := Void
					last_element := Void
					count := 0
				end
			else -- la lista ha almeno due elementi
				from
					current_element := first_element
					pre_current := Void
					pre_latest := Void
				until
					current_element = Void
				loop
					if current_element.value = a_value then
						pre_latest := pre_current
					end
					pre_current := current_element
					current_element := current_element.next
				end
				if pre_latest = Void then
						-- `a_value' non è presente oppure è il primo elemento
					if attached first_element as fe and then fe.value = a_value then
							-- c'è un sola occorrenza di a_value come primo elemento
						if active_element = first_element then
							active_element := fe.next
						end
						first_element := fe.next
						count := count - 1
					end
				else -- `a_value' è presente e non è il primo elemento
					if attached pre_latest as pl and then attached pl.next as pln then
						pl.link_to (pln.next)
						if pln = last_element then
							last_element := pl
						end
						if pln = active_element then
							if pln.next /= Void then
								active_element := pln.next
							else
								active_element := pl
							end
						end
						count := count - 1
					end
				end
			end
		end

feature -- Removal single targeted

	remove_earliest_following (a_value, target: INTEGER)
			-- remove the first occurrence of `a_value' following first occurrence of `target'
			-- Arianna Calzuola 2020/03/12
		require
			ha_almeno_target: has (target)
		local
			current_element, pre_a_element: like first_element
		do
			if count > 1 then
				from
					pre_a_element := get_element (target)
					if attached pre_a_element then
						if attached pre_a_element.next then
							current_element := pre_a_element.next
						end
					end
				until
					current_element = Void or else current_element.value = a_value
				loop
					pre_a_element := current_element
					current_element := current_element.next
				end
				if attached current_element then
					count := count - 1
					if active_element = current_element then
						if current_element = last_element then
							active_element := pre_a_element
						else
							active_element := current_element.next
						end
					end
					if current_element = last_element then
						if attached pre_a_element then
							pre_a_element.link_to (Void)
						end
						last_element := pre_a_element
					else
						if attached pre_a_element then
							pre_a_element.link_to (current_element.next)
						end
					end
				end
			end
		end

	remove_latest_following (a_value, target: INTEGER)
			-- remove the last occurrence of `a_value' following first occurence of `target'
			-- Alessandro Fiippo 2020/03/12
		require
			ha_almeno_target: has (target)
		local
			current_element: like first_element
			pre_current_element: like first_element
			previous_element, value_element: like first_element
		do
			if count > 0 and has (a_value) then
				if attached get_element (target) as te then
					from
						pre_current_element := te
						current_element := te.next
					until
						current_element = Void or pre_current_element = Void
					loop
						if current_element.value = a_value then --se lo trovo
							previous_element := pre_current_element --mi salvo il precedente all'ultimo con a_value
							value_element := current_element
						end
						current_element := current_element.next -- scorro la lsita
						pre_current_element := pre_current_element.next
					end
						--sono uscito da loop quindi previous e value sono attaccati
						--elimino value element
					if attached previous_element as pe and attached value_element as ve then
							--gestione last e active
						if ve = active_element then
							active_element := pe
						end
						if ve = last_element then
							last_element := pe
						end
						pe.link_to (ve.next)
						count := count - 1
					end
				end
			end
		end

	remove_earliest_preceding (a_value, target: INTEGER)
			-- remove the first occurrence of `a_value' among those preceding first occurrence of `target'
			-- Claudia Agulini, 2020/03/12
		require
			ha_almeno_target: has (target)
		local
			current_element, pre_current: like first_element
		do
			if count > 1 and a_value /= target then
				if attached first_element as fe and then fe.value = a_value then
					if active_element = fe then
						active_element := fe.next
					end
					first_element := fe.next
					count := count - 1
				else -- il primo elemento non contiene `a_value'
					from
						current_element := first_element
						pre_current := Void
					until
						current_element = Void or else (current_element.value = a_value or current_element.value = target)
					loop
						pre_current := current_element
						current_element := current_element.next
					end
					if attached current_element as ce and attached pre_current as pc then
						if ce.value = a_value then
							pc.link_to (ce.next)
							if active_element = ce then
								active_element := ce.next
							end
							count := count - 1
						end
					end
				end
			end
		end

	remove_latest_preceding (a_value, target: INTEGER)
			-- remove the last occurrence of `a_value' among those preceding first occurrence of `target'
			-- Federico Fiorini 2020/03/12
		require
			ha_almeno_target: has (target)
		local
			current_element: like first_element
			pre_value: like first_element
		do
			if count >= 2 and has (a_value) and then get_element (target) /= first_element and value_follows (target, a_value) then
				from
					current_element := first_element
				until
					current_element = get_element (target)
				loop
					if attached current_element as ce then
						if attached current_element.next as cen and then (cen.value = a_value and cen.value /= target) then
							pre_value := current_element
						end
						current_element := current_element.next
					end
				end
				if pre_value = Void then
						--questo if parte solo se value_follows(target, a_value) restituisce true
						--cioï¿½ se nella lista ï¿½ presente prima una qualche istanza di a_value, e poi target
						--quindi una qualche istanza di a_value deve necessariamente esistere
						--se pre_value ï¿½ ancora void, significa che l' unica ricorrenza di a_value deve essere
						--il primo elemento della lista
					if attached first_element as fe then
						if active_element = first_element then
							active_element := fe.next
						end
						first_element := fe.next
					end
				else
					if attached pre_value as pv and then attached pre_value.next as pvn then
						pre_value.link_to (pvn.next)
						if pre_value.next = active_element then
							active_element := pvn.next
						end
					end
				end
				count := count - 1
			end
		end

feature -- Removal multiple free

	remove_all (a_value: INTEGER)
			-- Rimuove tutti gli elementi della lista che contengono `a_value', se esistono
			-- Aggiorna `active_element', se necessario, al suo successore, se esiste, altrimenti al suo predecessore
		require
			lista_non_vuota: count > 0
		local
			current_element, pre_current: like first_element
		do
			if count = 1 then
				if attached first_element as fe and then fe.value = a_value then
					first_element := Void
					active_element := Void
					last_element := Void
					count := 0
				end
			else -- la lista ha almeno due elementi
				from
					current_element := first_element
					pre_current := Void
				until
					current_element = Void
				loop
					if current_element.value = a_value then
						if current_element = active_element then
							remove_active
						else
							if current_element = first_element then
							-- `current_element' e' il primo elemento della lista che ha almeno due elementi
								if attached first_element as fe and then fe.value = a_value then
										first_element := fe.next
								end
							elseif current_element = last_element then
							-- `current_element' e' l'ultimo elemento della lista che ha almeno due elementi
									last_element := pre_current
									if attached last_element as le then
										le.link_to (Void)
									end

							else
							-- `current_element' e' elemento intermedio della lista che ha almeno tre elementi
								if attached pre_current as pc and then attached pc.next as pcn then
									pc.link_to(pcn.next)
								end
							end
							count := count - 1
						end
					end
					pre_current := current_element
					current_element := current_element.next
				end
			end
		ensure
			rimosso_elemento_se_esiste: old has(a_value) implies count < old count
	    end

	wipeout
			-- remove all elements
		do
			first_element := Void
			last_element := Void
			active_element := Void
			count := 0
		end

feature -- Removal multiple targeted

	remove_all_following (a_value, target: INTEGER)
			-- remove all occurrences of `a_value' following first occurrence of `target'
			--if active_element is removed, it's reassigned to the preceding element
			-- Giulia Iezzi 2020/03/11
		require
			contiene_il_target: has (target)
		local
			target_element: like first_element
			current_element: like first_element
			pre_current_element: like first_element
		do
			if count > 0 and has (a_value) then
				target_element := get_element (target)
				if attached target_element as te then
					from
						pre_current_element := te
						current_element := te.next
					invariant
						attached pre_current_element as pce implies (pce /= te implies pce.value /= a_value)
					until
						current_element = Void or pre_current_element = Void
					loop
						if current_element.value = a_value then
							if current_element = last_element then
								last_element := pre_current_element
							end
							if current_element = active_element then
								active_element := pre_current_element
							end
							current_element := current_element.next
							pre_current_element.link_to (current_element)
							count := count - 1
						else
							current_element := current_element.next
							pre_current_element := pre_current_element.next
						end
					end
				end
			end
		ensure
			not old has (target) implies count = old count
			not old has (a_value) implies count = old count
		end

	remove_all_preceding (a_value, target: INTEGER)
			-- remove all occurrences of `a_value' preceding first occurrence of `target'
			-- Riccardo Malandruccolo, 2020/03/11
		require
			contiene_il_target: has (target)
		local
			current_element, pre_current: like first_element
		do
			if has (a_value) and then a_value /= target then
				from
					current_element := first_element
					pre_current := void
				invariant
					(current_element /= void and attached pre_current as pe) implies pe.value /= target
				until
					(current_element = void) or else current_element.value = target
				loop
					if current_element.value = a_value then
						if active_element = current_element then
							active_element := current_element.next
						end
						if current_element = first_element then
							first_element := current_element.next
						end
						current_element := current_element.next
						if attached pre_current as pe then
							pe.link_to (current_element)
						end
						count := count - 1
					else
						pre_current := current_element
						current_element := current_element.next
					end
				end
			end
		ensure
			not old has (a_value) implies count = old count
		end

feature -- Other

	invert
			-- invert the entire list
		local
			curr: like first_element
			perno: like first_element
			rev: like first_element
			new_last_element: like first_element
		do
			new_last_element := first_element
			from
				curr := first_element
			until
				curr = Void
			loop
				perno := curr
				curr := curr.next
				perno.link_to (rev)
				rev := perno
			end
			first_element := rev
			last_element := new_last_element
		ensure
			count = old count
		end

feature -- Manipulation

	head_list (max: INTEGER): like Current
			-- return a list with the first `max' items
			-- RICHIEDE DI AGGIUNGERE `index' e `go_i_th'
		require
			0 <= max
			max <= count
		local
--			k: INTEGER
--			i: INTEGER
		do
			create Result
--			i := index
--			from
--				k := 1
--				start
--			invariant
--				1 <= index
--				index <= max + 1
--				k = index
--			until
--				index > max
--			loop
--				Result.extend (item)
--				k := k + 1
--				forth
--			variant
--				count - index + 1
--			end
--			go_i_th (i)
		end

	tail_list_____da_implementare (max: INTEGER): like Current
			-- return a list with the last `max' items
	do
		create Result
	end

feature -- Computation

	highest: INTEGER
			-- return the value of the highest item
		local
--			slice: like Current
		do
--			create slice.make
--			from
--				start
--				slice := head_list (index - 1)
--			invariant
--				index >= 1
--				index <= count + 1
--				Result >= slice.highest
--			until
--				after
--			loop
--				Result := item.max (Result)
--				forth
--			end
--		ensure
--			across Current as c all c.item <= Result end
		end

	sum_of_positive: INTEGER
			-- valore della somma degli elementi maggiori di zero
		local
			current_element: like first_element
		do
			from
				current_element := first_element
			until
				current_element = Void
			loop
				if current_element.value > 0 then
					Result := Result + current_element.value
				end
				current_element := current_element.next
			end
		ensure
			Result >= 0
		end

feature -- Convenience

	printout
			-- print out the entire list
		local
			temp: like first_element
			i: INTEGER
			r: STRING
		do
			create r.make_from_string ("%N")
			print ("La lista contiene: ")
			from
				temp := first_element
			until
				temp = Void
			loop
				print (temp.value)
				print (", ")
				temp := temp.next
				i := i + 1
			end
			print (r + "  ho stampato in totale ")
			print (i)
			print (" elementi." + r)
			if i /= count then
				print ("ATTENTIONE! LISTA CORROTTA: ")
				print ("SONO STATI STAMPATI UN NUMERO DI ELEMENTI DIVERSO DA COUNT = ")
				print (count)
				print (r)
			end
		end

invariant
	non_negative_counter: count >= 0
	last_reference_is_void: attached last_element as le implies le.next = Void
	consistency_empty_list: count = 0 implies (first_element = last_element) and (first_element = Void) and (first_element = active_element)
	consistency_mono_list: count = 1 implies (first_element = last_element) and (first_element /= Void) and (attached active_element as ae implies ae = first_element)
	consistency_bi_list: count = 2 implies (first_element /= last_element) and (first_element /= Void) and (last_element /= Void) and (attached active_element as ae implies ae = first_element or ae = last_element) and (attached first_element as fe implies fe.next = last_element)
	consistency_pluri_list: count > 2 implies (first_element /= last_element) and (first_element /= Void) and (last_element /= Void) and (attached first_element as fe implies fe.next /= last_element)

end
