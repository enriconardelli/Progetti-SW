note
	description: "Test per le feature di tipo remove_single_free."
	author: "Gianluca Pastorini"
	date: "05/04/23"
	revision: "$Revision$"

class
	REMOVE_SINGLE_FREE_TESTS

inherit

	STATIC_TESTS

feature -- supporto

	how_many (t: INT_LINKED_LIST; value: INTEGER): INTEGER
			-- return how many times `a_value' occurs in `t'
			-- è identica a count_of, solo che è una funzione esterna alla lista
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

feature -- remove_active
	-- Riccardo Malandruccolo, 2020/03/07

	a_value: INTEGER = 1

	t_remove_active_first
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value + 4)
			t.append (a_value + 2)
			t.start
			t.remove_active
			assert ("errore: non ha eliminato l'active_element", not t.has (a_value))
			assert ("errore: non ha eliminato esattamente un elemento", t.count = 2)
			assert ("errore: non è stato modificato l'active_element correttamente", t.active_element /= Void and attached t.active_element as ae implies ae.value = a_value + 4)
			assert ("errore: non è stato modificato il first_element correttamente", t.first_element /= Void and attached t.first_element as fe implies fe.value = a_value + 4)
			assert ("index è stato modificato anche se active è ancora il primo elemento", t.index = 1)
		end

	t_remove_active_last
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value + 4)
			t.append (a_value + 2)
			t.last
			t.remove_active
			assert ("errore: non ha eliminato l'active_element", not t.has (a_value + 2))
			assert ("errore: non ha eliminato esattamente un elemento", t.count = 2)
			assert ("errore: non è stato modificato l'active_element correttamente", t.active_element /= Void and attached t.active_element as ae implies ae.value = a_value + 4)
			assert ("errore: non è stato modificato il last_element correttamente", t.last_element /= Void and attached t.last_element as le implies le.value = a_value + 4)
			assert ("index non è stato modificato correttamente", t.index = 2)
		end

	t_remove_active_middle
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value + 4)
			t.append (a_value + 2)
			t.go_i_th (2)
			t.remove_active
			assert ("errore: non ha eliminato l'active_element", not t.has (a_value + 4))
			assert ("errore: non ha eliminato esattamente un elemento", t.count = 2)
			assert ("errore: non è stato modificato l'active_element correttamente", t.active_element /= Void and attached t.active_element as ae implies ae.value = a_value + 2)
			assert ("errore: è stato modificato last-element", t.last_element /= Void and attached t.last_element as le implies le.value = a_value + 2)
			assert ("errore: è stato modificato first-element", t.first_element /= Void and attached t.first_element as fe implies fe.value = a_value)
			assert ("index è stato modificato anche se active è rimasto il secondo elemento", t.index = 2)
		end

	t_remove_active_one_element
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.start
			t.remove_active
			assert ("errore: non ha eliminato l'active_element", not t.has (a_value))
			assert ("errore: non è stato modificato l'active_element correttamente", t.active_element = Void)
			assert ("errore: non è stato modificato il last_element correttamente", t.last_element = Void)
			assert ("errore: non è stato modificato il first_element correttamente", t.first_element = Void)
			assert ("index non è stato modificato correttamente", t.index = 0)
		end

feature -- remove_earliest
	--Maria Ludovica Sarandrea, 2021/04/03

	t_remove_earliest_one_element_no_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 2)
			t.remove_earliest (a_value)
			assert ("ha eliminato un elemento con il valore sbagliato", t.has (a_value - 2))
			assert ("ha eliminato un elemento anche se la lista non conteneva a_value", t.count = 1)
		end

	t_remove_earliest_one_element_single_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.start
			t.remove_earliest (a_value)
			assert ("non ha eliminato un elemento con il valore a_value", not t.has (a_value))
			assert ("non ha eliminato nessun elemento", t.count = 0)
			assert ("non ha spostato correttamente l'active_element", t.active_element = Void)
			assert ("non ha spostato correttamente il first_element", t.first_element = Void)
			assert ("non ha spostato correttamente il last_element", t.last_element = Void)
			assert ("non ha modificato correttamente index", t.index = 0)
		end

	t_remove_earliest_multiple_element_single_value_start
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value + 3)
			t.append (a_value - 3)
			t.start
			t.remove_earliest (a_value)
			assert ("non ha eliminato un elemento con il valore a_value", not t.has (a_value))
			assert ("non ha eliminato nessun elemento", t.count = 2)
			assert ("non ha spostato correttamente l'active_element", t.active_element /= Void and attached t.active_element as ae implies ae.value = a_value + 3)
			assert ("non ha spostato correttamente il first_element", t.first_element /= Void and attached t.first_element as fe implies fe.value = a_value + 3)
			assert ("ha modificato index nonostante active sia ancora il primo elemento", t.index = 1)
		end

	t_remove_earliest_multiple_element_single_value_last
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 3)
			t.append (a_value + 3)
			t.append (a_value)
			t.last
			t.remove_earliest (a_value)
			assert ("non ha eliminato un elemento con il valore a_value", not t.has (a_value))
			assert ("non ha eliminato nessun elemento", t.count = 2)
			assert ("non ha spostato correttamente l'active_element", t.active_element /= Void and attached t.active_element as ae implies ae.value = a_value + 3)
			assert ("non ha spostato correttamente il last_element", t.last_element /= Void and attached t.last_element as le implies le.value = a_value + 3)
			assert ("non ha modificato correttamente index", t.index = 2)
		end

	t_remove_earliest_multiple_element_single_value_middle
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 3)
			t.append (a_value)
			t.append (a_value + 3)
			t.go_i_th (2)
			t.remove_earliest (a_value)
			assert ("non ha eliminato un elemento con il valore a_value", not t.has (a_value))
			assert ("non ha eliminato nessun elemento", t.count = 2)
			assert ("non ha spostato correttamente l'active_element", t.active_element /= Void and attached t.active_element as ae implies ae.value = a_value + 3)
			assert ("ha modificato index nonostante active sia ancora il secondo elemento", t.index = 2)
		end

	t_remove_earliest_multiple_element_two_value_last
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 3)
			t.append (a_value)
			t.append (a_value)
			t.go_i_th (2)
			t.remove_earliest (a_value)
			assert ("ha tolto tutti i valori con a_value", t.has (a_value))
			assert ("non ha eliminato nessun elemento", t.count = 2)
			assert ("non ha spostato correttamente l'active_element", t.active_element /= Void and attached t.active_element as ae implies ae.value = a_value)
			assert ("ha modificato index nonostante active sia ancora il secondo elemento", t.index = 2)
		end

	t_remove_earliest_multiple_element_two_value_first
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value - 2)
			t.append (a_value)
			t.append (a_value - 3)
			t.start
			t.remove_earliest (a_value)
			assert ("ha tolto tutti i valori con a_value", t.has (a_value))
			assert ("non ha eliminato nessun elemento", t.count = 3)
			assert ("non ha spostato correttamente l'active_element", t.active_element /= Void and attached t.active_element as ae implies ae.value = a_value - 2)
			assert ("ha modificato index nonostante active sia ancora il primo elemento", t.index = 1)
			assert ("non ha aggiornato correttamente first_element", t.first_element /= Void and attached t.first_element as fe implies fe.value = a_value - 2)
			assert ("non ha lasciato inalterato il secondo elemento contenente a_value", t.value_after (a_value, a_value - 2) and t.value_before (a_value, a_value - 3))
		end

feature -- remove_latest

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
