note
	description: "Summary description for {REMOVE_LATEST_TESTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DA_CANCELLARE_REMOVE_LATEST_TESTS

inherit
	STATIC_TESTS

feature

-- CLASSE DA CANCELLARE, I TEST SONO STATI SPOSTATI IN REMOVE_SINGLE_FREE_TEST






--	a_value: INTEGER = 1

--	t_remove_latest
--		do
--			t_no_value_one_element (1)
--			t_no_value_two_elements (1)
--			t_no_value_three_elements (1)
--			t_single_value_first (1)
--			t_single_value_middle (1)
--			t_single_value_last (1)
--			t_multiple_value_first_middle (1)
--			t_multiple_value_first_last (1)
--			t_multiple_value_middle_last (1)
--		end

--	t_no_value_one_element
--		local
--			t: INT_LINKED_LIST
--		do
--			create t
--			t.append(a_value)
--			t.remove_latest(2*a_value)
--			if attached t.active_element as ta then ta.link_to (Void) end
--			assert("ERRORE: rimosso elemento sbagliato", t.has (a_value))
--			assert("ERRORE: active_element modificato erroneamente", attached t.active_element as ta implies ta.value = a_value)
--		end
--
--	t_no_value_two_elements
--		local
--			t: INT_LINKED_LIST
--		do
--			create t
--			t.append(a_value)
--			t.append(2*a_value)
--			t.remove_latest(3*a_value)
--			assert("rimosso elemento sbagliato", t.has (a_value))
--		end
--
--	t_no_value_three_elements
---		local
--			t: INT_LINKED_LIST
--		do
---			create t
--			t.append(a_value)
--			t.append(2*a_value)
--			t.append(3*a_value)
--			t.remove_latest(4*a_value)
--			assert("rimosso elemento sbagliato", t.has (a_value))
--		end

--	t_single_value_first
--		local
--			t: INT_LINKED_LIST
--			count_prima, count_dopo: INTEGER
--		do
--			create t
--			t.append (a_value)
--			t.append (2)
--			t.append (3)
--			count_prima := how_many(t, a_value)
---			t.remove_latest(a_value)
--			count_dopo := how_many(t, a_value)
--			assert("count prima e dopo scorretto", count_prima = count_dopo + 1)
--		end
--
--	t_single_value_middle
--		local
---			t: INT_LINKED_LIST
--			count_prima, count_dopo: INTEGER
--		do
--			create t
--			t.append (2)
--			t.append (a_value)
--			t.append (3)
--			count_prima := how_many(t, a_value)
--			t.remove_latest(a_value)
--			count_dopo := how_many(t, a_value)
--			assert("count prima e dopo scorretto", count_prima = count_dopo + 1)
--		end
--
--	t_single_value_last
--		local
--			t: INT_LINKED_LIST
--			count_prima, count_dopo: INTEGER
--		do
--			create t
--			t.append (2)
--			t.append (3)
--			t.append (a_value)
--			count_prima := how_many(t, a_value)
--			t.remove_latest(a_value)
--			count_dopo := how_many(t, a_value)
--			assert("count prima e dopo scorretto", count_prima = count_dopo + 1)
--		end
--
--	t_multiple_value_first_middle
--		local
--			t: INT_LINKED_LIST
--			count_prima, count_dopo: INTEGER
--		do
--			create t
--			t.append (a_value)
--			t.append (2)
--			t.append (a_value)
--			t.append (3)
--			count_prima := how_many(t, a_value)
--			t.remove_latest(a_value)
--			count_dopo := how_many(t, a_value)
--			assert("count prima e dopo scorretto", count_prima = count_dopo + 1)
--			assert("rimosso elemento sbagliato in testa", attached t.first_element as tf implies tf.value = a_value)
--		end
--
--	t_multiple_value_first_last
--		local
--			t: INT_LINKED_LIST
---			count_prima, count_dopo: INTEGER
--		do
--			create t
--			t.append (a_value)
--			t.append (2)
--			t.append (a_value)
--			count_prima := how_many(t, a_value)
--			t.remove_latest(a_value)
--			count_dopo := how_many(t, a_value)
--			assert("count prima e dopo scorretto", count_prima = count_dopo + 1)
--			assert("rimosso elemento sbagliato in testa", attached t.first_element as tf implies tf.value = a_value)
--			assert("rimosso elemento sbagliato in coda", attached t.last_element as tl implies tl.value /= a_value)
--		end

--	t_multiple_value_middle_last
--		local
--			t: INT_LINKED_LIST
--			count_prima, count_dopo: INTEGER
--		do
--			create t
--			t.append (2)
--			t.append (a_value)
--			t.append (3)
--			t.append (a_value)
--			count_prima := how_many(t, a_value)
--			t.remove_latest(a_value)
--			count_dopo := how_many(t, a_value)
--			assert("count prima e dopo scorretto", count_prima = count_dopo + 1)
--			assert("rimosso elemento sbagliato in coda", attached t.last_element as tl implies tl.value /= a_value)
--		end

end
