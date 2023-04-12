note
	description: "Test per le feature di tipo remove_multiple_targeted."
	author: "Gianluca Pastorini"
	date: "12/04/23"
	revision: "$Revision$"

class
	REMOVE_MULTIPLE_TARGETED_TESTS

inherit

	STATIC_TESTS

feature -- parametri

	a_value: INTEGER = 1

	a_target: INTEGER = 2

feature -- supporto

	how_many (t: INT_LINKED_LIST; value: INTEGER): INTEGER
			-- return how many times `a_value' occurs in `t'
			-- � identica a count_of, solo che � una funzione esterna alla lista
		local
			current_element: INT_LINKABLE
		do
			if t.count = 0 then
				Result := 0
			else
				from
					current_element := t.first_element
				until
					current_element = Void
				loop
					if current_element.value = value then
						Result := Result + 1
					end
					current_element := current_element.next
				end
			end
		end

	how_many_after (t: INT_LINKED_LIST; value, target: INTEGER): INTEGER
			--conta le occorrenze di a_value successive a target
		require
			t.has (target)
		local
			current_element: INT_LINKABLE
		do
			if t.count = 1 then
				Result := 0
			end
			if attached t.get_element (target) as tar then
				from
					current_element := tar.next
				until
					current_element = Void
				loop
					if current_element.value = value then
						Result := Result + 1
					end
					current_element := current_element.next
				end
			end
		end

	how_many_before (t: INT_LINKED_LIST; value, target: INTEGER): INTEGER
			-- return how many times `a_value' occurs in `t' before `target' if before=true
			-- return how many times `a_value' occurs in `t' if before=false
		local
			current_element: INT_LINKABLE
		do
			if t.count = 0 then
				Result := 0
			else
				from
					current_element := t.first_element
				until
					current_element = Void or else current_element.value = target
				loop
					if current_element.value = value then
						Result := Result + 1
					end
					current_element := current_element.next
				end
			end
		end

feature -- remove_all_following

	t_remove_all_following_no_value
		local
			t: INT_LINKED_LIST
			s: INTEGER
		do
			create t
			t.append (a_value + 1)
			t.append (a_value + 3)
			t.append (a_value + 2)
			s := how_many (t, a_value)
			t.remove_all_following (a_value, a_value + 3)
			assert ("Nella lista non c'� a_value", s = how_many (t, a_value))
		end

	t_remove_all_following_with_target
		local
			t: INT_LINKED_LIST
			b, h: INTEGER
		do
			create t
			t.append (a_value)
			t.append (a_target)
			t.append (a_value)
			t.append (a_value)
			h := how_many (t, a_value)
			b := how_many_after (t, a_value, a_target)
			t.remove_all_following (a_value, a_target)
			assert ("E' stato rimosso il giusto numero di occorrenze di a_value", how_many (t, a_value) = h - b)
			assert ("Il primo a_value � stato rimosso", attached t.first_element as fe implies fe.value = a_value)
			assert ("L'ultimo elemento non � stato aggiornato correttamente", attached t.last_element as le implies le.value = a_target)
		end

feature --remove_all_preceding

	t_single_value_first_with_target
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_pre_target, count_tot_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.append (a_target)
			t.append (2)
			count_tot_prima := how_many (t, a_value)
			count_pre_target := how_many_before (t, a_value, a_target)
			t.remove_all_preceding (a_value, a_target)
			count_tot_dopo := how_many (t, a_value)
			assert ("non ha modificato first_element", attached t.first_element as fe and then fe.value = a_target)
			assert ("ha rimosso pi� elementi", count_tot_dopo = count_tot_prima - count_pre_target)
		end

	t_single_value_last_with_target
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_pre_target, count_tot_dopo: INTEGER
		do
			create t
			t.append (10)
			t.append (a_target)
			t.append (11)
			t.append (a_value)
			count_tot_prima := how_many (t, a_value)
			count_pre_target := how_many_before (t, a_value, a_target)
			t.remove_all_preceding (a_value, a_target)
			count_tot_dopo := how_many (t, a_value)
			t.remove_all_preceding (a_value, a_target)
			assert ("ha rimosso l'elemento dopo target", count_tot_dopo = count_tot_prima - count_pre_target)
			assert ("ha modificato last_element", attached t.last_element as le and then le.value = a_value)
		end

	t_single_value_middle_with_target_after
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_pre_target, count_tot_dopo: INTEGER
		do
			create t
			t.append (10)
			t.append (a_value)
			t.append (11)
			t.append (a_target)
			t.append (12)
			count_tot_prima := how_many (t, a_value)
			count_pre_target := how_many_before (t, a_value, a_target)
			t.remove_all_preceding (a_value, a_target)
			count_tot_dopo := how_many (t, a_value)
			assert ("non ha rimosso l'elemento prima di target", count_tot_dopo = count_tot_prima - count_pre_target)
		end

	t_single_value_middle_with_target_before
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_pre_target, count_tot_dopo: INTEGER
		do
			create t
			t.append (10)
			t.append (a_target)
			t.append (11)
			t.append (a_value)
			t.append (12)
			count_tot_prima := how_many (t, a_value)
			count_pre_target := how_many_before (t, a_value, a_target)
			t.remove_all_preceding (a_value, a_target)
			count_tot_dopo := how_many (t, a_value)
			assert ("ha rimosso l'elemento dopo target", count_tot_dopo = count_tot_prima - count_pre_target)
		end

	t_multiple_value_with_target_after
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_pre_target, count_tot_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.append (10)
			t.append (a_value)
			t.append (a_value)
			t.append (11)
			t.append (a_target)
			t.append (12)
			count_tot_prima := how_many (t, a_value)
			count_pre_target := how_many_before (t, a_value, a_target)
			t.remove_all_preceding (a_value, a_target)
			count_tot_dopo := how_many (t, a_value)
			assert ("non ha rimosso tutti gli elementi prima di target", count_tot_dopo = count_tot_prima - count_pre_target)
			assert ("non ha modificato il first_element", attached t.first_element as fe and then fe.value = 10)
		end

	t_multiple_value_with_target_before
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_pre_target, count_tot_dopo: INTEGER
		do
			create t
			t.append (10)
			t.append (a_target)
			t.append (a_value)
			t.append (12)
			t.append (a_value)
			count_tot_prima := how_many (t, a_value)
			count_pre_target := how_many_before (t, a_value, a_target)
			t.remove_all_preceding (a_value, a_target)
			count_tot_dopo := how_many (t, a_value)
			assert ("ha rimosso gli elementi dopo target", count_tot_dopo = count_tot_prima - count_pre_target)
		end

	t_multiple_value_with_target_middle
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_pre_target, count_tot_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.append (10)
			t.append (a_value)
			t.append (a_target)
			t.append (12)
			t.append (a_value)
			t.append (13)
			count_tot_prima := how_many (t, a_value)
			count_pre_target := how_many_before (t, a_value, a_target)
			t.remove_all_preceding (a_value, a_target)
			count_tot_dopo := how_many (t, a_value)
			assert ("non ha rimosso il giusto numero di elementi", count_tot_dopo = count_tot_prima - count_pre_target)
			assert ("non ha rimosso gli elementi prima di target", how_many_before (t, a_value, a_target) = 0)
		end

	t_multiple_value_with_multiple_target
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_pre_target, count_tot_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.append (10)
			t.append (a_target)
			t.append (a_value)
			t.append (11)
			t.append (a_target)
			t.append (12)
			t.append (a_value)
			count_tot_prima := how_many (t, a_value)
			count_pre_target := how_many_before (t, a_value, a_target)
			t.remove_all_preceding (a_value, a_target)
			count_tot_dopo := how_many (t, a_value)
			assert ("non ha rimosso il giusto numero di elementi", count_tot_dopo = count_tot_prima - count_pre_target)
			assert ("non ha rimosso gli elementi prima del primo target", how_many_before (t, a_value, a_target) = 0)
		end

	t_value_equals_target
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_tot_dopo: INTEGER
		do
			create t
			t.append (10)
			t.append (a_value)
			t.append (11)
			t.append (a_value)
			t.append (a_value)
			count_tot_prima := how_many (t, a_value)
			t.remove_all_preceding (a_value, a_value)
			count_tot_dopo := how_many (t, a_value)
			assert ("ha rimosso elementi", count_tot_dopo = count_tot_prima)
		end

end
