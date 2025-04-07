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
			create a_list_builder
		end

feature -- parametri

	a_list_builder: LIST_BUILDER

feature -- test

	t_count_of
			-- già nelle postcondizioni della feature ci garantisce che se l'elemento non c'è il risultato è 0, quindi ci saranno solo test su quante istanze effettivamente conta
		do
			-- un valore solo all'inizio
			assert ("ha contato più di un'istanza rispetto a quella iniziale", (a_list_builder.list_Ve1e2).count_of (a_list_builder.a_value) = 1)
			-- un valore solo alla fine
			assert ("ha contato più di un'istanza rispetto a quella finale", (a_list_builder.list_e1e2V).count_of (a_list_builder.a_value) = 1)
			-- un valore solo in mezzo
			assert ("ha contato più di un'istanza rispetto a quella in mezzo", (a_list_builder.list_e1Ve2).count_of (a_list_builder.a_value) = 1)
			-- valori misti
			assert ("ha contato poche volte", (a_list_builder.list_VVe1).count_of (a_list_builder.a_value) >= 2)
			assert ("ha contato troppe volte", (a_list_builder.list_VVe1).count_of (a_list_builder.a_value) <= 2)
		end

	t_count_of_before
		do
			assert ("ha contato troppe volte", (a_list_builder.list_TV).count_of_before (a_list_builder.a_value, a_list_builder.a_target) = 0)
			assert ("ha contato troppe volte", (a_list_builder.list_e1TV).count_of_before (a_list_builder.a_value, a_list_builder.a_target) = 0)
			assert ("ha contato poche volte", (a_list_builder.list_VTV).count_of_before (a_list_builder.a_value, a_list_builder.a_target) >= 1)
			assert ("ha contato troppe volte", (a_list_builder.list_VTV).count_of_before (a_list_builder.a_value, a_list_builder.a_target) <= 1)
			assert ("ha contato poche volte", (a_list_builder.list_Ve1VTV).count_of_before (a_list_builder.a_value, a_list_builder.a_target) >= 2)
			assert ("ha contato troppe volte", (a_list_builder.list_Ve1VTV).count_of_before (a_list_builder.a_value, a_list_builder.a_target) <= 2)
			assert ("ha contato poche volte", (a_list_builder.list_Ve1VTVT).count_of_before (a_list_builder.a_value, a_list_builder.a_target) >= 2)
			assert ("ha contato troppe volte", (a_list_builder.list_Ve1VTVT).count_of_before (a_list_builder.a_value, a_list_builder.a_target) <= 2)
		end

	t_count_of_after
		do
			assert ("ha contato troppe volte list_VT", (a_list_builder.list_VT).count_of_after (a_list_builder.a_value, a_list_builder.a_target) = 0)
			assert ("ha contato troppe volte list_VTe1", (a_list_builder.list_VTe1).count_of_after (a_list_builder.a_value, a_list_builder.a_target) = 0)
			assert ("ha contato poche volte list_VTV", (a_list_builder.list_VTV).count_of_after (a_list_builder.a_value, a_list_builder.a_target) >= 1)
			assert ("ha contato troppe volte list_VTV", (a_list_builder.list_VTV).count_of_after (a_list_builder.a_value, a_list_builder.a_target) <= 1)
			assert ("ha contato poche volte list_Ve1TVe2V", (a_list_builder.list_Ve1TVe2V).count_of_after (a_list_builder.a_value, a_list_builder.a_target) >= 2)
			assert ("ha contato troppe volte list_Ve1TVe2V", (a_list_builder.list_Ve1TVe2V).count_of_after (a_list_builder.a_value, a_list_builder.a_target) <= 2)
			assert ("ha contato poche volte list_Ve1VTVTVe2", (a_list_builder.list_Ve1VTVTVe2).count_of_before (a_list_builder.a_value, a_list_builder.a_target) >= 2)
			assert ("ha contato troppe volte list_Ve1VTVTVe2", (a_list_builder.list_Ve1VTVTVe2).count_of_before (a_list_builder.a_value, a_list_builder.a_target) <= 2)
		end

	t_highest
		do

			-- test con lista di un elemento
			assert ("errore il massimo non è il primo elemento", (a_list_builder.list_V).highest = a_list_builder.a_value)
			-- test con lista di tre elementi e valore più alto all'inizio
			assert ("errore il massimo non è il primo elemento", (a_list_builder.list_VVless1Vless3).highest = a_list_builder.a_value)
			-- test con lista di tre elementi e valore più alto alla fine
			assert ("errore il massimo non è l'ultimo elemento", (a_list_builder.list_Vless1Vless4V).highest = a_list_builder.a_value)
			-- test con lista di tre elementi e valore più alto in mezzo
			assert ("errore il massimo non è il secondo elemento", (a_list_builder.list_Vless1VVless4).highest = a_list_builder.a_value)
		end

	t_sum_of_positive
		do
			-- somma con elementi negativi
			assert ("ha sommato dei numeri negativi", (a_list_builder.list_negabsV_negabse1_negabse1).sum_of_positive = 0)
			-- somma con lista vuota
			assert ("ha sommato qualcosa anche se la lista è vuota", (a_list_builder.list_empty).sum_of_positive = 0)
			-- somma con elementi positvi
			assert ("non ha svolto la somma positiva correttamente", (a_list_builder.list_absV_abse1).sum_of_positive = a_list_builder.a_value.abs + a_list_builder.other_element_1.abs)
			-- somma con elementi misti
			assert ("non ha svolto la somma mista correttamente", (a_list_builder.list_absV_abse1_negabsV).sum_of_positive = a_list_builder.a_value.abs + a_list_builder.other_element_1.abs)
		end

end
