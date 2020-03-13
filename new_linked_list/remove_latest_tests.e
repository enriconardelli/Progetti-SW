note
	description: "Summary description for {REMOVE_LATEST_TESTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REMOVE_LATEST_TESTS

inherit
	STATIC_TESTS

feature

	t_remove_latest
		do
			t_no_value_one_element (1)
			t_no_value_two_elements (1)
			t_no_value_three_elements (1)
			t_single_value_first (1)
			t_single_value_middle (1)
			t_single_value_last (1)
			t_multiple_value_first_middle (1)
			t_multiple_value_first_last (1)
			t_multiple_value_middle_last (1)
		end

	t_no_value_one_element (a_value: INTEGER)
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append(a_value)
			t.remove_latest(2*a_value)
			assert("rimosso elemento sbagliato", t.has (a_value))
		end

	t_no_value_two_elements (a_value: INTEGER)
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append(a_value)
			t.append(2*a_value)
			t.remove_latest(3*a_value)
			assert("rimosso elemento sbagliato", t.has (a_value))
		end

	t_no_value_three_elements (a_value: INTEGER)
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append(a_value)
			t.append(2*a_value)
			t.append(3*a_value)
			t.remove_latest(4*a_value)
			assert("rimosso elemento sbagliato", t.has (a_value))
		end

	t_single_value_first (a_value: INTEGER)
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.append (2)
			t.append (3)
			count_prima := how_many(t, a_value)
			t.remove_latest(a_value)
			count_dopo := how_many(t, a_value)
			assert("count prima e dopo scorretto", count_prima = count_dopo + 1)
		end

	t_single_value_middle (a_value: INTEGER)
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (2)
			t.append (a_value)
			t.append (3)
			count_prima := how_many(t, a_value)
			t.remove_latest(a_value)
			count_dopo := how_many(t, a_value)
			assert("count prima e dopo scorretto", count_prima = count_dopo + 1)
		end

	t_single_value_last (a_value: INTEGER)
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (2)
			t.append (3)
			t.append (a_value)
			count_prima := how_many(t, a_value)
			t.remove_latest(a_value)
			count_dopo := how_many(t, a_value)
			assert("count prima e dopo scorretto", count_prima = count_dopo + 1)
		end

	t_multiple_value_first_middle (a_value: INTEGER)
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.append (2)
			t.append (a_value)
			t.append (3)
			count_prima := how_many(t, a_value)
			t.remove_latest(a_value)
			count_dopo := how_many(t, a_value)
			assert("count prima e dopo scorretto", count_prima = count_dopo + 1)
			assert("rimosso elemento sbagliato in testa", attached t.first_element as tf implies tf.value = a_value)
		end

	t_multiple_value_first_last (a_value: INTEGER)
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.append (2)
			t.append (a_value)
			count_prima := how_many(t, a_value)
			t.remove_latest(a_value)
			count_dopo := how_many(t, a_value)
			assert("count prima e dopo scorretto", count_prima = count_dopo + 1)
			assert("rimosso elemento sbagliato in testa", attached t.first_element as tf implies tf.value = a_value)
			assert("rimosso elemento sbagliato in coda", attached t.last_element as tl implies tl.value /= a_value)
		end

	t_multiple_value_middle_last (a_value: INTEGER)
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (2)
			t.append (a_value)
			t.append (3)
			t.append (a_value)
			count_prima := how_many(t, a_value)
			t.remove_latest(a_value)
			count_dopo := how_many(t, a_value)
			assert("count prima e dopo scorretto", count_prima = count_dopo + 1)
			assert("rimosso elemento sbagliato in coda", attached t.last_element as tl implies tl.value /= a_value)
		end

end
