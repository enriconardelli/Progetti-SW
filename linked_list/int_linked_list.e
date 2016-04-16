note
	description: "Summary description for {INT_LINKED_LIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INT_LINKED_LIST

feature

	first_element: detachable INT_LINKABLE
			-- First cell of the list

	first: INTEGER
			-- Return the value in the first cell of the list
		do
			check attached first_element as fe then
				Result := fe.value
			end
		end

	last_element: detachable INT_LINKABLE
			-- Last cell of the list

	last: INTEGER
			-- Return the value in the last cell of the list
		do
			check attached last_element as le then
				Result := le.value
			end
		end

	attached_element (i: INTEGER): INT_LINKABLE
			-- dummy cell of the list, always attached
		do
			create Result.make (i)
		ensure
			result_exists: Result /= Void
		end

	count: INTEGER
			-- Number of elements in the list

	append (a_value: INTEGER)
			-- Add `a_value' to end.
		local
			new_element: like first_element
		do
			create new_element.make (a_value)
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

	has (a_value: INTEGER): BOOLEAN
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

	value_follows (a_value, target: INTEGER): BOOLEAN
			-- La lista contiene `a_value' dopo la prima occorrenza di `target'?
		require
			esiste_bersaglio: has(target)
		local
			current_element, temp: like first_element
		do
			from
				current_element := get_element(target)
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

	get_element (a_value: INTEGER): detachable INT_LINKABLE
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

	sum_of_positive: INTEGER
			-- The sum of positive elements
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

	insert_after (new, target: INTEGER)
			-- Inserisce `new' dopo la prima occorrenza di `target' se presente
			-- Altrimenti inserisce `new' alla fine
		local
			current_element, new_element: like first_element
		do
			create new_element.make (new)
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
			accodato_se_non_presente: not (old has (target)) implies (attached last_element as le implies le.value = new)
			collegato_se_presente: old has (target) implies (attached get_element (target) as ge implies (attached ge.next as gen implies gen.value = new))
		end

--	insert_before (new, target: INTEGER)
--			-- Inserisce `new' prima della prima occorrenza di `target' se esiste
--			-- Altrimenti inserisce `new' all'inizio
--		local
--			previous_element: like first_element
--			new_element: like attached_element
--		do
--			create new_element.make (new)
--			if count = 0 then
--				first_element := new_element
--				last_element := first_element
--			else
--				if (target = first) then
--					new_element.link_to (first_element)
--					first_element := new_element
--				else -- list contains at least one element and the first element is not the target
--					from
--						previous_element := first_element
--					until
--						attached previous_element as pe implies ((pe.next = Void) or else (attached pe.next as pen implies pen.value = target))
--					loop
--						previous_element := previous_element.next
--					end
--					check attached previous_element as pe then
--						if pe.next /= Void then
--							new_element.insert_after (pe)
--						else -- list does not contain `target'
--							new_element.link_to (first_element)
--							first_element := new_element
--						end
--					end
--				end
--			end
--			count := count + 1
--		ensure
--			uno_in_piu: count = old count + 1
--			in_testa_se_non_presente: not (old has (target)) implies (attached first_element as fe implies fe.value = new)
--			collegato_se_presente: old has (target) implies (attached get_element (new) as ge implies (attached ge.next as gen implies gen.value = target))
--		end

			insert_before (new, target: INTEGER)
					-- Insert `new' before `target' if present otherwise add `new' at the end
					-- Alternative (less efficient) implementation using feature `has'
				local
					previous_element: like first_element
					new_element: like attached_element
				do
					create new_element.make (new)
					if has (target) then
						if target = first then
							new_element.link_to (first_element)
							first_element := new_element
						else -- list has at least 2 elements and contains target from second position on
							from
								previous_element := first_element
							until
								attached previous_element as pe implies (attached pe.next as pen implies (pen.value = target))
							loop
								previous_element := previous_element.next
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
					uno_in_piu: count = old count + 1
					in_testa_se_non_presente: not (old has (target)) implies (attached first_element as fe implies fe.value = new)
					collegato_se_presente: old has (target) implies (attached get_element (new) as ge implies (attached ge.next as gen implies gen.value = target))
				end

	insert_multiple_after (new, target: INTEGER)
			-- Inserisce `new' dopo ogni `target', se ne esistono
			-- Altrimenti inserisce `new' alla fine
		local
			new_element: like attached_element
			current_element: like first_element
		do
			if has(target) then
				from
					current_element := first_element
				until
					current_element = Void
				loop
					if current_element.value = target then
						create new_element.make (new)
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
				create new_element.make (new)
				if count=0 then
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
			appeso_se_non_presente: not (old has(target)) implies (attached last_element as le implies le.value = new)
			collegato_se_presente: old has(target) implies (attached get_element(target) as ge implies (attached ge.next as gen implies gen.value = new))
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
				print (temp.value)
				print (", ")
				temp := temp.next
			end
			print ("%N che sono in totale ")
			print (count)
			print (" elementi.")
			print ("%N")
		end

invariant
	contatore_non_negativo: count >= 0
	lista_termina_Void: attached last_element as le implies le.next = Void
	consistenza_lista_vuota: count = 0 implies (first_element = last_element) and (first_element = Void)
	consistenza_lista_mono_elemento: count = 1 implies (first_element = last_element) and (first_element /= Void)
	consistenza_lista_pluri_elemento: count > 1 implies (first_element /= last_element) and (first_element /= Void) and (last_element /= Void) and then (attached first_element as fe implies fe.next /= Void)

end
