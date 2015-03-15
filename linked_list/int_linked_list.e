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

	last_element: detachable INT_LINKABLE
			-- Last cell of the list

	count: INTEGER
			-- Number of elements in the list

	count_buffer: INTEGER
			-- Buffer to store the number of elements in the list during test of class invariants

	append (a_value: INTEGER)
			-- Add `a_value' to end.
		local
			new_element: like first_element
		do
			create new_element.make (a_value)
			if first_element = Void then
				first_element := new_element
			else
				last_element.link_to (new_element)
			end
			last_element := new_element
			count := count + 1
		ensure
			last_element.value = a_value
			count = old count + 1
		end

	has (a_value: INTEGER): BOOLEAN
			-- Does list contain `a_value'?
		local
			temp, pre_temp: like first_element
		do
			from
				temp := first_element;
				pre_temp := Void
			invariant
				not Result implies (pre_temp /= Void implies pre_temp.value /= a_value)
			until
				(temp = Void) or Result
			loop
				if temp.value = a_value then
					Result := True
				end
				pre_temp := temp
				temp := temp.next
			end
		end

	get_element (a_value: INTEGER): detachable INT_LINKABLE
			-- Return item containing `a_value', if any
		local
			temp, pre_temp: like first_element
		do
			from
				temp := first_element;
				pre_temp := Void
			invariant
				Result = Void implies (pre_temp /= Void implies pre_temp.value /= a_value)
			until
				(temp = Void) or (Result /= Void)
			loop
				if temp.value = a_value then
					Result := temp
				end
				pre_temp := temp
				temp := temp.next
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
			-- Insert `new' after `target' if present otherwise add `new' at the end
		local
			target_element, new_element: like first_element
		do
			create new_element.make (new)
			from
				target_element := first_element
			until
				target_element = Void or else target_element.value = target
			loop
				target_element := target_element.next
			end
			if target_element /= Void then
				new_element.insert_after (target_element)
				if last_element = target_element then
					last_element := new_element
				end
			else -- list does not contain `target'
				if count = 0 then
					first_element := new_element
					last_element := first_element
				else
					new_element.insert_after (last_element)
					last_element := new_element
				end
			end
			count := count + 1
		ensure
			one_more: count = old count + 1
			appended_if_not_present: not (old has (target)) implies last_element.value = new;
			linked_if_present: old has (target) implies get_element (target).next.value = new;
		end

	insert_before (new, target: INTEGER)
			-- Insert `new' before `target' if present otherwise add `new' at the beginning
		local
			previous_element, new_element: like first_element
		do
			create new_element.make (new)
			if count = 0 then
				first_element := new_element
				last_element := first_element
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
						new_element.insert_after (previous_element)
					else -- list does not contain `target'
						new_element.link_to (first_element)
						first_element := new_element
					end
				end
			end
			count := count + 1
		ensure
			one_more: count = old count + 1
			prepended_if_not_present: not (old has (target)) implies first_element.value = new;
			linked_if_present: old has (target) implies get_element (new).next.value = target;
		end

		--	insert_before (new, target: INTEGER)
		--			-- Insert `new' before `target' if present otherwise add `new' at the end
		--			-- Alternative (less efficient) implementation using feature `has'
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
		--			prepended_if_not_present: not (old has (target)) implies first_element.value = new;
		--			linked_if_present: old has (target) implies get_item (new).next.value = target;
		--		end

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
			dummy: like first_element
		do
			print ("%N La lista contiene: ")
			dummy_do
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
			dummy_reset
			print (count)
			print (" elementi.")
			create dummy.make (0)
			dummy_do
			dummy.exec_nothing
			dummy_reset
			print ("%N")
		end

	dummy_do
			-- dummy feature to test class invariants
		do
			count_buffer := count
			count := 0
		end

	dummy_reset
			-- dummy feature to test class invariants
		do
			count := count_buffer
		end

invariant
	count >= 0
	last_element /= Void implies last_element.next = Void
	count = 0 implies (first_element = last_element) and (first_element = Void)
	count = 1 implies (first_element = last_element) and (first_element /= Void)
	count > 1 implies (first_element /= last_element) and (first_element /= Void) and (last_element /= Void) and then (first_element.next /= Void)

end
