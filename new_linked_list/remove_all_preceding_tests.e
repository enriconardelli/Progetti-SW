note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	REMOVE_ALL_PRECEDING_TESTS
	-- Riccardo Malandruccolo, 2020/03/11

inherit
	STATIC_TESTS

feature -- Test routines

	how_many_before (t: INT_LINKED_LIST; a_value, target: INTEGER; before: BOOLEAN): INTEGER
		-- return how many times `a_value' occurs in `t' before `target' if before=true
		-- return how many times `a_value' occurs in `t' if before=false
	local
		current_element: INT_LINKABLE
	do
		if t.count=0 then
			Result := 0
		else
			from
				current_element := t.first_element
			until
				current_element = Void or else (before = true and current_element.value = target)
			loop
				if current_element.value = a_value then
					Result := Result + 1
				end
				current_element := current_element.next
			end
		end
	end

	t_remove_all_preceding
		do
--			t_no_value_one_element(1,10)
--			t_no_value_two_element(1,10)

--			t_single_value_first(1,10)
--			t_single_value_last(1,10)
--			t_single_value_middle(1,10)

			t_single_value_first_with_target(1,10)
			t_single_value_last_with_target(1,10)
			t_single_value_middle_with_target_after(1,10)
			t_single_value_middle_with_target_before(1,10)

			t_multiple_value_with_target_after(1,10)
			t_multiple_value_with_target_before(1,10)
			t_multiple_value_with_target_middle(1,10)
			t_multiple_value_with_multiple_target(1,10)
		end

	t_no_value_one_element(a_value, target: INTEGER)
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.remove_all_preceding (2*a_value,target)
			assert("ha rimosso l'elemento (senza target)", t.has (a_value))
		end

	t_no_value_two_element(a_value, target: INTEGER)
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (2*a_value)
			t.remove_all_preceding (3*a_value,target)
			assert("ha rimosso l'elemento", t.has (a_value))
		end


	t_single_value_first(a_value, target: INTEGER)
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.append (2)
			t.append (3)

			count_prima := how_many_before(t,a_value,target,false)
			t.remove_all_preceding (a_value,target)
			count_dopo := how_many_before(t,a_value,target,false)

			assert("ha rimosso l'elemento", t.has (a_value))
			assert("ha modificato first_element", attached t.first_element as fe and then fe.value=a_value)
			assert("ha rimosso elementi", count_dopo = count_prima)
		end

	t_single_value_last(a_value, target: INTEGER)
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (2)
			t.append (3)
			t.append (a_value)

			count_prima := how_many_before(t,a_value,target,false)
			t.remove_all_preceding (a_value,target)
			count_dopo := how_many_before(t,a_value,target,false)

			assert("ha rimosso l'elemento", t.has (a_value))
			assert("ha modificato last_element", attached t.last_element as le and then le.value=a_value)
			assert("ha rimosso elementi", count_dopo = count_prima)
		end

	t_single_value_middle(a_value, target: INTEGER)
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (2)
			t.append (a_value)
			t.append (3)

			count_prima := how_many_before(t,a_value,target,false)
			t.remove_all_preceding (a_value,target)
			count_dopo := how_many_before(t,a_value,target,false)

			assert("ha rimosso l'elemento", t.has (a_value))
			assert("ha rimosso elementi", count_dopo = count_prima)
		end


	t_single_value_first_with_target(a_value, target: INTEGER)
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_pre_target,count_tot_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.append (2)
			t.append (target)
			t.append (3)

			count_tot_prima := how_many_before(t,a_value,target,false)
			count_pre_target := how_many_before(t,a_value,target,true)
			t.remove_all_preceding (a_value,target)
			count_tot_dopo := how_many_before(t,a_value,target,false)

			assert("non ha modificato first_element", attached t.first_element as fe and then fe.value=2)
			assert("ha rimosso più elementi", count_tot_dopo = count_tot_prima - count_pre_target)
		end

	t_single_value_last_with_target(a_value, target: INTEGER)
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_pre_target,count_tot_dopo: INTEGER
		do
			create t
			t.append (2)
			t.append (3)
			t.append (target)
			t.append (3)
			t.append (a_value)

			count_tot_prima := how_many_before(t,a_value,target,false)
			count_pre_target := how_many_before(t,a_value,target,true)
			t.remove_all_preceding (a_value,target)
			count_tot_dopo := how_many_before(t,a_value,target,false)

			t.remove_all_preceding (a_value,target)
			assert("ha rimosso l'elemento dopo target", count_tot_dopo = count_tot_prima-count_pre_target)
			assert("ha modificato last_element", attached t.last_element as le and then le.value = a_value)
		end

	t_single_value_middle_with_target_after(a_value, target: INTEGER)
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_pre_target,count_tot_dopo: INTEGER
		do
			create t
			t.append (2)
			t.append (a_value)
			t.append (3)
			t.append (target)
			t.append (4)

			count_tot_prima := how_many_before(t,a_value,target,false)
			count_pre_target := how_many_before(t,a_value,target,true)
			t.remove_all_preceding (a_value,target)
			count_tot_dopo := how_many_before(t,a_value,target,false)

			assert("non ha rimosso l'elemento prima di target", count_tot_dopo = count_tot_prima - count_pre_target)
		end

	t_single_value_middle_with_target_before(a_value, target: INTEGER)
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_pre_target,count_tot_dopo: INTEGER
		do
			create t
			t.append (2)
			t.append (target)
			t.append (3)
			t.append (a_value)
			t.append (4)

			count_tot_prima := how_many_before(t,a_value,target,false)
			count_pre_target := how_many_before(t,a_value,target,true)
			t.remove_all_preceding (a_value,target)
			count_tot_dopo := how_many_before(t,a_value,target,false)

			assert("ha rimosso l'elemento dopo target", count_tot_dopo = count_tot_prima - count_pre_target)
		end


	t_multiple_value_with_target_after(a_value, target: INTEGER)
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_pre_target,count_tot_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.append (2)
			t.append (a_value)
			t.append (a_value)
			t.append (3)
			t.append (target)
			t.append (4)

			count_tot_prima := how_many_before(t,a_value,target,false)
			count_pre_target := how_many_before(t,a_value,target,true)
			t.remove_all_preceding (a_value,target)
			count_tot_dopo := how_many_before(t,a_value,target,false)

			assert("non ha rimosso tutti gli elementi prima di target", count_tot_dopo = count_tot_prima - count_pre_target)
			assert("non ha modificato il first_element", attached t.first_element as fe and then fe.value=2)
		end

	t_multiple_value_with_target_before(a_value, target: INTEGER)
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_pre_target,count_tot_dopo: INTEGER
		do
			create t
			t.append (2)
			t.append (target)
			t.append (a_value)
			t.append (4)
			t.append (a_value)

			count_tot_prima := how_many_before(t,a_value,target,false)
			count_pre_target := how_many_before(t,a_value,target,true)
			t.remove_all_preceding (a_value,target)
			count_tot_dopo := how_many_before(t,a_value,target,false)

			assert("ha rimosso gli elementi dopo target", count_tot_dopo = count_tot_prima - count_pre_target)
		end

	t_multiple_value_with_target_middle(a_value, target: INTEGER)
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_pre_target,count_tot_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.append (2)
			t.append (a_value)
			t.append (target)
			t.append (4)
			t.append (a_value)
			t.append (5)

			count_tot_prima := how_many_before(t,a_value,target,false)
			count_pre_target := how_many_before(t,a_value,target,true)
			t.remove_all_preceding (a_value,target)
			count_tot_dopo := how_many_before(t,a_value,target,false)

			assert("non ha rimosso il giusto numero di elementi", count_tot_dopo = count_tot_prima - count_pre_target)
			assert("non ha rimosso gli elementi prima di target", how_many_before(t,a_value,target,true) = 0)
		end

	t_multiple_value_with_multiple_target(a_value, target: INTEGER)
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_pre_target,count_tot_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.append (2)
			t.append (target)
			t.append (a_value)
			t.append (3)
			t.append (target)
			t.append (4)
			t.append (a_value)

			count_tot_prima := how_many_before(t,a_value,target,false)
			count_pre_target := how_many_before(t,a_value,target,true)
			t.remove_all_preceding (a_value,target)
			count_tot_dopo := how_many_before(t,a_value,target,false)

			assert("non ha rimosso il giusto numero di elementi", count_tot_dopo = count_tot_prima - count_pre_target)
			assert("non ha rimosso gli elementi prima del primo target", how_many_before(t,a_value,target,true) = 0)
		end

end


