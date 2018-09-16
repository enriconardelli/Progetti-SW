note
	description: "Summary description for {MY_LINKED_LIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_LINKED_LIST [G]

feature --accesso

	first_element: detachable MY_LINKABLE [G]
			-- First cell of the list

	last_element: detachable MY_LINKABLE [G]
			-- Last cell of the list

	count: INTEGER
			-- Number of elements in the list

	attached_element (a_value: G): MY_LINKABLE [G]
			-- Elemento sempre attached usato per creazione di nuovi elementi da aggiungere
		do
			create Result.make (a_value)
		ensure
			esiste_result: Result /= Void
		end

feature --comandi fondamentali

	append (a_value: G)
			-- Add `a_value' to end.
		local
			new_element: like first_element
		do
			new_element := attached_element (a_value)
			if first_element = Void then
				first_element := new_element
			else
				check attached last_element as le then
					le.link_to (new_element)
				end
			end
			last_element := new_element
			count := count + 1
		ensure
			attached last_element as le implies le.value = a_value
			count = old count + 1
		end

	prepend (a_value: G)
			-- Aggiunge `a_value' prima del primo elemento.
		local
			new_element: like first_element
		do
			new_element := attached_element (a_value)
			if count /= 0 then
				new_element.link_to (first_element)
			else
				last_element := new_element
			end
			first_element := new_element
			count := count + 1
		ensure
			uno_in_piu: count = old count + 1
			intestato: attached first_element as n implies n.value = a_value
			collegato: attached first_element as n implies n.next = old first_element
		end

	remove (a_value: G)
			-- rimuove la prima occorrenza di a_value
		require
			esiste_bersaglio: has (a_value)
		local
			current_element, temp: like first_element
		do

				--			if count = 0 then
				--				print ("ERRORE la lista non contiene elementi")
				--			end
				--			if not has (a_value) then
				--				print ("ERRORE la lista non contiene il valore da rimuovere")
			check attached first_element as fe then
				if fe.value = a_value then
					if first_element = last_element then
						first_element := VOID
						last_element := VOID
					else
						if attached first_element as fel then
							first_element := fel.next
						end
						count := count - 1
					end
				elseif fe.value /= a_value then
					current_element := first_element
					temp := current_element
					from
						current_element := first_element
					until
						current_element = VOID or (attached temp as t implies t.value = a_value)
					loop
						if current_element /= last_element then
							temp := current_element
							check attached current_element as ce then
								if ce.next /= VOID then
									current_element := ce.next
								end
							end
							if current_element /= last_element then
								check attached current_element as ce then
									if ce.value = a_value then
										check attached ce.next as ce_n then
											if attached temp as te then
												temp.link_to (ce_n)
											end
										end
										count := count - 1
									end
								end
							end
						elseif current_element = last_element then
							if attached current_element as ce then
								if ce.value = a_value then
									check attached temp as te then
										te.link_to (VOID)
									end
									count := count - 1
								end
								current_element:=VOID;
							end
						end
					end
				end
			end
				--		ensure
				--			removed: count = old count - 1
		end

	insert_after (a_value, target: G)
			-- Inserisce `a_value' dopo la prima occorrenza di `target' se presente
			-- Altrimenti inserisce `a_value' alla fine
		local
			current_element, new_element: like first_element
		do
			new_element := attached_element (a_value)
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
				else
					new_element.link_after (last_element)
					last_element := new_element
				end
			end
			count := count + 1
		ensure
			uno_in_piu: count = old count + 1
			accodato_se_non_presente: not (old has (target)) implies (attached last_element as le implies le.value = a_value)
			collegato_se_presente: old has (target) implies (attached get_element (target) as ge implies (attached ge.next as gen implies gen.value = a_value))
		end

	insert_after_using_has_e_get_element (a_value, target: G)
			-- Inserisce `new' dopo la prima occorrenza di `target' se presente altrimenti inserisce `a_value' alla fine
			-- Implementazione alternativa con has e get_element
		local
			current_element, new_element: like first_element
		do
			new_element := attached_element (a_value)
			if has (target) then
				current_element := get_element (target)
				new_element.link_after (current_element)
				if last_element = current_element then
					last_element := new_element
				end
			else
				if count /= 0 then
					new_element.link_after (last_element)
				else
					first_element := new_element
					last_element := new_element
				end
			end
			count := count + 1
		ensure
			uno_in_piu: count = old count + 1
			accodato_se_non_presente: not (old has (target)) implies (attached last_element as le implies le.value = a_value)
			collegato_se_presente: old has (target) implies (attached get_element (target) as ge implies (attached ge.next as gen implies gen.value = a_value))
		end

	insert_before (a_value, target: G)
			-- Inserisce `a_value' prima della prima occorrenza di `target' se esiste
			-- Altrimenti inserisce `a_value' all'inizio
		local
			previous_element, new_element: like first_element
		do
			new_element := attached_element (a_value)
			if count = 0 then
				first_element := new_element
				last_element := first_element
			else
				check attached first_element as fe then
					if (target = fe.value) then
						new_element.link_to (first_element)
						first_element := new_element
					else -- la lista contiene almento un elemento e il primo elemento non e' 'target'
						from
							previous_element := first_element
						until
							attached previous_element as pe implies ((pe.next = Void) or else (attached pe.next as pen implies pen.value = target))
						loop
							previous_element := previous_element.next
						end
						check attached previous_element as pe then
							if pe.next /= Void then
								new_element.link_after (pe)
							else -- list does not contain `target'
								new_element.link_to (first_element)
								first_element := new_element
							end
						end
					end
				end
			end
			count := count + 1
		ensure
			uno_in_piu: count = old count + 1
			in_testa_se_non_presente: not (old has (target)) implies (attached first_element as fe implies fe.value = a_value)
			collegato_se_presente: old has (target) implies value_follows (target, a_value);
		end

	insert_before_using_has (a_value, target: G)
			-- Insert `a_value' before `target' if present otherwise add `a_value' at the end
			-- Alternative (less efficient) implementation using feature `has'
		local
			previous_element, new_element: like first_element
		do
			new_element := attached_element (a_value)
			if has (target) then
				if attached first_element as f then
					if target = f.value then
						new_element.link_to (first_element)
						first_element := new_element
					end
				else -- list has at least 2 elements and contains target from second position on
					from
						previous_element := first_element
					until
						attached previous_element as pe implies ((pe.next = Void) or else (attached pe.next as pen implies pen.value = target))
					loop
						if attached previous_element as p then
							if attached p.next as p_n then
								previous_element := previous_element.next
							end
						end
					end
					new_element.link_after (previous_element)
				end
			else -- list does not contain target
				if count = 0 then
					first_element := new_element
					last_element := first_element
				else
					new_element.link_to (first_element)
					first_element := new_element
				end
			end
			count := count + 1
		ensure
			one_more: count = old count + 1
			prepend_if_present: not (old has (target)) implies (attached first_element as fe implies fe.value = a_value)
			linked_if_present: old has (target) implies value_follows (target, a_value);
		end

	insert_multiple_after (a_value, target: G)
			-- Inserisce `new' dopo ogni `target', se ne esistono
			-- Altrimenti inserisce `new' alla fine
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
						new_element := attached_element (a_value)
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
				new_element := attached_element (a_value)
				if count = 0 then
					first_element := new_element
					last_element := new_element
				else
					new_element.link_after (last_element)
					last_element := new_element
				end
				count := count + 1
			end
		ensure
			di_piu: count > old count
			appeso_se_non_presente: not (old has (target)) implies (attached last_element as le implies le.value = a_value)
			collegato_se_presente: old has (target) implies (attached get_element (target) as ge implies (attached ge.next as gen implies gen.value = a_value))
		end

	insert_multiple_before (a_value, target: G)
			-- Inserisce `a_value' subito prima di ogni occorrenza di `target' se esiste
			-- Altrimenti inserisce `a_value' all'inizio
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
						new_element := attached_element (a_value)
						if previous_element = Void then
							new_element.link_to (first_element)
							first_element := new_element
						else
							previous_element.link_to (new_element)
							new_element.link_to (current_element)
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
					last_element := first_element
				else
					new_element.link_to (first_element)
					first_element := new_element
				end
				count := count + 1
			end
		ensure
			di_piu: count > old count
			in_testa_se_non_presente: not (old has (target)) implies (attached first_element as fe implies fe.value = a_value)
			collegato_se_presente: old has (target) implies (attached get_element (a_value) as ge implies (attached ge.next as n implies n.value = target))
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
			count := 0
		end

	stampa
			-- print the entire list
		local
			temp: like first_element
		do
			print ("%N La lista contiene: ")
			from
				temp := first_element
			until
				temp = Void
			loop
					--io.put_string (temp.value)
				print (temp.value)
				print (", ")
				temp := temp.next
			end
			print ("%N che sono in totale ")
			print (count)
			print (" elementi.")
			print ("%N")
		end

feature --query fondamentali

	has (a_value: G): BOOLEAN
			-- La lista contiene `a_value'?
		local
			current_element, temp: like first_element
		do
			from
				current_element := first_element;
				temp := Void
			invariant
				not Result implies (temp /= Void implies temp.value /= a_value)
			until
				(current_element = Void) or Result
			loop
				if current_element.value = a_value then
					Result := True
				end
				temp := current_element
				current_element := current_element.next
			end
		end

	value_follows (a_value, target: G): BOOLEAN
			-- La lista contiene `a_value' dopo la prima occorrenza di `target'?
		require
			esiste_bersaglio: has (target)
		local
			current_element, temp: like first_element
		do
			from
				current_element := get_element (target)
				temp := Void
			invariant
				not Result implies (temp /= Void implies temp.value /= a_value)
			until
				(current_element = Void) or Result
			loop
				if current_element.value = a_value then
					Result := True
				end
				temp := current_element
				current_element := current_element.next
			end
		end

	value_after (a_value, target: G): BOOLEAN
			-- La lista contiene `a_value' subito dopo la prima occorrenza di `target'?
		require
			esiste_bersaglio: has (target)
		local
			current_element: like first_element
		do
			current_element := get_element (target)
			if attached current_element as ce then
				if attached ce.next as ce_n then
					if ce_n.value = a_value then
						result := True
					end
				end
			end
		end

	value_precedes (a_value, target: G): BOOLEAN
			--
			-- La lista contiene `a_value' prima della prima occorrenza di `target'?
		require
			esiste_target: has (target)
		local
			current_element, temp: like first_element
		do
			from
				current_element := first_element
			until
				current_element /= Void and then current_element.value = target
			loop
				if attached current_element as ce then
					if attached ce.next as ce_n then
						current_element := current_element.next
					end
				end
				from
					temp := first_element
				invariant
					not Result implies (temp /= Void implies temp.value /= a_value)
				until
					temp = current_element or Result
				loop
					if temp /= void and then temp.value = a_value then
						Result := True
					end
					if attached temp as t then
						if attached t.next as t_n then
							temp := temp.next
						end
					end
				end
			end
		end

	value_before (a_value, target: G): BOOLEAN
			-- La lista contiene `a_value' subito prima della prima occorrenza di `target'?
		require
			esiste_target: has (target)
		local
			current_element, temp: like first_element
		do
			from
				current_element := first_element
				temp := void
			invariant
				not Result implies (attached current_element as ce implies ce.value /= target)
			until
				attached current_element as ce implies ce.value = target
			loop
				temp := current_element
				current_element := current_element.next
				if current_element /= void and then current_element.value = target then
					if temp.value = a_value then
						result := True
					end
				end
			end
		end

	get_element (a_value: G): detachable MY_LINKABLE [G]
			-- Ritorna il primo elemento contenente `a_value', se esiste
		local
			current_element, temp: like first_element
		do
			from
				current_element := first_element;
				temp := Void
			invariant
				Result = Void implies (temp /= Void implies temp.value /= a_value)
			until
				(current_element = Void) or (Result /= Void)
			loop
				if current_element.value = a_value then
					Result := current_element
				end
				temp := current_element
				current_element := temp.next
			end
		ensure
			(Result /= Void) implies Result.value = a_value
		end

invariant
	contatore_non_negativo: count >= 0
	lista_termina_Void: attached last_element as le implies le.next = Void
	consistenza_lista_vuota: count = 0 implies (first_element = last_element) and (first_element = Void)
	consistenza_lista_mono_elemento: count = 1 implies (first_element = last_element) and (first_element /= Void)
	consistenza_lista_pluri_elemento: count > 1 implies (first_element /= last_element) and (first_element /= Void) and (last_element /= Void) and then (attached first_element as fe implies fe.next /= Void)

end
