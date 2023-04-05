note
	description: "Test per le feature di tipo remove_single_free."
	author: "Gianluca Pastorini"
	date: "05/04/23$"
	revision: "$Revision$"

class
	REMOVE_SINGLE_FREE_TESTS

inherit

	STATIC_TESTS

feature -- remove_latest

	a_value: INTEGER = 1

	t_latest_one_element_one_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.remove_latest (a_value)
			assert ("l'indice non è zero", t.index = 0)
			assert ("la lista contiene ancora a_value", not t.has (a_value))
		end

	t_latest_no_value_one_element
			-- non inserire 0 come a_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.remove_latest (2 * a_value)
			if attached t.active_element as ta then
				ta.link_to (Void)
			end
			assert ("ERRORE: rimosso elemento sbagliato", t.has (a_value))
			assert ("ERRORE: active_element modificato erroneamente", attached t.active_element as ta implies ta.value = a_value)
		end

	t_latest_no_value_two_elements
			-- non inserire 0 come a_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (2 * a_value)
			t.remove_latest (3 * a_value)
			assert ("rimosso elemento sbagliato", t.has (a_value))
		end

	t_latest_no_value_three_elements
			-- non inserire 0 come a_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (2 * a_value)
			t.append (3 * a_value)
			t.remove_latest (4 * a_value)
			assert ("rimosso elemento sbagliato", t.has (a_value))
		end

	t_latest_single_value_first
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.append (2)
			t.append (3)
			count_prima := how_many (t, a_value)
			t.remove_latest (a_value)
			count_dopo := how_many (t, a_value)
			assert ("count prima e dopo scorretto", count_prima = count_dopo + 1)
		end

	t_latest_single_value_middle
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (2)
			t.append (a_value)
			t.append (3)
			count_prima := how_many (t, a_value)
			t.remove_latest (a_value)
			count_dopo := how_many (t, a_value)
			assert ("count prima e dopo scorretto", count_prima = count_dopo + 1)
		end

	t_latest_single_value_last
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (2)
			t.append (3)
			t.append (a_value)
			count_prima := how_many (t, a_value)
			t.remove_latest (a_value)
			count_dopo := how_many (t, a_value)
			assert ("count prima e dopo scorretto", count_prima = count_dopo + 1)
		end

	t_latest_multiple_value_first_middle
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.append (2)
			t.append (a_value)
			t.append (3)
			count_prima := how_many (t, a_value)
			t.remove_latest (a_value)
			count_dopo := how_many (t, a_value)
			assert ("count prima e dopo scorretto", count_prima = count_dopo + 1)
			assert ("rimosso elemento sbagliato in testa", attached t.first_element as tf implies tf.value = a_value)
		end

	t_latest_multiple_value_first_last
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.append (2)
			t.append (a_value)
			count_prima := how_many (t, a_value)
			t.remove_latest (a_value)
			count_dopo := how_many (t, a_value)
			assert ("count prima e dopo scorretto", count_prima = count_dopo + 1)
			assert ("rimosso elemento sbagliato in testa", attached t.first_element as tf implies tf.value = a_value)
			assert ("rimosso elemento sbagliato in coda", attached t.last_element as tl implies tl.value /= a_value)
		end

	t_latest_multiple_value_middle_last
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (2)
			t.append (a_value)
			t.append (3)
			t.append (a_value)
			count_prima := how_many (t, a_value)
			t.remove_latest (a_value)
			count_dopo := how_many (t, a_value)
			assert ("count prima e dopo scorretto", count_prima = count_dopo + 1)
			assert ("rimosso elemento sbagliato in coda", attached t.last_element as tl implies tl.value /= a_value)
		end

end
