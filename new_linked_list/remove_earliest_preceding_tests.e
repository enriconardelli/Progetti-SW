note
	description: "Summary description for {REMOVE_EARLIEST_PRECEDING_TESTS}."
	author: "Claudia Agulini"
	date: "$Date$"
	revision: "$Revision$"

class
	REMOVE_EARLIEST_PRECEDING_TESTS

inherit
	STATIC_TESTS

feature

	t_remove_earliest_preceding
		do
			t_no_value_two_elements(1)
			t_no_value_three_elements(1)
			t_no_target_two_elements(1)
			t_no_target_three_elements(1)
			t_value_first_two_elements(1)
			t_value_first_three_elements(1)
			t_multiple_values(1)
		end

	t_no_value_two_elements (a_value: INTEGER)
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (2 + a_value)
			t.append (3 + a_value)
			count_prima := how_many (t, a_value)
			t.remove_earliest_preceding (a_value, 3 + a_value)
			count_dopo := how_many (t, a_value)
			assert("errore: lista di due elementi non contiene value", count_prima = count_dopo)
		end

	t_no_value_three_elements (a_value: INTEGER)
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (2 + a_value)
			t.append (3 + a_value)
			t.append (4 + a_value)
			count_prima := how_many (t, a_value)
			t.remove_earliest_preceding (a_value, 3 + a_value)
			count_dopo := how_many (t, a_value)
			assert("errore: lista di tre elementi non contiene value", count_prima = count_dopo)
		end

	t_no_target_two_elements (target: INTEGER)
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (2 + target)
			t.append (3 + target)
			count_prima := how_many (t, 2 + target)
			t.remove_earliest_preceding (2 + target, target)
			count_dopo := how_many (t, 2 + target)
			assert("errore: lista di due elementi non contiene target", count_prima = count_dopo)
		end

	t_no_target_three_elements (target: INTEGER)
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (2 + target)
			t.append (3 + target)
			t.append (4 + target)
			count_prima := how_many (t, 2 + target)
			t.remove_earliest_preceding (2 + target, target)
			count_dopo := how_many (t, 2 + target)
			assert("errore: lista di tre elementi non contiene target", count_prima = count_dopo)
		end

	t_value_first_two_elements (a_value: INTEGER)
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.append (a_value + 1)
			count_prima := how_many (t, a_value)
			t.remove_earliest_preceding (a_value, a_value + 1)
			count_dopo := how_many (t, a_value)
			assert("errore: count prima e dopo scorretto", count_prima = count_dopo + 1)
			assert("errore: rimosso elemento sbagliato in testa", attached t.first_element as fe implies fe.value /= a_value)
		end

	t_value_first_three_elements (a_value: INTEGER)
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.append (a_value + 1)
			t.append (a_value + 2)
			count_prima := how_many (t, a_value)
			t.remove_earliest_preceding (a_value, a_value + 1)
			count_dopo := how_many (t, a_value)
			assert("errore: count prima e dopo scorretto", count_prima = count_dopo + 1)
			assert("errore: rimosso elemento sbagliato in testa", attached t.first_element as fe implies fe.value /= a_value)
		end

	t_multiple_values (a_value: INTEGER)
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (a_value + 1)
			t.append (a_value)
			t.append (a_value + 2)
			t.append (a_value)
			t.append (a_value)
			t.append (a_value + 3)
			count_prima := how_many(t, a_value)
			t.remove_earliest_preceding (a_value, a_value + 3)
			count_dopo :=  how_many(t, a_value)
			assert("errore: lista con più occorrenze di value", count_dopo = count_prima - 1)
		end




end
