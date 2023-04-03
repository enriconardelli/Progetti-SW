note
	description: "Test per le feature di tipo COMPUTATION"
	author: "Gianluca Pastorini"
	date: "$03/04/23"
	revision: "$Revision$"

class
	COMPUTATION_TESTS

inherit

	STATIC_TESTS

feature -- highest

	t_one_element (a_value: INTEGER)
	-- test con lista di un elemento
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			assert ("errore il massimo non è il primo elemento", t.highest = a_value)
		end

	t_three_elements_fisrt (a_value: INTEGER)
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

	t_three_elements_last (a_value: INTEGER)
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

	t_three_elements_middle (a_value: INTEGER)
	-- test con lista di tre elementi e valore più alto in mezzo
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 1)
			t.append (a_value)
			t.append (a_value - 4)
			assert ("errore il massimo non è l'ultimo elemento", t.highest = a_value)
		end

	t_highest
	-- fa tutti i test elencati sopra con possibilità di cambiare il parametro
		do
			t_one_element (1)
			t_three_elements_fisrt (1)
			t_three_elements_middle (1)
			t_three_elements_last (1)
		end

feature -- Sum_of_positive

		--Giulia Iezzi 2020/03/08, parametrizzato Gianluca Pastorini 03/04/23

	t_sop_negativ (a_value: INTEGER)
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

	t_sop_vuota (a_value: INTEGER) --ho messo comunque la variabile perché così questo test non viene eseguito qui, ma solamente nel test finale che fa tutti i test
			--somaa con lista vuota
		local
			t: INT_LINKED_LIST
		do
			create t
			assert ("ha sommato qualcosa anche se la lista è vuota", t.sum_of_positive = 0)
		end

	t_sop_positive (a_value: INTEGER)
			--somma con elementi positvi
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value.abs)
			t.append (a_value.abs)
			assert ("non ha svolto la somma positiva correttamente", t.sum_of_positive = 2 * a_value.abs)
		end

	t_sop_mixed (a_value: INTEGER)
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

	t_sum_of_positive
	-- fa tutti i test elencati sopra con possibilità di cambiare il parametro
		do
			t_sop_negativ (1)
			t_sop_vuota (1)
			t_sop_positive (1)
			t_sop_mixed (1)
		end

feature -- count_of
	-- già nelle postcondizioni della feature ci garantisce che se l'elemento non c'è il risultato è 0, quindi ci saranno solo test su quante istanze effettivamente conta

	t_count_one_start (a_value: INTEGER)
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

	t_count_one_end (a_value: INTEGER)
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

	t_count_middle (a_value: INTEGER)
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

	t_count_multiple (a_value: INTEGER)
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

	t_count_of
	-- fa tutti i test elencati sopra con possibilità di cambiare il parametro
		do
			t_count_one_start (1)
			t_count_one_end (1)
			t_count_multiple (1)
			t_count_multiple (1)
		end

end
