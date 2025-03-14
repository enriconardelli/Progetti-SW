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
			-- L'elemento corrente della lista, cio� il cursore.
			-- Pu� essere Void anche se la lista non � vuota.
			-- Viene modificato solo dalle feature di spostamento del cursore
			-- o dalle feature di cancellazione che rimuovono l'elemento corrente.

	count: INTEGER
			-- Il numero di elementi della lista.

	index: INTEGER
			-- L'intero che corrisponde alla posizione di active_element
			-- E' 0 se active_element � Void

feature -- Spostamento del cursore

	start
			-- Sposta il cursore al primo elemento.
		do
			active_element := first_element
			if count = 0 then
					-- se la lista � vuota first_element � void quindi active va su void quindi index deve essere 0
				index := 0
			else
					-- se la lista non � vuota index deve valere 1
				index := 1
			end
		ensure
			active_element = first_element
			count = 0 implies index = 0
			count /= 0 implies index = 1
		end

	last
			-- Sposta il cursore all'ultimo elemento.
		do
			active_element := last_element
			index := count
				-- se la lista � vuota count � 0 quindi va bene come valore di index
		ensure
			active_element = last_element
			index = count
		end

	forth
			-- Sposta l'elemento corrente, se esiste, all'elemento successivo.
		require
			active_element /= Void
		do
			if attached active_element as ae then
				active_element := ae.next
			end
			if attached active_element as ae then
					-- se active_element � ancora attached allora posso aumentare l'indice
				index := index + 1
			else
					-- se active_element � finito a void metto index 0
				index := 0
			end
		ensure
			attached old active_element as ae implies active_element = ae.next
			attached active_element as ae implies index = old index + 1
		end

	go_i_th (i: INTEGER)
			-- sposta l'elemento corrente alla posizione iesima
		require
			i >= 0 --  se metto i=0 allora assegna ad active_element Void
			i <= count
		local
			k: INTEGER
		do
			if i = 0 then
				active_element := Void
			else
				from
					k := 1
					active_element := first_element
				until
					k = i
				loop
					forth
					k := k + 1
				end
			end
			index := i
		ensure
			i > 0 implies attached active_element
			i = 0 implies active_element = Void
		end

feature -- Ricerca

	has (a_value: INTEGER): BOOLEAN
			-- La lista contiene `a_value'?
		local
			current_element, previous_element: like first_element
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

			-- Qui si usa currently active per salvare la posizione di active_element, una volta introdotti index e go_i_th forse si pu� sostituire con quelli?
		local
			currently_active, previous_element: like first_element
			k: INTEGER
			temp_index: INTEGER
		do
			currently_active := active_element
			temp_index := index
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
			index := temp_index
		ensure
			old active_element = active_element
			old index = index
				-- avendo manipolato active element devo assicurarmi che n� lui n� index siano cambiati
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

feature -- Stato

	value_follows (a_value, target: INTEGER): BOOLEAN
			-- la lista contiene `a_value' in qualunque posizione dopo la prima occorrenza di `target'?
			-- Claudia Agulini, 2020/03/08
		require
			contiene_il_target: has (target)
		local
			previous_element, current_element: like first_element
		do
			from
				current_element := get_element (target)
				previous_element := Void
			invariant
				attached current_element as ce implies (ce.value /= a_value implies (attached previous_element as pe implies pe.value /= a_value))
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
				--			a_value_segue_target: Result implies index_earliest_of (a_value) > index_earliest_of (target)
				-- TODO: va usata la condizione di sotto ma bisogno implementare index_latest_of()
				--			a_value_segue_target: Result implies index_latest_of (a_value) > index_earliest_of (target)

		end

	value_after (a_value, target: INTEGER): BOOLEAN
			-- la lista contiene `a_value' subito dopo la prima occorrenza di `target'?
		require
			contiene_il_target: has (target)
		local
			current_element: like first_element
		do
			current_element := get_element (target)
			if attached current_element as ce then
				if attached ce.next as cen then
					if cen.value = a_value then
						Result := true
					end
				end
			end
		ensure
			Result implies attached get_element (target) as t and then (attached t.next as tn implies tn.value = a_value)
		end

	value_precedes (a_value, target: INTEGER): BOOLEAN
			-- la lista contiene `a_value' prima della prima occorrenza di `target'?
			-- Maria Ludovica Sarandrea, 2021/04/03
		require
			contiene_il_target: has (target)
			sono_diversi: a_value /= target
		local
			previous_element, current_element: like first_element
		do
			from
				current_element := first_element
				previous_element := Void
			invariant
				attached current_element as ce implies ((ce.value /= a_value and ce.value /= target) implies (attached previous_element as pe implies (pe.value /= a_value and pe.value /= target)))
			until
				attached current_element as ce implies (ce.value = a_value or ce.value = target)
			loop
				previous_element := current_element
				current_element := current_element.next
			end
			if attached current_element as ce and then ce.value = a_value then
				Result := True
			end
		ensure
			a_value_precede_target: Result implies index_earliest_of (a_value) < index_earliest_of (target)
		end

	value_precedes_CON_start_forth (a_value, target: INTEGER): BOOLEAN
			-- la lista contiene `a_value' prima della prima occorrenza di `target'?
			-- versione che riutilizza `start', `forth' e `active_element'
			-- Enrico Nardelli 2022/06/29
		require
			contiene_il_target: has (target)
			sono_diversi: a_value /= target
		local
			previous_element, currently_active: like first_element
			temp_index: INTEGER
		do
			currently_active := active_element
			temp_index := index
			from
				start
				previous_element := Void
			invariant
				attached active_element as ae implies ((ae.value /= a_value and ae.value /= target) implies (attached previous_element as pe implies (pe.value /= a_value and pe.value /= target)))
			until
				attached active_element as ae implies (ae.value = a_value or ae.value = target)
			loop
				previous_element := active_element
				forth
			end
			if attached active_element as ae and then ae.value = a_value then
				Result := True
			end
			active_element := currently_active
			index := temp_index
		ensure
			a_value_precede_target: Result implies index_earliest_of (a_value) < index_earliest_of (target)
			old active_element = active_element
			old index = index
				-- avendo manipolato active element devo assicurarmi che n� lui n� index siano cambiati
		end

	value_precedes_SENZA_has (a_value, target: INTEGER): BOOLEAN
			-- la lista contiene `a_value' prima della prima occorrenza di `target'?
			-- non si assume l'esistenza di `target' nella lista
			-- Enrico Nardelli 2022/07/03
		require
			sono_diversi: a_value /= target
		local
			previous_element, currently_active: like first_element
			target_found: BOOLEAN
			temp_index: INTEGER
		do
			currently_active := active_element
			temp_index := index
				-- ricerca di `a_value'
			from
				start
				previous_element := Void
			invariant
				attached previous_element as pe implies pe.value /= a_value
			until
				active_element = Void or else (attached active_element as ae implies ae.value = a_value)
			loop
				if ae.value = target then
					target_found := true
				end
				previous_element := active_element
				forth
			end
			if attached active_element and then (attached active_element as ae implies ae.value = a_value) then
					-- se viene trovato `a_value' si cerca `target' se non era gi� stato trovato
				if not target_found then
					from
						previous_element := Void
					invariant
						attached previous_element as pe implies pe.value /= target
					until
						active_element = Void or else (attached active_element as ae implies ae.value = target)
					loop
						previous_element := active_element
						forth
					end
					if attached active_element and then (attached active_element as ae implies ae.value = target) then
						Result := true
					end
				end
			end
			active_element := currently_active
			index := temp_index
		ensure
			correttezza_se_target_non_esiste: not has (target) implies not Result -- premessa equivalente index_of(target) = 0
			correttezza_se_value_non_esiste: index_earliest_of (a_value) = 0 implies not Result -- premessa equivalente not has(a_value)
			trovato_a_value_prima_di_trovare_target: Result implies (index_earliest_of (a_value) /= 0 and index_earliest_of (a_value) < index_earliest_of (target))
			old active_element = active_element
			old index = index
				-- avendo manipolato active element devo assicurarmi che n� lui n� index siano cambiati
		end

	value_before (a_value, target: INTEGER): BOOLEAN
			-- la lista contiene `a_value' subito prima della prima occorrenza di `target'?
			-- Gianluca Pastorini 12/04/23
		require
			contiene_il_target: has (target)
			sono_diversi: a_value /= target
		local
			current_element, previous_element: like first_element
		do
			from
				current_element := first_element
				previous_element := Void
			until
				current_element /= Void and then current_element.value = target
			loop
				previous_element := current_element
				if attached current_element as ce then
					current_element := ce.next
				end
			end
			if previous_element /= Void and then previous_element.value = a_value then
				Result := True
			end
		end

	index_earliest_of (a_value: INTEGER): INTEGER
			-- ritorna la posizione del primo elemento che contiene `a_value' oppure 0 se non esiste
			-- Enrico Nardelli 2021/07/19 - 2022/09/14
		local
			previous_element, current_element: like first_element
		do
			from
				current_element := first_element
				previous_element := Void
			invariant
				attached previous_element as pe implies pe.value /= a_value
			until
				current_element = Void or else (attached current_element as ce implies ce.value = a_value)
			loop
				Result := Result + 1
				previous_element := current_element
				current_element := current_element.next
			variant
				count - Result
			end
			if current_element = Void then
				Result := 0
			else
				Result := Result + 1
			end
		ensure
			corretto_se_esiste: has (a_value) = (0 < Result and Result <= count)
			zero_se_non_esiste: not has (a_value) = (Result = 0)
		end

	index_latest_of (a_value: INTEGER): INTEGER
			-- ritorna la posizione dell'ultimo elemento che contiene `a_value' oppure 0 se non esiste
		do
			if has (a_value) then
				invert
				Result := count - index_earliest_of (a_value) + 1
				invert
			end
		ensure
			invert_corretti: first_element = old first_element and last_element = old last_element and active_element = old active_element
			corretto_se_esiste: has (a_value) = (0 < Result and Result <= count)
			zero_se_non_esiste: not has (a_value) = (Result = 0)
		end

	index_latest_of_SENZA_INVERT (a_value: INTEGER): INTEGER
			-- ritorna la posizione dell'ultimo elemento che contiene `a_value' oppure 0 se non esiste
		local
			current_element: like first_element
			current_position: INTEGER
		do
			from
				current_element := first_element
				current_position := 1
			invariant
				current_position >= 1
				current_position <= count + 1
			until
				current_element = Void
			loop
				if current_element.value = a_value then
					Result := current_position
				end
				current_element := current_element.next
				current_position := current_position + 1
			variant
				count - current_position + 1
			end
		ensure
			corretto_se_esiste: has (a_value) = (0 < Result and Result <= count)
			zero_se_non_esiste: not has (a_value) = (Result = 0)
		end

	value_at (target_position: INTEGER): INTEGER
			-- ritorna il valore dell'elemento in posizione `position' posizione
		require
			target_position >= 1
			target_position <= count
		local
			current_index: INTEGER
		do
			current_index := index
			go_i_th (target_position)
			if attached active_element as ae then
				Result := ae.value
			end
			go_i_th (current_index)
		end

	value_at_SENZA_GO_I_TH (target_position: INTEGER): INTEGER
			-- ritorna il valore dell'elemento in posizione `position'
		require
			target_position >= 1
			target_position <= count
		local
			current_element: like first_element
			current_position: INTEGER
		do
			from
				current_element := first_element
				current_position := 1
			invariant
				current_position >= 1
				current_position <= count
			until
				current_position = target_position
			loop
				if current_element /= Void then
					current_element := current_element.next
				end
				current_position := current_position + 1
			variant
				target_position - current_position
			end
			if current_element /= Void then
				Result := current_element.value
			end
		end

	value_at_CON_ACTIVE (target_position: INTEGER): INTEGER
			-- ritorna il valore dell'elemento in posizione `position'
		require
			target_position >= 1
			target_position <= count
		local
			current_position: INTEGER
		do
			from
				start
				current_position := 1
			invariant
				current_position >= 1
				current_position <= count
			until
				current_position = target_position
			loop
				forth
				current_position := current_position + 1
			variant
				target_position - current_position
			end
			if attached active_element as ae then
				Result := ae.value
			end
		end

feature {STATO_TESTS} -- Private
	-- non viene messa a disposizione perche' gestisce gli indirizzi assoluti degli elementi
	-- puo' invece essere invocata dalle altre feature in modo unqualified
	-- viene ovviamente esportata verso la classe di test

	is_before (an_element, a_target: detachable INT_LINKABLE): BOOLEAN
			-- funzione che ritorna vero se an_element � prima di a_target
			-- se an_element = a_target ritorna falso
			-- se an_element = Void ritorna falso
		require
			target_exists: a_target /= Void
		local
			current_element: like first_element
		do
			from
				current_element := first_element
			until
				Result or current_element = a_target
			loop
				if current_element = an_element then
					Result := True
				end
				if attached current_element as ce then
					current_element := ce.next
				end
			end
		ensure
			an_element = a_target implies Result = False
		end

	position_of (target: detachable INT_LINKABLE): INTEGER
			-- ritorna la posizione di `target', 0 se Void o non appartiene alla lista
		local
			saved_index: INTEGER
		do
			saved_index := index
			from
				start
			until
				active_element = Void or active_element = target
			loop
				forth
			end
			if active_element /= Void then
				Result := index
			end
			go_i_th (saved_index)
		ensure
			primo: target = first_element and first_element /= Void implies Result = 1
			ultimo: target = last_element implies Result = count
			attivo: target = active_element implies Result = index
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
			if index /= 0 then
					-- inserisco all'inizio quindi se active_element � assegnato scala di uno
				index := index + 1
			end
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
			previous_element, current_element, new_element: like first_element
		do
			create new_element.set_value (a_value)
			from
				previous_element := Void
				current_element := first_element
			invariant
				previous_element /= Void implies previous_element.value /= target
			until
				current_element = Void or else current_element.value = target
			loop
				previous_element := current_element
				current_element := current_element.next
			end
			if current_element /= Void then
				new_element.link_after (current_element)
				if last_element = current_element then
					last_element := new_element
				end
				if active_element /= Void and then is_before (new_element, active_element) then
					index := index + 1
				end
			else -- la lista non contiene `target'
				if count = 0 then
					first_element := new_element
				else
					if attached last_element as le then
						new_element.link_after (le)
					end
				end
				last_element := new_element
			end
			count := count + 1
		ensure
			uno_in_piu: count = old count + 1
			valore_aggiunto: has (a_value)
			conteggio_incrementato_di_uno: count_of (a_value) = old count_of (a_value) + 1
			accodato_se_non_presente: (not old has (target) and attached last_element as le) implies le.value = a_value
				--	il seguente invariante funziona completamente solo quando `target'  � unico nella lista
			collegato_se_presente: old has (target) implies (attached get_element (target) as ge implies (attached ge.next as gen and then gen.value = a_value))
		end

	insert_after_CON_get_element_append (a_value, target: INTEGER)
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
				if active_element /= Void and then is_before (new_element, active_element) then
						-- se ho inserito prima di active_element
					index := index + 1
				end
				if current_element = last_element then
					last_element := new_element
				end
				count := count + 1
			else -- la lista non contiene `target'
				append (a_value)
			end
		ensure
			uno_in_piu: count = old count + 1
			valore_aggiunto: has (a_value)
			conteggio_incrementato_di_uno: count_of (a_value) = old count_of (a_value) + 1
			accodato_se_non_presente: (not old has (target) and attached last_element as le) implies le.value = a_value
				--	il seguente invariante funziona completamente solo quando `target'  � unico nella lista
			collegato_se_presente: old has (target) implies (attached get_element (target) as ge implies (attached ge.next as gen and then gen.value = a_value))
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
					if index /= 0 then
						index := index + 1
					end
				else -- la lista contiene almeno un elemento e il primo elemento non � `target'
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
							if index /= 0 then
								index := index + 1
							end
						else
							new_element.link_after (ce)
							if active_element /= Void and then is_before (new_element, active_element) then
									-- se ho inserito prima di active_element
								index := index + 1
							end
						end
					end
				end
			end
			count := count + 1
		ensure
			uno_in_piu: count = old count + 1
			valore_aggiunto: has (a_value)
			conteggio_incrementato_di_uno: count_of (a_value) = old count_of (a_value) + 1
			in_testa_se_non_presente: (not old has (target) and attached first_element as fe) implies fe.value = a_value
				--	il seguente invariante funziona completamente solo quando `target'  � unico nella lista
			collegato_se_presente: old has (target) implies (attached get_element (a_value) as ge implies (attached ge.next as gen and then gen.value = target))
		end

	insert_before_CON_has_prepend (a_value, target: INTEGER)
			-- Aggiunge `a_value' subito prima della prima occorrenza di `target', se esiste,
			-- altrimenti lo aggiunge all'inizio della lista riusando `has' e `prepend'.
		local
			previous_element, new_element: like first_element
		do
			if not has (target) then
				prepend (a_value)
				if index /= 0 then
					index := index + 1
				end
					-- se lo metto all'inizio se active_element � attaccato allora avanzo index
			else
				if attached first_element as fe and then fe.value = target then
					prepend (a_value)
					if index /= 0 then
						index := index + 1
					end
				else -- la lista ha almeno 2 elementi e il primo non � il target
					create new_element.set_value (a_value)
					from
						previous_element := first_element
					until
						(attached previous_element as pe and then attached pe.next as pen) implies pen.value = target
					loop
						previous_element := previous_element.next
					end
					if attached previous_element as pe then
						new_element.link_after (pe)
						if active_element /= Void and then is_before (new_element, active_element) then
								-- se ho inserito prima di active_element
							index := index + 1
						end
					end
					count := count + 1
				end
			end
		ensure
			uno_in_piu: count = old count + 1
			valore_aggiunto: has (a_value)
			conteggio_incrementato_di_uno: count_of (a_value) = old count_of (a_value) + 1
			in_testa_se_non_presente: (not old has (target) and attached first_element as fe) implies fe.value = a_value
				--	il seguente invariante funziona completamente solo quando `target'  � unico nella lista
			collegato_se_presente: old has (target) implies (attached get_element (a_value) as ge implies (attached ge.next as gen and then gen.value = target))
		end

	insert_before_CON_2_CURSORI (a_value, target: INTEGER)
			-- Aggiunge `a_value' subito prima della prima occorrenza di `target', se esiste,
			-- altrimenti lo aggiunge all'inizio della lista.
			-- Anche questa potrebbe essere implementata riutilizzando prepend.
		local
			previous_element, current_element, new_element: like first_element
		do
			create new_element.set_value (a_value)
			if count = 0 then
				first_element := new_element
				last_element := first_element
			else -- la lista contiene almeno un elemento
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
					if index /= 0 then
						index := index + 1
					end
				else -- `current_element' contiene `target'
					if previous_element = Void then
						new_element.link_to (first_element)
						first_element := new_element
						if index /= 0 then
							index := index + 1
						end
					else
						previous_element.link_to (new_element)
						new_element.link_to (current_element)
						if active_element /= Void and then is_before (new_element, active_element) then
								-- se ho inserito prima di active_element
							index := index + 1
						end
					end
				end
			end
			count := count + 1
		ensure
			uno_in_piu: count = old count + 1
			valore_aggiunto: has (a_value)
			conteggio_incrementato_di_uno: count_of (a_value) = old count_of (a_value) + 1
			in_testa_se_non_presente: (not old has (target) and attached first_element as fe) implies fe.value = a_value
				--	il seguente invariante funziona completamente solo quando `target'  � unico nella lista
			collegato_se_presente: old has (target) implies (attached get_element (a_value) as ge implies (attached ge.next as gen and then gen.value = target))
		end

feature -- Insertion multiple targeted

	insert_multiple_after (a_value, target: INTEGER)
			-- Aggiunge `a_value' subito dopo ogni `target', se ne esistono,
			-- altrimenti aggiunge `a_value' alla fine della lista.
			-- Federico Fiorini 2020/03/08
			-- riscritta EN 2021/08/18
		local
			current_element, new_element: like first_element
			inserito: BOOLEAN
		do
			from
				current_element := first_element
			until
				current_element = Void
			loop
				if current_element.value = target then
					create new_element.set_value (a_value)
					new_element.link_after (current_element)
					if active_element /= Void and then is_before (new_element, active_element) then
							-- se ho inserito prima di active_element
						index := index + 1
					end
					inserito := true
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
			if not inserito then -- la lista non contiene `target'
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
			valore_aggiunto: has (a_value)
			conteggio_incrementato: count_of (a_value) > old count_of (a_value)
			accodato_se_non_presente: (not old has (target) and attached last_element as le) implies le.value = a_value
				--	il seguente invariante funziona completamente solo quando `target'  � unico nella lista
			collegato_se_presente: (old has (target) and attached get_element (target) as ge) implies (attached ge.next as gen and then gen.value = a_value)
				--	il seguente invariante � una formulazione alternativa del precedente
			collegato_se_presente_ALT: (old has (target) and attached get_element (target) as ge and then attached ge.next as gen) implies gen.value = a_value
		end

	insert_multiple_after_CON_has_append (a_value, target: INTEGER)
			-- Aggiunge `a_value' subito dopo ogni `target', se ne esistono,
			-- altrimenti aggiunge `a_value' alla fine della lista.
			-- Implementazione che riusa le feature `has' e `append'
			-- EN 2021/08/18
		local
			new_element, current_element: like first_element
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
						if active_element /= Void and then is_before (new_element, active_element) then
								-- se ho inserito prima di active_element
							index := index + 1
						end
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
				append (a_value)
			end
		ensure
			di_piu: count > old count
			valore_aggiunto: has (a_value)
			conteggio_incrementato: count_of (a_value) > old count_of (a_value)
			accodato_se_non_presente: (not old has (target) and attached last_element as le) implies le.value = a_value
				--	il seguente invariante funziona completamente solo quando `target'  � unico nella lista
			collegato_se_presente: (old has (target) and attached get_element (target) as ge) implies (attached ge.next as gen and then gen.value = a_value)
				--	il seguente invariante � una formulazione alternativa del precedente
			collegato_se_presente_ALT: (old has (target) and attached get_element (target) as ge and then attached ge.next as gen) implies gen.value = a_value
		end

	insert_multiple_before (a_value, target: INTEGER)
			-- inserisce `a_value' subito prima di ogni occorrenza di `target' se esiste
			-- altrimenti inserisce `a_value' all'inizio usando `prepend'.
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
							if index /= 0 then
								index := index + 1
							end
						else
							new_element.link_to (current_element)
							if (attached previous_element as pe) then
								pe.link_to (new_element)
								if active_element /= Void and then is_before (new_element, active_element) then
										-- se ho inserito prima di active_element
									index := index + 1
								end
							end
						end
						count := count + 1
					end
					previous_element := current_element
					current_element := current_element.next
				end
			else -- la lista non contiene `target'
				prepend (a_value)
				if index /= 0 then
					index := index + 1
				end
			end
		ensure
			di_piu: count > old count
			uno_in_piu_se_non_presente: not (old has (target)) implies count = old count + 1
			in_testa_se_non_presente: (not (old has (target)) and attached first_element as fe) implies fe.value = a_value
			collegato_al_primo_se_non_presente: (not (old has (target)) and (attached first_element as fe)) implies fe.next = old first_element
			collegato_al_primo_se_presente: (old has (target) and (attached get_element (a_value) as el and then attached el.next as eln)) implies eln.value = target
				-- verificare il collegamento con le successive occorrenze di target richiede get_all_elements
		end

	insert_multiple_before_SENZA_prepend (a_value, target: INTEGER)
			-- inserisce `a_value' subito prima di ogni occorrenza di `target' se esiste
			-- altrimenti inserisce `a_value' all'inizio senza usare `prepend'
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
							if index /= 0 then
								index := index + 1
							end
						else
							new_element.link_to (current_element)
							if (attached previous_element as pe) then
								pe.link_to (new_element)
								if active_element /= Void and then is_before (new_element, active_element) then
										-- se ho inserito prima di active_element
									index := index + 1
								end
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
					if index /= 0 then
						index := index + 1
					end
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
				index := 0
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
					index := index - 1
						-- se active_element era l'ultimo elemento gli assegno il precendente, quindi l'indice scala di uno, negli altri casi rimane invariato
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
					index := 0
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
								first_element := fe.next
								if index /= 0 then
										-- visto che active_element non � il primo allora devo scalare l'indice di uno
									index := index - 1
								end
							end
						elseif current_element = last_element then
							last_element := pre_current
							if attached last_element as le then
								le.link_to (Void)
							end
						else -- `current_element' � un elemento intermedio della lista
							if attached pre_current as pe then
								pe.link_to (current_element.next)
								if active_element /= Void and then is_before (current_element.next, active_element) then
										-- se ho tolto prima di active_element
									index := index - 1
								end
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
					index := 0
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
						-- `a_value' non � presente oppure � il primo elemento
					if attached first_element as fe and then fe.value = a_value then
							-- c'� un sola occorrenza di a_value come primo elemento
						if active_element = first_element then
							active_element := fe.next
						else
							if index /= 0 then
								index := index - 1
									-- se active_element non � il primo elemento ed non � Void allora index scala di uno
							end
						end
						first_element := fe.next
						count := count - 1
					end
				else -- `a_value' � presente e non � il primo elemento
					if attached pre_latest as pl and then attached pl.next as pln then
						pl.link_to (pln.next)
						if active_element /= Void and then is_before (pre_latest.next, active_element) then
								-- se ho tolto prima di active_element
							index := index - 1
						end
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
					if active_element /= Void and then is_before (current_element, active_element) then
							-- se ho tolto prima di active_element
						index := index - 1
					end
					if active_element = current_element then
						if current_element = last_element then
							active_element := pre_a_element
							index := index - 1
								-- se sto togliendo active_element ed � l'ultimo elemento allora devo scalare l'indice di uno
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
							index := index - 1
						end
						if ve = last_element then
							last_element := pe
						end
						if active_element /= Void and then is_before (ve, active_element) then
								-- se ho tolto prima di active_element
							index := index - 1
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
					if index > 1 then
							-- se active_element � assegnato e non � il primo l'index deve scendere di uno
						index := index - 1
					end
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
							if active_element /= Void and then is_before (ce, active_element) then
									-- se ho tolto prima di active_element
								index := index - 1
							end
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
						--cio� se nella lista � presente prima una qualche istanza di a_value, e poi target
						--quindi una qualche istanza di a_value deve necessariamente esistere
						--se pre_value � ancora void, significa che l' unica ricorrenza di a_value deve essere
						--il primo elemento della lista
					if attached first_element as fe then
						if active_element = first_element then
							active_element := fe.next
						end
						if index > 1 then
								-- se active_element � assegnato e non � il primo allora index deve scalare di uno
							index := index - 1
						end
						first_element := fe.next
					end
				else
					if attached pre_value as pv and then attached pre_value.next as pvn then
						if active_element /= Void and then is_before (pvn, active_element) then
								-- se ho tolto prima di active_element
							index := index - 1
						end
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
					index := 0
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
									if index > 1 then
										index := index - 1
									end
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
									if active_element /= Void and then is_before (current_element, active_element) then
											-- se ho tolto prima di active_element
										index := index - 1
									end
									pc.link_to (pcn.next)
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
			rimosso_elemento_se_esiste: old has (a_value) implies count < old count
		end

	wipeout
			-- remove all elements
		do
			first_element := Void
			last_element := Void
			active_element := Void
			count := 0
			index := 0
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
								index := index - 1
							else
								if active_element /= Void and then is_before (current_element, active_element) then
										-- se ho tolto prima di active_element
									index := index - 1
								end
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
						if active_element /= Void and then is_before (current_element, active_element) then
								-- se ho tolto prima di active_element
							index := index - 1
						end
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

feature -- Manipulation

		--feature -- Other

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
			if index /= 0 then
					-- se l'indice non � 0 devo invertire anche lui
				index := (count - index + 1).abs
			end
		ensure
			count = old count
		end

	head_list (max: INTEGER): like Current
			-- return a list with the first `max' items
			-- nota che cambiamenti alla lista non modificano la nuova lista creata e viceversa
		require
			max <= count
		local
				--		k: INTEGER
			i: INTEGER
		do
			create Result
			i := index
			from
				start
			until
				index > max or index = 0
			loop
				if attached active_element as ae then
					Result.append (ae.value)
				end
				forth
			end
			go_i_th (i)
		ensure
			Result.count = max
				-- the list contains 'max' elements
		end

	tail_list (max: INTEGER): like Current
			-- return a list with the last `max' items
			-- nota che cambiamenti alla lista non modificano la nuova lista creata e viceversa
		require
			max <= count
		local
			i: INTEGER
		do
			create Result
			i := index
			Result := deep_twin
			Result.invert
			Result := Result.head_list (max)
			Result.invert
		ensure
			Result.count = max
				-- the list contains 'max' elements
		end

feature -- Computation

	count_of (target: INTEGER): INTEGER
			-- conta quante occorrenze di `target' esistono
		local
			current_element: like first_element
		do
			from
				current_element := first_element
			until
				current_element = Void
			loop
				if current_element.value = target then
					Result := Result + 1
				end
				current_element := current_element.next
			end
		ensure
			zero_se_non_presente: not old has (target) implies Result = 0
			maggiore_di_zero_se_presente: old has (target) implies Result > 0
		end

	count_of_before (a_value, target: INTEGER): INTEGER
			-- ci dice quante occorrenze di a_value ci sono prima della prima occorrenza di target
		require
			contiene_il_target: has (target)
		local
			aux_list: like current
		do
			aux_list := head_list (index_earliest_of (target) - 1)
				-- ho creato una lista ausiliaria che contiene tutti i valori fino a target escluso
			Result := aux_list.count_of (a_value)
		end

	count_of_after (a_value, target: INTEGER): INTEGER
			-- ci dice quante occorrenze di a_value ci sono dopo la prima occorrenza di target
		require
			contiene_il_target: has (target)
		local
			aux_list: like current
		do
			aux_list := tail_list (count - index_earliest_of (target))
				-- ho creato una lista ausiliaria che contiene tutti i valori da target escluso in poi
			Result := aux_list.count_of (a_value)
		end

	highest: INTEGER
		require
			count > 0
		local
			k: INTEGER
		do
			k := index
			from
				start
				if attached first_element as fe then
					Result := fe.value
				end
					--bisogna dare un valore a Result all'inizio altrimenti non ho con cosa confrontarlo
			until
				active_element = Void
			loop
				if attached active_element as ae then
					if ae.value > Result then
						Result := ae.value
					end
				end
					--se il valore nuovo � pi� grande del massimo che avevamo aggiorno Result
				forth
			end
			go_i_th (k)
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
			print ("  -- ho stampato in totale ")
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
	active_element = Void implies index = 0
	index = 0 implies active_element = void
	index <= count

end
