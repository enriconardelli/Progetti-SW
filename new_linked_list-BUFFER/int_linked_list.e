note
	description: "Summary description for {INT_LINKED_LIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INT_LINKED_LIST

feature -- accesso

	first_element: INT_LINKABLE
			-- il primo elemento della lista

	last_element: INT_LINKABLE
			-- l'ultimo elemento della lista

	count: INTEGER
			-- numero di elementi nella lista

	active_element: INT_LINKABLE
			-- l'elemento corrente della lista

feature -- comandi fondamentali

	forth
			-- Sposta `current_element' al successivo elemento, se esiste
		do
			if active_element /= Void and then active_element.next /= Void then
				active_element := active_element.next
			end
		end

	start
			-- Sposta `current_element' al primo elemento, se esiste
		do
			if first_element /= Void then
				active_element := first_element
			end
		end

	last
			-- Sposta `current_element' all'ultimo elemento, se esiste
		do
			if last_element /= Void then
				active_element := last_element
			end
		end

	append (a_value: INTEGER)
			-- aggiunge `a_value' dopo l'ultimo elemento.
		local
			new_element: like first_element
		do
			create new_element.make (a_value)
			if count = 0 then
				first_element := new_element
				active_element := first_element
			else
				last_element.link_to (new_element)
			end
			last_element := new_element
			count := count + 1
		ensure
			uno_in_piu: count = old count + 1
			accodato: last_element.value = a_value
			collegato: (old last_element /= Void) implies (old last_element).next = last_element
		end

	prepend (a_value: INTEGER)
			-- aggiunge `a_value' prima del primo elemento.
		local
			new_element: like first_element
		do
			create new_element.make (a_value)
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
			intestato: first_element.value = a_value
			collegato: first_element.next = old first_element
		end

	remove_active
			-- Rimuove elemento accessibile mediante `active_element' se esiste
			-- Assegna ad `active_element' il successivo se esiste altrimenti il precedente
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
					-- invariante da ricontrollare perche' non funziona con remove_all
--					current_element /= active_element implies current_element.next /= Void
				until
					(current_element = active_element)
				loop
					pre_current := current_element
					current_element := current_element.next
				end
					-- qui `current_element' coincide con `active_element'
				if current_element = first_element then
						-- `current_element' cioe' `active_element' e' il primo elemento della lista
					first_element := first_element.next
					active_element := first_element
				elseif current_element = last_element then
						-- `current_element' cioe' `active_element' e' l'ultimo elemento della lista
					last_element := pre_current
					last_element.link_to (Void)
					active_element := last_element
				else
						-- `current_element' cioe' `active_element' e' elemento intermedio della lista
					pre_current.link_to (current_element.next)
					active_element := current_element.next
				end
			end
			count := count - 1
		ensure
			rimosso_elemento: count = old count - 1
			attivo_primo: old active_element = old first_element implies active_element = first_element
			attivo_ultimo: old active_element = old last_element implies active_element = last_element
			attivo_scorre: old active_element /= old last_element implies active_element = old active_element.next

		end

	remove_first (a_value: INTEGER)
			-- Rimuove il primo elemento che contiene `a_value', se esiste
			-- Aggiorna `active_element', se necessario, al suo successore, se esiste, altrimenti al suo predecessore
		require
			lista_non_vuota: count > 0
		local
			current_element, pre_current: like first_element
		do
			from
				current_element := first_element
				pre_current := Void
			invariant
				-- alternative version to the invariant in remove_last
				current_element /= Void implies (current_element.value /= a_value implies (pre_current /= Void implies pre_current.value /= a_value))
			until
				(current_element = Void) or else (current_element.value = a_value)
			loop
				pre_current := current_element
				current_element := current_element.next
			end
			if current_element /= Void then
			-- la lista contiene `a_value'
				if current_element = active_element then
					remove_active
				else -- la lista contiene almeno due elementi
					if current_element = first_element then
							-- `current_element' e' il primo elemento della lista
						first_element := first_element.next
					elseif current_element = last_element then
							-- `current_element' e' l'ultimo elemento della lista
						last_element := pre_current
						last_element.link_to (Void)
					else
							-- `current_element'  e' elemento intermedio della lista
						pre_current.link_to (current_element.next)
					end
				count := count - 1
				end
			end
		ensure
			rimosso_elemento_se_esiste: old has(a_value) implies count = old count - 1
			rimosso_se_primo: old first_element.value = a_value implies first_element = old first_element.next
		end

	remove_last (a_value: INTEGER)
			-- Rimuove l'ultimo elemento che contiene `a_value', se esiste
			-- Aggiorna `active_element', se necessario, al suo successore, se esiste, altrimenti al suo predecessore
		require
			lista_non_vuota: count > 0
		local
			current_element, pre_current: like first_element
			candidate, pre_candidate: like first_element
		do
			from
				current_element := first_element
				pre_current := Void
			invariant
				-- alternative version to the invariant in remove_first
				attached current_element as a_ce implies (a_ce.value /= a_value implies (attached pre_current as a_pc implies a_pc.value /= a_value))
			until
				(current_element = Void) or else (current_element.value = a_value)
			loop
				pre_current := current_element
				current_element := current_element.next
			end
			if current_element /= Void then
				-- la lista contiene `a_value'
				from
					candidate := current_element
					pre_candidate := pre_current
				invariant
					-- non so bene come deve essere fatto questo invariante
--					attached current_element as a_ce implies (a_ce.value /= a_value implies (attached pre_current as a_pc implies a_pc.value /= a_value))
				until
					current_element = Void
				loop
					pre_current := current_element
					current_element := current_element.next
					if attached current_element as a_ce then
						if a_ce.value = a_value then
							pre_candidate := pre_current
						end
					end
				end
				-- `candidate' e' l'ultimo elemento che contiene `a_value'
				if candidate = active_element then
					remove_active
				else -- la lista contiene almeno due elementi
					if candidate = first_element then
						-- `candidate' e' il primo elemento della lista
						first_element := first_element.next
					elseif candidate = last_element then
						-- `candidate' e' l'ultimo elemento della lista
						last_element := pre_current
						last_element.link_to (Void)
					else
						-- `candidate'  e' elemento intermedio della lista
						pre_current.link_to (current_element.next)
					end
				count := count - 1
				end
			end
		ensure
			rimosso_elemento_se_esiste: old has(a_value) implies count = old count - 1
		end

	remove_last_WRONG (a_value: INTEGER)
			-- Rimuove l'ultimo elemento che contiene `a_value', se esiste
			-- Aggiorna `active_element', se necessario, al suo successore, se esiste, altrimenti al suo predecessore
		require
			lista_non_vuota: count > 0
		local
			current_element, pre_current: like first_element
			pre_candidate: like first_element
		do
			from
				current_element := first_element
				pre_current := Void
			invariant
				-- alternative version to the invariant in remove_first
				attached current_element as a_ce implies (a_ce.value /= a_value implies (attached pre_current as a_pc implies a_pc.value /= a_value))
			until
				(current_element = Void) or else (current_element.value = a_value)
			loop
				pre_current := current_element
				current_element := current_element.next
			end
			if current_element /= Void then
				-- la lista contiene `a_value'
				from
--					candidate := current_element
--					pre_candidate := pre_current
				invariant
					-- alternative version to the invariant in remove_first
--					attached current_element as a_ce implies (a_ce.value /= a_value implies (attached pre_current as a_pc implies a_pc.value /= a_value))
				until
					current_element.next = Void
				loop
--					pre_current := current_element
--					current_element := current_element.next
					if attached current_element.next as a_cen then
						if a_cen.value = a_value then
--  qui dentro non si entra nel caso di una lista di almeno due elementi in cui il primo
-- e' quello che devo cancellare perche' il test e' fatto sul valore del secondo elemento
-- il risultato è che pre_candidate (o pre_currente se si usa solo quello) rimane Void
-- e alla prima istruzione dopo l'uscita dal loop c'è errore Void target
							pre_candidate := current_element
						end
					end
					current_element := current_element.next
				end
				-- `pre_candidate' precede l'ultimo elemento che contiene `a_value'
				current_element := pre_candidate.next
				if current_element = active_element then
					remove_active
				else -- la lista contiene almeno due elementi
					if current_element = first_element then
						-- `current_element' e' il primo elemento della lista
						first_element := first_element.next
					elseif current_element = last_element then
						-- `current_element' e' l'ultimo elemento della lista
						last_element := pre_current
						last_element.link_to (Void)
					else
						-- `current_element'  e' elemento intermedio della lista
						pre_current.link_to (current_element.next)
					end
				count := count - 1
				end
			end
		ensure
			rimosso_elemento_se_esiste: old has(a_value) implies count = old count - 1
		end

	remove_all_compito (a_value: INTEGER)
			-- Rimuove tutti gli elementi della lista che contengono `a_value', se esistono
			-- Aggiorna `active_element', se necessario, al suo successore, se esiste, altrimenti al suo predecessore
		require
			lista_non_vuota: count > 0
		local
			current_element, pre_current: like first_element
			candidate, pre_candidate: like first_element
		do
			from
				current_element := first_element
				pre_current := Void
--			invariant
--              -- invariante per questo è ancora da scrivere
			until
				(current_element = Void) or else (current_element.value = a_value)
			loop
				pre_current := current_element
				current_element := current_element.next
			end
			if current_element /= Void then
				-- l'elemento `current_element' contiene `a_value'
				from
--				invariant
--              	-- invariante per questo è ancora da scrivere
				until
					current_element = Void
				loop
					if current_element.value = a_value then
						if current_element = active_element then
							remove_active
						else
							count := count - 1
						end
						if current_element = first_element then
							first_element := current_element.next
						end
						if current_element = last_element then
							last_element := pre_current
						end
						if pre_current /= Void then
							pre_current.link_to(current_element.next)
						end
					else
						pre_current := current_element
					end
				current_element := current_element.next
				end
			end
		ensure
			rimosso_elemento_se_esiste: old has(a_value) implies count <= old count - 1
		end

	remove_all (a_value: INTEGER)
			-- Rimuove tutti gli elementi della lista che contengono `a_value', se esistono
			-- Aggiorna `active_element', se necessario, al suo successore, se esiste, altrimenti al suo predecessore
		require
			lista_non_vuota: count > 0
		local
			current_element, pre_current: like first_element
		do
			from
				current_element := first_element
				pre_current := Void
--			invariant
--              -- invariante per questo è ancora da scrivere
			until
				current_element = Void
			loop
				if current_element.value = a_value then
					if current_element = active_element then
						remove_active
					else -- la lista ha almeno due elementi
						if current_element = first_element then
							-- `current_element' e' il primo elemento della lista che ha almeno due elementi
							first_element := first_element.next
						elseif current_element = last_element then
							-- `current_element' e' l'ultimo elemento della lista che ha almeno due elementi
							last_element := pre_current
							last_element.link_to (Void)
						else
							-- `current_element' e' elemento intermedio della lista che ha almeno tre elementi
							pre_current.link_to(current_element.next)
						end
						count := count - 1
					end
				end
				pre_current := current_element
				current_element := current_element.next
			end
		ensure
			rimosso_elemento_se_esiste: old has(a_value) implies count <= old count - 1
		end

	insert_after (a_value, target: INTEGER)
			-- inserisce `a_value' subito dopo la prima occorrenza di `target' se presente
			-- altrimenti inserisce `a_value' alla fine
		local
			current_element, new_element: like first_element
		do
			create new_element.make (a_value)
			from
				current_element := first_element
			until
				current_element = Void or else current_element.value = target
			loop
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
					last_element := first_element
					active_element := first_element
				else
					new_element.link_after (last_element)
					last_element := new_element
				end
			end
			count := count + 1
		ensure
			uno_in_piu: count = old count + 1
			accodato_se_non_presente: not (old has (target)) implies last_element.value = a_value
			collegato_se_presente: old has (target) implies get_element (target).next.value = a_value
		end

	insert_before (a_value, target: INTEGER)
			-- inserisce `a_value' subito prima della prima occorrenza di `target' se esiste
			-- altrimenti inserisce `a_value' all'inizio
		local
			previous_element, new_element: like first_element
		do
			create new_element.make (a_value)
			if count = 0 then
				first_element := new_element
				last_element := first_element
				active_element := first_element
			else
				if (target = first_element.value) then
					new_element.link_to (first_element)
					first_element := new_element
				else -- list contains at least one element and the first element is not the target
					from
						previous_element := first_element
					until
						(previous_element.next = Void) or else (previous_element.next.value = target)
					loop
						previous_element := previous_element.next
					end
					if previous_element.next /= Void then
						new_element.link_after (previous_element)
					else -- list does not contain `target'
						new_element.link_to (first_element)
						first_element := new_element
					end
				end
			end
			count := count + 1
		ensure
			uno_in_piu: count = old count + 1
			in_testa_se_non_presente: not (old has (target)) implies first_element.value = a_value
			-- questo invariante sotto si puo' usare solo se a_value e' unico nella lista
			-- se invece posso aggiungere a_value piu' volte nella lista allora non e' piu' vero
			-- collegato_se_presente: old has (target) implies get_element (a_value).next.value = target
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

	insert_multiple_after (a_value, target: INTEGER)
			-- inserisce `a_value' subito dopo ogni `target', se ne esistono
			-- altrimenti inserisce `new' alla fine
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
						create new_element.make (a_value)
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
				create new_element.make (a_value)
				if count = 0 then
					first_element := new_element
					last_element := new_element
					active_element := first_element
				else
					new_element.link_after (last_element)
					last_element := new_element
				end
				count := count + 1
			end
		ensure
			di_piu: count > old count
			appeso_se_non_presente: not (old has (target)) implies last_element.value = a_value
			collegato_se_presente: old has (target) implies get_element (target).next.value = a_value
		end

	insert_multiple_before (a_value, target: INTEGER)
			-- inserisce `a_value' subito prima di ogni occorrenza di `target' se esiste
			-- altrimenti inserisce `a_value' all'inizio
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
						create new_element.make (a_value)
						if current_element = first_element then
							new_element.link_to (first_element)
							first_element := new_element
						else
							new_element.link_to (current_element)
							previous_element.link_to (new_element)
						end
						count := count + 1
					end
					previous_element := current_element
					current_element := current_element.next
				end
			else -- la lista non contiene `target'
				create new_element.make (a_value)
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
			in_testa_se_non_presente: not (old has (target)) implies first_element.value = a_value
			collegato_al_primo_se_non_presente: not (old has (target)) implies first_element.next = old first_element
			collegato_al_primo_se_presente: old has (target) implies get_element (a_value).next.value = target
				-- verificare il collegamento con le successive occorrenze di target richiede get_all_elements
		end

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

	wipeout
			-- remove all elements
		do
			first_element := Void
			last_element := Void
			active_element := Void
			count := 0
		end

feature -- query fondamentali

	has (a_value: INTEGER): BOOLEAN
			-- la lista contiene `a_value'?
		local
			current_element, previous_element: like first_element
		do
			from
				current_element := first_element
				previous_element := Void
			invariant
				not Result implies (previous_element /= Void implies previous_element.value /= a_value)
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

		--	get_element (a_value: INTEGER): INT_LINKABLE
		--			-- Ritorna il primo elemento contenente `a_value', se esiste
		--			-- Questa versione ha un invariante più semplice ma testa se trova l'elemento ad ogni iterazione
		--		local
		--			current_element, temp: like first_element
		--		do
		--			from
		--				current_element := first_element
		--				temp := Void
		--			invariant
		--				Result = Void implies (temp /= Void implies temp.value /= a_value)
		--			until
		--				(current_element = Void) or (Result /= Void)
		--			loop
		--				if current_element.value = a_value then
		--					Result := current_element
		--				end
		--				temp := current_element
		--				current_element := temp.next
		--			end
		--		ensure
		--			(Result /= Void) implies Result.value = a_value
		--		end

	get_element (a_value: INTEGER): INT_LINKABLE
			-- ritorna il primo elemento contenente `a_value', se esiste
		local
			current_element, previous_element: like first_element
		do
			from
				current_element := first_element
				previous_element := Void
			invariant
				current_element /= Void implies (current_element.value /= a_value implies (previous_element /= Void implies previous_element.value /= a_value))
			until
				(current_element = Void) or (current_element.value = a_value)
			loop
				previous_element := current_element
				current_element := current_element.next
			end
			if (current_element /= Void and then current_element.value = a_value) then
				Result := current_element
			end
		ensure
			(Result /= Void) implies Result.value = a_value
		end

		--	value_follows (a_value, target: INTEGER): BOOLEAN
		--			-- La lista contiene `a_value' dopo la prima occorrenza di `target'?
		--			-- Questa versione ha un invariante più semplice ma testa se trova l'elemento ad ogni iterazione
		--		local
		--			current_element, temp: like first_element
		--		do
		--			from
		--				current_element := get_element(target)
		--				temp := Void
		--			invariant
		--				not Result implies (temp /= Void implies temp.value /= a_value)
		--			until
		--				(current_element = Void) or Result
		--			loop
		--				if current_element.value = a_value then
		--					Result := True
		--				end
		--				temp := current_element
		--				current_element := current_element.next
		--			end
		--		end

	value_follows (a_value, target: INTEGER): BOOLEAN
			-- la lista contiene `a_value' dopo la prima occorrenza di `target'?
		local
			current_element, temp: like first_element
		do
			from
				current_element := get_element (target)
				temp := Void
			invariant
				current_element /= Void implies (current_element.value /= a_value implies (temp /= Void implies temp.value /= a_value))
			until
				(current_element = Void) or (current_element.value = a_value)
			loop
				temp := current_element
				current_element := current_element.next
			end
			if (current_element /= Void and then current_element.value = a_value) then
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

	sum_of_positive: INTEGER
			-- valore della somma degli elementi maggiori di zero
		local
			temp: like first_element
		do
			from
				temp := first_element
			until
				temp = Void
			loop
				if temp.value > 0 then
					Result := Result + temp.value
				end
				temp := temp.next
			end
		ensure
			Result >= 0
		end

	stampa
			-- stampa tutta la lista
		local
			temp: like first_element
		do
--			print ("%N La lista contiene: ")
			from
				temp := first_element
			until
				temp = Void
			loop
				print (temp.value)
				print (", ")
				temp := temp.next
			end
			print ("%N che sono in totale ")
			print (count)
			print (" elementi.")
--			print ("%N")
		end

invariant
	contatore_non_negativo: count >= 0
	lista_termina_Void: last_element /= Void implies last_element.next = Void
	consistenza_lista_vuota: count = 0 implies (first_element = last_element) and (first_element = Void) and (first_element = active_element)
	consistenza_lista_mono_elemento: count = 1 implies (first_element = last_element) and (first_element /= Void) and (first_element = active_element)
	consistenza_lista_pluri_elemento: count > 1 implies (first_element /= last_element) and (first_element /= Void) and (last_element /= Void) and (active_element /= Void) and then (first_element.next /= Void)

end
