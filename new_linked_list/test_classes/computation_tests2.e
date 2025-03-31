note
	description: "Test per le feature di tipo COMPUTATION"
	author: "Marco Aragona & Gabriele Messina"
	date: "29/03/25"
	revision: "$Revision$"

class
	COMPUTATION_TESTS2

inherit

	EQA_TEST_SET
		redefine
			on_prepare
		end

feature -- creazione istanza di List_Builder

	on_prepare
		do
			create list_builder.make (a_value, a_target, other_element_1, other_element_2)
		end

feature -- parametri

	list_builder: LIST_BUILDER

	a_value: INTEGER = 1

	a_target: INTEGER = 2

	other_element_1: INTEGER = 5

	other_element_2: INTEGER = 7

feature

	count_of
			-- già nelle postcondizioni della feature ci garantisce che se l'elemento non c'è il risultato è 0, quindi ci saranno solo test su quante istanze effettivamente conta
		do
			-- t_count_one_start
			assert ("ha contato più di un'istanza rispetto a quella iniziale", (list_builder.list_Ve1e2).count_of (a_value) = 1)
			-- t_count_one_end
			-- un valore solo alla fine
			assert ("ha contato più di un'istanza rispetto a quella finale", (list_builder.list_e1e2V).count_of (a_value) = 1)
			-- t_count_middle
			-- un valore solo in mezzo
			assert ("ha contato più di un'istanza rispetto a quella in mezzo", (list_builder.list_e1Ve2).count_of (a_value) = 1)
			-- t_count_multiple
			-- valori misti
			assert ("ha contato poche volte", (list_builder.list_VVe1).count_of (a_value) >= 2)
			assert ("ha contato troppe volte", (list_builder.list_VVe1).count_of (a_value) <= 2)
		end

	count_of_before
		do
			-- t_count_of_before_no_good_value_first
			assert ("ha contato troppe volte", (list_builder.list_TV).count_of_before (a_value, a_target) = 0)
			-- t_count_of_before_no_good_value_middle
			assert ("ha contato troppe volte", (list_builder.list_e1TV).count_of_before (a_value, a_target) = 0)
			-- t_count_of_before_single
			assert ("ha contato poche volte", (list_builder.list_VTV).count_of_before (a_value, a_target) >= 1)
			assert ("ha contato troppe volte", (list_builder.list_VTV).count_of_before (a_value, a_target) <= 1)
			-- t_count_of_before_multiple_value
			assert ("ha contato poche volte", (list_builder.list_Ve1VTV).count_of_before (a_value, a_target) >= 2)
			assert ("ha contato troppe volte", (list_builder.list_Ve1VTV).count_of_before (a_value, a_target) <= 2)
			-- t_count_of_before_multiple_target
			assert ("ha contato poche volte", (list_builder.list_Ve1VTVT).count_of_before (a_value, a_target) >= 2)
			assert ("ha contato troppe volte", (list_builder.list_Ve1VTVT).count_of_before (a_value, a_target) <= 2)
		end

	count_of_after
		do
			--	t_count_of_after_no_good_value_last
			assert ("ha contato troppe volte", (list_builder.list_VT).count_of_after (a_value, a_target) = 0)
			--	t_count_of_after_no_good_value_middle
			assert ("ha contato troppe volte", (list_builder.list_VTe1).count_of_after (a_value, a_target) = 0)
			--	t_count_of_after_single
			assert ("ha contato poche volte", (list_builder.list_VTV).count_of_after (a_value, a_target) >= 1)
			assert ("ha contato troppe volte", (list_builder.list_VTV).count_of_after (a_value, a_target) <= 1)
			--	t_count_of_after_multiple_value
			assert ("ha contato poche volte", (list_builder.list_Ve1TVe2V).count_of_after (a_value, a_target) >= 2)
			assert ("ha contato troppe volte", (list_builder.list_Ve1TVe2V).count_of_after (a_value, a_target) <= 2)
			--	t_count_of_after_multiple_target
			assert ("ha contato poche volte", (list_builder.list_Ve1VTVTVe2).count_of_before (a_value, a_target) >= 2)
			assert ("ha contato troppe volte", (list_builder.list_Ve1VTVTVe2).count_of_before (a_value, a_target) <= 2)
		end

	highest
		do
			-- t__highest_one_element
			-- test con lista di un elemento
			assert ("errore il massimo non è il primo elemento", (list_builder.list_V).highest = a_value)
			--	t_highest_three_elements_fisrt
			-- test con lista di tre elementi e valore più alto all'inizio
			assert ("errore il massimo non è il primo elemento", (list_builder.list_VVmin1Vmin3).highest = a_value)
			--	t_highest_three_elements_last
			-- test con lista di tre elementi e valore più alto alla fine
			assert ("errore il massimo non è l'ultimo elemento", (list_builder.list_Vmin1Vmin4V).highest = a_value)
			--	t_highest_three_elements_middle
			-- test con lista di tre elementi e valore più alto in mezzo
			assert ("errore il massimo non è il secondo elemento", (list_builder.list_Vmin1VVmin4).highest = a_value)
		end

	sum_of_positive
		do
			--	t_sop_negative
			-- somma con elementi negativi
			assert ("ha sommato dei numeri negativi", (list_builder.list_minVabs_mine1abs_mine1abs).sum_of_positive = 0)
			--	t_sop_vuota
			-- somma con lista vuota
			assert ("ha sommato qualcosa anche se la lista è vuota", (list_builder.list_empty).sum_of_positive = 0)
			--	t_sop_positive
			-- somma con elementi positvi
			assert ("non ha svolto la somma positiva correttamente", (list_builder.list_Vabs_e1abs).sum_of_positive = a_value.abs + other_element_1.abs)
			--	t_sop_mixed
			-- somma con elementi misti
			assert ("non ha svolto la somma mista correttamente", (list_builder.list_Vabs_e1abs_minVabs).sum_of_positive = a_value.abs + other_element_1.abs)
		end

end
