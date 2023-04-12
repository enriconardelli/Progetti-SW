note
	description: "Test per le feature di tipo COMPUTATION"
	author: "Gianluca Pastorini"
	date: "03/04/23"
	revision: "$Revision$"

class
	COMPUTATION_TESTS

inherit

	STATIC_TESTS

feature -- parametri

	a_value: INTEGER = 1

	a_target: INTEGER = 2

feature -- count_of
	-- già nelle postcondizioni della feature ci garantisce che se l'elemento non c'è il risultato è 0, quindi ci saranno solo test su quante istanze effettivamente conta

	t_count_one_start
			--un valore solo all'inizio
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value + 3)
			t.append (a_value + 2)
			assert ("ha contato più di un'istanza rispetto a quella iniziale", t.count_of (a_value) = 1)
		end

	t_count_one_end
			-- un valore solo alla fine
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value + 2)
			t.append (a_value + 3)
			t.append (a_value)
			assert ("ha contato più di un'istanza rispetto a quella finale", t.count_of (a_value) = 1)
		end

	t_count_middle
			-- un valore solo in mezzo
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value + 3)
			t.append (a_value)
			t.append (a_value + 2)
			assert ("ha contato più di un'istanza rispetto a quella in mezzo", t.count_of (a_value) = 1)
		end

	t_count_multiple
			-- valori misti
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value)
			t.append (a_value + 2)
			assert ("ha contato poche volte", t.count_of (a_value) >= 2)
			assert ("ha contato troppe volte", t.count_of (a_value) <= 2)
		end

feature -- count_of_before

	t_count_of_before_no_good_value_first
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target)
			t.append (a_value)
			assert ("ha contato troppe volte", t.count_of_before (a_value, a_target) = 0)
		end

	t_count_of_before_no_good_value_middle
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 4)
			t.append (a_target)
			t.append (a_value)
			assert ("ha contato troppe volte", t.count_of_before (a_value, a_target) = 0)
		end

	t_count_of_before_single
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_target)
			t.append (a_value)
			assert ("ha contato poche volte", t.count_of_before (a_value, a_target) >= 1)
			assert ("ha contato troppe volte", t.count_of_before (a_value, a_target) <= 1)
		end

	t_count_of_before_multiple_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value - 5)
			t.append (a_value)
			t.append (a_target)
			t.append (a_value)
			assert ("ha contato poche volte", t.count_of_before (a_value, a_target) >= 2)
			assert ("ha contato troppe volte", t.count_of_before (a_value, a_target) <= 2)
		end

	t_count_of_before_multiple_target
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value - 5)
			t.append (a_value)
			t.append (a_target)
			t.append (a_value)
			t.append (a_target)
			assert ("ha contato poche volte", t.count_of_before (a_value, a_target) >= 2)
			assert ("ha contato troppe volte", t.count_of_before (a_value, a_target) <= 2)
		end

feature -- count_of_after

	t_count_of_after_no_good_value_last
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_target)
			assert ("ha contato troppe volte", t.count_of_after (a_value, a_target) = 0)
		end

	t_count_of_after_no_good_value_middle
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_target)
			t.append (a_value - 4)
			assert ("ha contato troppe volte", t.count_of_after (a_value, a_target) = 0)
		end

	t_count_of_after_single
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_target)
			t.append (a_value)
			assert ("ha contato poche volte", t.count_of_after (a_value, a_target) >= 1)
			assert ("ha contato troppe volte", t.count_of_after (a_value, a_target) <= 1)
		end

	t_count_of_after_multiple_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value - 5)
			t.append (a_target)
			t.append (a_value)
			t.append (a_value - 5)
			t.append (a_value)
			assert ("ha contato poche volte", t.count_of_after (a_value, a_target) >= 2)
			assert ("ha contato troppe volte", t.count_of_after (a_value, a_target) <= 2)
		end

	t_count_of_after_multiple_target
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value - 5)
			t.append (a_value)
			t.append (a_target)
			t.append (a_value)
			t.append (a_target)
			t.append (a_value)
			t.append (a_value - 5)
			assert ("ha contato poche volte", t.count_of_before (a_value, a_target) >= 2)
			assert ("ha contato troppe volte", t.count_of_before (a_value, a_target) <= 2)
		end

feature -- highest

	t__highest_one_element
			-- test con lista di un elemento
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			assert ("errore il massimo non è il primo elemento", t.highest = a_value)
		end

	t_highest_three_elements_fisrt
			-- test con lista di tre elementi e valore più alto all'inizio
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value - 1)
			t.append (a_value - 3)
			assert ("errore il massimo non è il primo elemento", t.highest = a_value)
		end

	t_highest_three_elements_last
			-- test con lista di tre elementi e valore più alto alla fine
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 1)
			t.append (a_value - 4)
			t.append (a_value)
			assert ("errore il massimo non è l'ultimo elemento", t.highest = a_value)
		end

	t_highest_three_elements_middle
			-- test con lista di tre elementi e valore più alto in mezzo
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 1)
			t.append (a_value)
			t.append (a_value - 4)
			assert ("errore il massimo non è il secondo elemento", t.highest = a_value)
		end

feature -- Sum_of_positive

		--Giulia Iezzi 2020/03/08, parametrizzato Gianluca Pastorini 03/04/23

	t_sop_negativ
			--somma con elementi negativi
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (- a_value.abs)
			t.append (- a_value.abs - 2)
			t.append (- a_value.abs - 3)
			assert ("ha sommato dei numeri negativi", t.sum_of_positive = 0)
		end

	t_sop_vuota
			--somMa con lista vuota
		local
			t: INT_LINKED_LIST
		do
			create t
			assert ("ha sommato qualcosa anche se la lista è vuota", t.sum_of_positive = 0)
		end

	t_sop_positive
			--somma con elementi positvi
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value.abs)
			t.append (a_value.abs)
			assert ("non ha svolto la somma positiva correttamente", t.sum_of_positive = 2 * a_value.abs)
		end

	t_sop_mixed
			--somma con elementi misti
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value.abs)
			t.append (a_value.abs)
			t.append (- a_value.abs)
			assert ("non ha svolto la somma mista correttamente", t.sum_of_positive = 2 * a_value.abs)
		end

end
