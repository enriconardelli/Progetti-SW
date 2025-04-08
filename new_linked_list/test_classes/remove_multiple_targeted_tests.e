note
	description: "Test per le feature di tipo remove_multiple_targeted."
	author: "Gianluca Pastorini"
	date: "12/04/23"
	revision: "$Revision$"

class
	REMOVE_MULTIPLE_TARGETED_TESTS

inherit

	EQA_TEST_SET

feature -- parametri

	a_value: INTEGER = 1

	a_target: INTEGER = 2

	other_element_1: INTEGER = 5

	other_element_2: INTEGER = 7

feature -- remove_all_following

	t_remove_all_following_no_value
		local
			t: INT_LINKED_LIST
			s: INTEGER
		do
			create t
			t.append (other_element_1)
			t.append (a_target)
			t.append (other_element_1)
			s := t.count_of (a_value)
			t.remove_all_following (a_value, a_target)
			assert ("Nella lista non c'è a_value", s =t.count_of (a_value))
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
			h := t.count_of (a_value)
			b := t.count_of_after (a_value, a_target)
			t.remove_all_following (a_value, a_target)
			assert ("E' stato rimosso il giusto numero di occorrenze di a_value", t.count_of (a_value) = h - b)
			assert ("Il primo a_value è stato rimosso", attached t.first_element as fe implies fe.value = a_value)
			assert ("L'ultimo elemento non è stato aggiornato correttamente", attached t.last_element as le implies le.value = a_target)
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
			t.append (other_element_1)
			count_tot_prima := t.count_of (a_value)
			count_pre_target := t.count_of_before ( a_value, a_target)
			t.remove_all_preceding (a_value, a_target)
			count_tot_dopo := t.count_of (a_value)
			assert ("non ha modificato first_element", attached t.first_element as fe and then fe.value = a_target)
			assert ("ha rimosso più elementi", count_tot_dopo = count_tot_prima - count_pre_target)
		end

	t_single_value_last_with_target
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_pre_target, count_tot_dopo: INTEGER
		do
			create t
			t.append (other_element_1)
			t.append (a_target)
			t.append (other_element_2)
			t.append (a_value)
			count_tot_prima := t.count_of (a_value)
			count_pre_target := t.count_of_before ( a_value, a_target)
			t.remove_all_preceding (a_value, a_target)
			count_tot_dopo := t.count_of (a_value)
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
			t.append (other_element_1)
			t.append (a_value)
			t.append (other_element_2)
			t.append (a_target)
			t.append (other_element_1)
			count_tot_prima := t.count_of (a_value)
			count_pre_target :=t.count_of_before ( a_value, a_target)
			t.remove_all_preceding (a_value, a_target)
			count_tot_dopo := t.count_of (a_value)
			assert ("non ha rimosso l'elemento prima di target", count_tot_dopo = count_tot_prima - count_pre_target)
		end

	t_single_value_middle_with_target_before
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_pre_target, count_tot_dopo: INTEGER
		do
			create t
			t.append (other_element_1)
			t.append (a_target)
			t.append (other_element_1)
			t.append (a_value)
			t.append (other_element_2)
			count_tot_prima := t.count_of (a_value)
			count_pre_target := t.count_of_before ( a_value, a_target)
			t.remove_all_preceding (a_value, a_target)
			count_tot_dopo := t.count_of (a_value)
			assert ("ha rimosso l'elemento dopo target", count_tot_dopo = count_tot_prima - count_pre_target)
		end

	t_multiple_value_with_target_after
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_pre_target, count_tot_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.append (other_element_1)
			t.append (a_value)
			t.append (a_value)
			t.append (other_element_2)
			t.append (a_target)
			t.append (other_element_1)
			count_tot_prima := t.count_of (a_value)
			count_pre_target := t.count_of_before ( a_value, a_target)
			t.remove_all_preceding (a_value, a_target)
			count_tot_dopo := t.count_of (a_value)
			assert ("non ha rimosso tutti gli elementi prima di target", count_tot_dopo = count_tot_prima - count_pre_target)
			assert ("non ha modificato il first_element", attached t.first_element as fe and then fe.value = other_element_1)
		end

	t_multiple_value_with_target_before
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_pre_target, count_tot_dopo: INTEGER
		do
			create t
			t.append (other_element_1)
			t.append (a_target)
			t.append (a_value)
			t.append (other_element_2)
			t.append (a_value)
			count_tot_prima := t.count_of (a_value)
			count_pre_target := t.count_of_before ( a_value, a_target)
			t.remove_all_preceding (a_value, a_target)
			count_tot_dopo := t.count_of (a_value)
			assert ("ha rimosso gli elementi dopo target", count_tot_dopo = count_tot_prima - count_pre_target)
		end

	t_multiple_value_with_target_middle
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_pre_target, count_tot_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.append (other_element_1)
			t.append (a_value)
			t.append (a_target)
			t.append (other_element_1)
			t.append (a_value)
			t.append (other_element_2)
			count_tot_prima := t.count_of (a_value)
			count_pre_target := t.count_of_before ( a_value, a_target)
			t.remove_all_preceding (a_value, a_target)
			count_tot_dopo := t.count_of (a_value)
			assert ("non ha rimosso il giusto numero di elementi", count_tot_dopo = count_tot_prima - count_pre_target)
			assert ("non ha rimosso gli elementi prima di target", t.count_of_before ( a_value, a_target)= 0)
		end

	t_multiple_value_with_multiple_target
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_pre_target, count_tot_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.append (other_element_1)
			t.append (a_target)
			t.append (a_value)
			t.append (other_element_2)
			t.append (a_target)
			t.append (other_element_1)
			t.append (a_value)
			count_tot_prima := t.count_of (a_value)
			count_pre_target := t.count_of_before (a_value, a_target)
			t.remove_all_preceding (a_value, a_target)
			count_tot_dopo := t.count_of (a_value)
			assert ("non ha rimosso il giusto numero di elementi", count_tot_dopo = count_tot_prima - count_pre_target)
			assert ("non ha rimosso gli elementi prima del primo target", t.count_of_before ( a_value, a_target) = 0)
		end

	t_value_equals_target
		local
			t: INT_LINKED_LIST
			count_tot_prima, count_tot_dopo: INTEGER
		do
			create t
			t.append (other_element_1)
			t.append (a_value)
			t.append (other_element_2)
			t.append (a_value)
			t.append (a_value)
			count_tot_prima := t.count_of (a_value)
			t.remove_all_preceding (a_value, a_value)
			count_tot_dopo := t.count_of (a_value)
			assert ("ha rimosso elementi", count_tot_dopo = count_tot_prima)
		end

end
