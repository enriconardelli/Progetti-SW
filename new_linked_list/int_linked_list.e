note
	description: "Summary description for {INT_LINKED_LIST}."
	author: "Project new_linked_list"
	date: "$Date$"
	revision: "$Revision$"

class
	INT_LINKED_LIST

feature -- Access

	first_element: detachable INT_LINKABLE
			-- First element of the list.

	last_element: detachable INT_LINKABLE
			-- Last element of the list.

	active_element: detachable INT_LINKABLE
			-- Current element of the list.

	count: INTEGER
			-- Number of elements in the list.

feature -- Cursor movement

	start
			-- Set `active_element' to the first element.
		do
			active_element := first_element
		ensure
			active_element = first_element
		end

	last
			-- Set `active_element' to the last element.
		do
			active_element := last_element
		ensure
			active_element = last_element
		end

	forth
			-- Set `active_element' to the next element, if exists.
		do
			if attached active_element as ae then
				active_element := ae.next
			end
		ensure
			attached old active_element as ae implies active_element = ae.next
		end

feature -- Search

	has (a_value: INTEGER): BOOLEAN
			-- Does the list contain `a_value'?
		local
			current_element, previous_element: like first_element
		do
			from
				current_element := first_element
				previous_element := Void
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
			end
		end

	get_element (a_value: INTEGER): detachable INT_LINKABLE
			-- Return the first element containing `a_value', if exists.
		local
			current_element, previous_element: like first_element
		do
			from
				current_element := first_element
				previous_element := Void
			invariant
				previous_element /= Void implies previous_element.value /= a_value
			until
				current_element = Void or else current_element.value = a_value
			loop
				previous_element := current_element
				current_element := current_element.next
			end
			Result := current_element
		ensure
			Result /= Void implies Result.value = a_value
			Result = Void implies not has (a_value)
		end

feature -- Insertion single free

	append (a_value: INTEGER)
			-- Add `a_value' after `last_element'.
		local
			new_element: like first_element
		do
			create new_element.set_value (a_value)
			if count = 0 then
				first_element := new_element
				active_element := first_element
			else
				if attached last_element as le then
					le.link_to (new_element)
				end
			end
			last_element := new_element
			count := count + 1
		ensure
			one_more: count = old count + 1
			added: attached last_element as le implies le.value = a_value
			linked: attached old last_element as ole implies ole.next = last_element
		end

	prepend (a_value: INTEGER)
			-- aggiunge `a_value' prima del primo elemento.
			-- Arianna Calzuola, 2020/03/10
		local
			new_element: like first_element
		do
			create new_element.set_value (a_value)
			if count /= 0 then
				new_element.link_to (first_element)
			else
				last_element := new_element
				active_element := first_element
			end
			first_element := new_element
			count := count + 1
		ensure
			uno_in_piu: count = old count + 1
			intestato: attached first_element as fe implies fe.value = a_value
			collegato: attached first_element as fe implies fe.next = old first_element
		end

feature -- Insertion single targeted

	insert_after (a_value, target: INTEGER)
			-- Add `a_value' right after first occurrence of `target', if exists,
			-- otherwise add `a_value' at the end of the list.
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
			else -- list does not contain `target'
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
			-- Insert `a_value ' right after first occurence `target ', if exists,
			-- otherwise add `a_value ' after `last_element '.
			-- Implementation reuses existing features get_element and append
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
			else -- list does not contain `target '
				append (a_value)
			end
		ensure
			uno_in_piu: count = old count + 1
			accodato_se_non_presente: not old has (target) implies (attached last_element as le implies le.value = a_value)
			collegato_se_presente: old has (target) implies (attached get_element (target) as ge implies (attached ge.next as gen implies gen.value = a_value))
		end

	insert_before (a_value, target: INTEGER)
			-- inserisce `a_value' subito prima della prima occorrenza di `target' se esiste
			-- altrimenti inserisce `a_value' all'inizio
			-- Alesandro Filippo 2020/03/08
		local
			previous_element, new_element: like first_element
		do
			create new_element.set_value (a_value)
			if count = 0 then
				first_element := new_element
				last_element := first_element
				active_element := first_element
			else
				if attached first_element as fe and then fe.value = target then
					new_element.link_to (first_element)
					first_element := new_element
				else -- list contains at least one element and the first element is not the target
					from
						previous_element := first_element
					until
						attached previous_element as pe implies pe.next = Void or else (attached pe.next as pen implies pen.value = target)
					loop
						if attached previous_element as p then
							previous_element := p.next
						end
					end
					if attached previous_element as pe then
						new_element.link_after (pe)
					else -- list does not contain `target'
						new_element.link_to (first_element)
						first_element := new_element
					end
				end
			end
			count := count + 1
		ensure
			uno_in_piu: count = old count + 1
			in_testa_se_non_presente: not (old has (target)) implies (attached first_element as fe implies fe.value = a_value)
				--							 questo invariante sotto si puo' usare solo se a_value e' unico  nella lista
				--							 se invece posso aggiungere a_value piu' volte nella lista allora non e' piu' vero
				--							 collegato_se_presente: old has (target) implies get_element (a_value).next.value = target
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
			-- la lista contiene `a_value' dopo la prima occorrenza di `target'?
			-- Claudia Agulini, 2020/03/08
		local
			current_element, temp: like first_element
		do
			from
				current_element := get_element (target)
				temp := Void
			invariant
				attached current_element as ce implies (ce.value /= a_value implies (attached temp as t implies t.value /= a_value))
			until
				(current_element = Void) or (attached current_element as ce and then ce.value = a_value)
			loop
				temp := current_element
				current_element := current_element.next
			end
			if attached current_element as ce and then ce.value = a_value then
				Result := True
			end
		end

	value_after___________DA_IMPLEMENTARE (a_value, target: INTEGER): BOOLEAN
			-- la lista contiene `a_value' subito dopo la prima occorrenza di `target'?
		local
			-- current_element, temp: like first_element
		do
				--			from
				--				current_element := get_element(target)
				--				temp := Void
				--			invariant
				--				current_element /= Void implies
				--				  (current_element.value /= a_value implies (temp /= Void implies temp.value /= a_value))
				--			until
				--				(current_element = Void) or (current_element.value = a_value)
				--			loop
				--				temp := current_element
				--				current_element := current_element.next
				--			end
				--			if (current_element /= Void and then current_element.value = a_value) then
				--				Result := True
				--			end
		end

	value_precedes_______________DA_IMPLEMENTARE (a_value, target: INTEGER): BOOLEAN
			--
			-- la lista contiene `a_value' prima della prima occorrenza di `target'?
		local
			-- current_element, temp: like first_element
		do
				--			from
				--				current_element := get_element(target)
				--				temp := Void
				--			invariant
				--				current_element /= Void implies
				--				  (current_element.value /= a_value implies (temp /= Void implies temp.value /= a_value))
				--			until
				--				(current_element = Void) or (current_element.value = a_value)
				--			loop
				--				temp := current_element
				--				current_element := current_element.next
				--			end
				--			if (current_element /= Void and then current_element.value = a_value) then
				--				Result := True
				--			end
		end

	value_before___________DA_IMPLEMENTARE (a_value, target: INTEGER): BOOLEAN
			-- la lista contiene `a_value' subito prima della prima occorrenza di `target'?
		local
			-- current_element, temp: like first_element
		do
				--			from
				--				current_element := get_element(target)
				--				temp := Void
				--			invariant
				--				current_element /= Void implies
				--				  (current_element.value /= a_value implies (temp /= Void implies temp.value /= a_value))
				--			until
				--				(current_element = Void) or (current_element.value = a_value)
				--			loop
				--				temp := current_element
				--				current_element := current_element.next
				--			end
				--			if (current_element /= Void and then current_element.value = a_value) then
				--				Result := True
				--			end
		end

feature -- Insertion multiple targeted

	insert_multiple_after (a_value, target: INTEGER)
			-- inserisce `a_value' subito dopo ogni `target', se ne esistono
			-- altrimenti inserisce `new' alla fine
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
					active_element := first_element
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
					active_element := first_element
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
			-- Rimuove elemento accessibile mediante `active_element' se esiste
			-- Assegna ad `active_element' il successivo se esiste altrimenti il precedente
			-- Riccardo Malandruccolo, 2020/03/07
		require
			elemento_esiste: count > 0
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
				invariant
						--invariante da ricontrollare perche' non funziona con remove_all
					current_element /= active_element and attached current_element as ce implies ce.next /= Void
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

	remove_first____TO_MAKE_VOID_SAFE (a_value: INTEGER)
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

	remove_last____TO_MAKE_VOID_SAFE (a_value: INTEGER)
			-- VIENE RIMPIAZZATA DA REMOVE_LATEST
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

	remove_earliest_______________DA_IMPLEMENTARE (a_value: INTEGER)
			-- Remove the first occurrence of `a_value', if exists
			-- Update `active_element', if needed, to its successor, if exists, otherwise to its predecessor
		require
			not_empty_list: count > 0
		local
			current_element, pre_current: like first_element
		do
				--			from
				--				current_element := first_element
				--				pre_current := Void
				--			invariant
				--				-- TO CHECK alternative version to the invariant in remove_last
				--				-- current_element /= Void implies (current_element.value /= a_value implies (pre_current /= Void implies pre_current.value /= a_value))
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
				--						first_element := first_element.next
				--					elseif current_element = last_element then
				--						last_element := pre_current
				--						last_element.link_to (Void)
				--					else -- `current_element'  e' elemento intermedio della lista
				--						pre_current.link_to (current_element.next)
				--					end
				--					count := count - 1
				--				end
				--			end
				--		ensure
				--			element_removed_if_exists: old has(a_value) implies count = old count - 1
				--			element_removed_if_first: old first_element.value = a_value implies first_element = old first_element.next
		end

	remove_latest (a_value: INTEGER)
			-- remove the last occurrence of `a_value'
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
						if pln.next = Void then
							last_element := pl
						end
						pl.link_to (pln.next)
						count := count - 1
					end
				end
			end
		end

feature -- Removal single targeted

	remove_earliest_following (a_value, target: INTEGER)
	-- Arianna Calzuola 2020/03/12
			-- remove the first occurrence of `a_value' following `target'
		require
			almeno_due_elementi: count > 1
			ha_almeno_taget: has(target)
		local
		a_element, current_element, pre_a_element: like first_element
		do
			from
				pre_a_element := get_element(target)
				if attached pre_a_element then
					if attached pre_a_element.next then
					 current_element :=  pre_a_element.next
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
				if	active_element = current_element then
					active_element := pre_a_element
				end
				if current_element = last_element then
					if attached pre_a_element then
							pre_a_element.link_to(Void)
					end
					last_element := pre_a_element
				else
					if attached pre_a_element then pre_a_element.link_to (current_element.next)
					end
				end
			end
		end


	remove_latest_following (a_value, target: INTEGER)
			-- remove the last occurrence of `a_value' following `target'
			-- Alessandro Fiippo 2020/03/12
		local
			target_element: like first_element
			current_element: like first_element
			pre_current_element: like first_element
			previous_element, value_element: like first_element
			flag: BOOLEAN
		do

			flag:=False --suppongo di non averlo trovato
			if count > 0 and has (target) and has(a_value) then

				target_element := get_element (target)
				if attached target_element as te then
					from
						pre_current_element := te
						current_element := te.next
					until
						current_element = Void or pre_current_element = Void
					loop
						if current_element.value = a_value then --se lo trovo

							previous_element:=pre_current_element --mi salvo il precedente all'ultimo con a_value
							value_element:=current_element
							flag:=True --l'ho trovato

							previous_element := pre_current_element --mi salvo il precedente all'ultimo con a_value
							value_element := current_element

						end
						current_element := current_element.next -- scorro la lsita
						pre_current_element := pre_current_element.next
					end
						--sono uscito da loop quindi previous e value sono attaccati
						--elimino value element
					if attached previous_element as pe then
						if attached value_element as ve then
							pe.link_to (ve.next)
						end
					end
				end
				if flag then count := count - 1
				end
			end

		end

	remove_earliest_preceding (a_value, target: INTEGER)
			-- remove the first occurrence of `a_value' among those preceding `target'
			-- Claudia Agulini, 2020/03/12
		require
			count > 1
			a_value /= target
		local
			current_element, pre_current: like first_element
		do
			if value_follows (target, a_value) then
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
						current_element = get_element(a_value) or current_element = Void
					loop
						pre_current := current_element
						current_element := current_element.next
					end
					-- current_element.value = `a_value' oppure current_element = Void
					if attached current_element as ce and attached pre_current as pc then
						pc.link_to (ce.next)
						count := count - 1
					end
				end
			end
			ensure
				old value_follows(target, a_value) implies count = old count - 1
		end

	remove_latest_preceding (a_value, target: INTEGER)
			-- remove the last occurrence of `a_value' among those preceding `target'
			-- Federico Fiorini 2020/03/12
		require
			a_value/=target
		local
			current_element: like first_element
			pre_value: like first_element
		do
			if count>=2 and has(a_value) and then get_element(target)/=first_element and value_follows(target,a_value) then

				from
					current_element := first_element
				until
					current_element=get_element(target)
				loop
					if attached current_element as ce then
						if  attached current_element.next as cen and then (cen.value=a_value and cen.value/=target) then
							pre_value:=current_element
						end
						current_element:=current_element.next
					end
				end

				if pre_value = Void then
					--questo if parte solo se value_follows(target, a_value) restituisce true
					--cioè se nella lista è presente prima una qualche istanza di a_value, e poi target
					--quindi una qualche istanza di a_value deve necessariamente esistere
					--se pre_value è ancora void, significa che l' unica ricorrenza di a_value deve essere
					--il primo elemento della lista
					if attached first_element as fe then
						if active_element = first_element then
							active_element := fe.next
						end
						first_element:=fe.next
					end
				else
					if attached pre_value as pv and then attached pre_value.next as pvn then
						pre_value.link_to(pvn.next)
						if pre_value.next=active_element then
							active_element:=pvn.next
						end
					end
				end
				count:= count - 1
			end

		end

feature -- Removal multiple free

	remove_all____TO_MAKE_VOID_SAFE (a_value: INTEGER)
			-- Rimuove tutti gli elementi della lista che contengono `a_value', se esistono
			-- Aggiorna `active_element', se necessario, al suo successore, se esiste, altrimenti al suo predecessore
		require
			lista_non_vuota: count > 0
		local
			current_element, pre_current: like first_element
		do
				--			from
				--				current_element := first_element
				--				pre_current := Void
				----			invariant
				----              -- invariante per questo è ancora da scrivere
				--			until
				--				current_element = Void
				--			loop
				--				if current_element.value = a_value then
				--					if current_element = active_element then
				--						remove_active
				--					else -- la lista ha almeno due elementi
				--						if current_element = first_element then
				--							-- `current_element' e' il primo elemento della lista che ha almeno due elementi
				--							first_element := first_element.next
				--						elseif current_element = last_element then
				--							-- `current_element' e' l'ultimo elemento della lista che ha almeno due elementi
				--							last_element := pre_current
				--							last_element.link_to (Void)
				--						else
				--							-- `current_element' e' elemento intermedio della lista che ha almeno tre elementi
				--							pre_current.link_to(current_element.next)
				--						end
				--						count := count - 1
				--					end
				--				end
				--				pre_current := current_element
				--				current_element := current_element.next
				--			end
				--		ensure
				--			rimosso_elemento_se_esiste: old has(a_value) implies count <= old count - 1
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
			-- remove all occurrences of `a_value' following `target'
			-- if `target' exists otherwise does nothing
			-- Giulia Iezzi 2020/03/11
		local
			target_element: like first_element
			current_element: like first_element
			pre_current_element: like first_element
		do
			if count > 0 and has (target) and has (a_value) then
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
			-- remove all occurrences of `a_value' preceding `target'
			-- if `target' exists otherwise does nothing
			-- Riccardo Malandruccolo, 2020/03/11
		require
			count > 0
			a_value /= target
		local
			current_element, pre_current: like first_element
		do
			if count = 1 then
				if attached first_element as fe and then fe.value = a_value then
					first_element := void
					active_element := void
					last_element := void
					count := 0
				end
			else
				from
					current_element := first_element
					pre_current := void
				invariant
					(current_element /= void and attached pre_current as pe) implies pe.value /= target
				until
					(current_element = void) or else current_element.value = target
				loop
					if current_element.value = a_value then

						if current_element = first_element then
							if active_element = first_element then
								active_element := current_element.next
							end
							first_element := current_element.next
						elseif current_element = last_element then
							if active_element = last_element then
								active_element := pre_current
							end
							last_element := pre_current
						else
							if active_element = current_element then
								active_element := current_element.next
							end
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
			not old has(a_value) implies count = old count
			has(a_value) implies has(target)
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

feature -- Convenience

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

	printout
			-- print out the entire list
		local
			temp: like first_element
			i: INTEGER
			r: STRING
		do
			create r.make_from_string ("%N")
			print ("The list contains: ")
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
			print (r + " printed in total ")
			print (i)
			print (" elements." + r)
			if i /= count then
				print ("ATTENTION! WRONG LIST:")
				print ("PRINTED A NUMBER OF ELEMENT DIFFERENT FROM COUNT = ")
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
