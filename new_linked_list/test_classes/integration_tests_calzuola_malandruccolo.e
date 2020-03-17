note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	INTEGRATION_TESTS_CALZUOLA_MALANDRUCCOLO

inherit
	STATIC_TESTS

feature -- Test routines

	t_lista_vuota
		local
			t_vuota: INT_LINKED_LIST
			a_value: INTEGER
		do
			create t_vuota
			a_value := 1
			assert("has trova il valore su lista vuota", not t_vuota.has(a_value))
			assert("get_element restituisce un elemento su lista vuota", t_vuota.get_element (a_value) = void)
			assert("la lista non è vuota", t_vuota.count = 0)
		end

	t_lista_un_elemento
		local
			t_one_element: INT_LINKED_LIST
			a_value: INTEGER
			a_different: INTEGER
		do
			a_value:= 7
			a_different:= 9
			create t_one_element
			t_one_element.append (a_value)
			assert("non ho aggiunto il valore corretto", t_one_element.has(a_value) and not t_one_element.has(a_different))
			assert("non ho una lista con un elemento", t_one_element.count = 1)
			assert("first_element diverso da last_element", t_one_element.first_element = t_one_element.last_element)
			assert("first_element diverso da a_value", attached t_one_element.first_element as fe and then fe.value = a_value)
			assert("last_element diverso da a_value", attached t_one_element.last_element as le and then le.value = a_value)
			assert("restituisce un void ma dovrebbe restituire a_value", t_one_element.get_element(a_value) /= void)
			assert("non restituisce a_value", attached t_one_element.get_element(a_value) as ge and then ge.value = a_value)
			assert("ho un valore che non dovrei avere", t_one_element.get_element(a_different) = void)
		end

	t_lista_due_elementi
		local
			t_due: INT_LINKED_LIST
			a_value : INTEGER
		do
			create t_due
			a_value := 1
			t_due.append(a_value)
			t_due.append (2*a_value)
			assert("has non trova il valore", t_due.has (a_value))
			assert("get_element non trova l'elemento", t_due.get_element (a_value) /= void)
			assert("la lista non ha due elementi", t_due.count = 2)
			assert("il first_element non è impostato correttamente", attached t_due.first_element as fe and then fe.value = a_value)
			assert("il last_element non è impostato correttamente", attached t_due.last_element as le and then le.value = 2*a_value)
		end

	t_remove
		do
			t_remove_preceding(1,10)
			t_remove_following(71,10)
			t_remove_target_equals_value(1,1)
		end

	t_misti
		do
			t_misto_1(8,6)
			t_misto_2(1,10)
			t_misto_3(71,10)
		end

	t_remove_preceding(a_value,target: INTEGER)
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (2)
			t.append (a_value)
			t.append (3)
			t.append (target)

			t.remove_earliest_preceding (a_value, target)
			assert("non ha rimosso il primo valore prima di target", attached t.first_element as fe and then fe.value = 2)
			assert("ha rimosso più elementi", t.has (a_value))

			t.prepend (a_value)
			t.remove_latest_preceding (a_value, target)
			assert("ha rimosso il primo elemento", attached t.first_element as fe and then fe.value = a_value)

			t.append (2)
			t.append (a_value)
			t.append (3)
			t.prepend (a_value)
			t.remove_all_preceding (a_value, target)
			assert("non ha rimosso solo i precedenti", t.has (a_value))
			assert("il count di a_value è sbagliato", how_many(t,a_value) = 1)
		end

	t_remove_following(a_value,target: INTEGER)
		local
			t:INT_LINKED_LIST
			old_count, count : INTEGER
		do
			create t
			t.append (a_value)
			t.append (3)
			t.append (target)
			t.append (a_value)
			t.last
			-- t = [a_value,3,target,a_value]

			t.remove_earliest_following (a_value, target)
			assert("ha rimosso il primo a_value", attached t.first_element as fe and then fe.value = a_value)
			assert("non ha rimosso a_value dopo target", attached t.last_element as le and then le.value = target)
			assert("non ha cambiato active_element", attached t.active_element as ae and then ae.value = target)
			t.append(5)
			t.append (a_value)
			t.append (9)
			t.append (a_value)
			-- t = [a_value,3,target,5,a_value,9,a_value]

			old_count := how_many(t,a_value)
			t.remove_latest_following (a_value, target)
		    count := how_many(t,a_value)
			assert("non ha rimosso l'ultimo a_value dopo target", attached t.last_element as le and then le.value = 9)
			assert("non ha rimosso a_value", old_count - count = 1)
			-- t = [a_value,3,target,5,a_value,9]

			t.append(a_value)
			-- t = [a_value,3,target,5,a_value,9,a_value]
			old_count := how_many(t,a_value)
			t.remove_all_following (a_value, target)
			count := how_many(t,a_value)
			assert("non ha rimosso a_value dopo target", old_count - count = 2)
			assert("ha rimosso il primo a_value", attached t.first_element as fe and then fe.value = a_value)
			-- t = [a_value,3,target,5,9]
		end

	t_remove_target_equals_value(a_value,target: INTEGER)
		local
			t: INT_LINKED_LIST
			count_prima: INTEGER
			count_dopo: INTEGER
		do
			create t

			t.append (2)
			t.append (a_value)
			t.append (3)
			t.append (target)
			t.append (a_value)
			t.append (2)
			t.append (a_value)

			count_prima := how_many(t,a_value)
			t.remove_all_preceding (a_value, target)
			t.remove_latest_preceding (a_value, target)
		--	t.remove_earliest_preceding (a_value, target)
		--  problema con a_value = target
			count_dopo := how_many(t,a_value)
			assert("qualche elemento è stato eliminato", count_prima = count_dopo)

			count_prima := how_many(t,a_value)
			t.remove_earliest_following (a_value, target)
			count_dopo := how_many(t,a_value)
			assert("non ha eliminato il singolo elemento", count_prima = count_dopo + 1)
			assert("non ha eliminato l'elemento giusto", (attached t.get_element (a_value) as ge and then attached ge.next as gen) and then gen.value = 3)
			t.remove_latest_following (a_value, target)
			assert("ha rimosso l'elemento sbagliato", attached t.last_element as le and then le.value = 2)

			t.remove_all_following (a_value, target)
			assert("non ha eliminato tutti gli elementi successivi al target", how_many(t,a_value) = 1)
		end

	t_misto_1(a_value,target: INTEGER)
		local
			t: INT_LINKED_LIST
			count, old_count: INTEGER
			sum, old_sum: INTEGER
		do
			create t
			t.append (a_value)
			t.append (1)
			t.append (8)
			assert("value_follows ha trovato a_value dopo target ma il target non è presente nella lista", not t.value_follows(a_value, target))
			t.append (target)
			t.append (2)
			t.append (a_value)
			assert("non ha trovato a_value dopo target", t.value_follows(a_value, target))

			t.last
			t.append (3)
			assert("last non punta ad a_value", attached t.active_element as ae and then ae.value = a_value)
			assert("last non punta ad a_value", attached t.active_element as ae and then attached ae.next as aen and then aen.value = 3)
			old_count := how_many(t, a_value)

			t.remove_latest (a_value)
			count := how_many(t, a_value)
			assert("non ho cancellato a_value nonostante ci sia un a_value dopo target", old_count - count = 1)
			assert("non ha cancellato a_value dopo target", not t.value_follows(a_value, target))
			-- assert("non ha cancellato tutti gli a_value",  t.has(a_value))
			-- assert("non ho aggiornato active_element",  attached t.active_element as ae and then ae.value /= a_value)
			-- non viene aggiornato active_element nella feature latest
			assert("non ha inserito l'elemento all'inizio", attached t.first_element as fe and then fe.value = a_value)

			old_sum := t.sum_of_positive
			assert("la somma è negativa", sum <= 0)
			t.append (3)
			sum := t.sum_of_positive
			assert("non ha aggiunto la il numero corretto", sum - old_sum = 3)
			old_sum := t.sum_of_positive
			t.append (-5)
			sum := t.sum_of_positive
			assert("ha considerato anche un numero negativo", old_sum - sum = 0)

		end

	t_misto_2(a_value,target: INTEGER)
		local
			t, t_inv: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (2)
			t.append (3)
			t.append (target)
			t.append (3)
			t.prepend (a_value)
			-- t = [a_value,a_value,2,3,target,3]

			t_inv := t.deep_twin
			t_inv.invert
			-- t_inv = [3,target,3,2,a_value,a_value]
			assert("invert non inverte la lista", (attached t.first_element as fe and attached t_inv.last_element as le) and then fe.value = le.value)
			assert("le liste hanno dimensioni diverse", t.count = t_inv.count)

			t.remove_earliest_preceding (a_value, target)
			assert("non è stato rimosso il valore", how_many(t,a_value) = 1)
			t_inv.remove_latest_preceding (a_value, target)
			assert("è stato rimosso il valore", how_many(t_inv,a_value) = 2)
			t_inv.remove_latest_following (a_value, target)
			assert("non è stato rimosso il valore", how_many(t_inv,a_value) = 1)

			t_inv.wipeout
			assert("non ha svuotato la lista", t_inv.first_element = void and t_inv.last_element = void)

			-- t = [a_value,2,3,target,3]
			t.insert_after (target, target)
			assert("non è stato aggiunto l'elemento", how_many(t,target) = 2)
			t.insert_multiple_before (5, target)
			-- t = [a_value,2,3,5,target,5,target,3]
			assert("non sono stati aggiunti i valori", how_many(t,5) = 2)
			assert("non è stato aggiunto il valore nel posto giusto",attached t.get_element(5) as ge and then attached ge.next as gen and then gen.value = target)

			t.start
			t.remove_active
			-- t = [a_value,2,3,5,target,5,target,3]
			assert("non è stato rimosso il valore", how_many(t,a_value)=0)
			assert("non è stato spostato il first_element", attached t.first_element as fe and then fe.value = 2)
			t.insert_before (a_value, 2)
			assert("non è stato spostato il first_element", attached t.first_element as fe and then fe.value = a_value)
		end

	t_misto_3(a_value,target: INTEGER)
		local
			t: INT_LINKED_LIST
			count, old_count: INTEGER
		do
			create t
			t.append (1)
			t.append (8)
			assert("value_follows ha trovato a_value dopo target ma il target non è presente nella lista", not t.value_follows(a_value, target))
			t.append (target)
			old_count := t.count
			t.insert_after(a_value, target)
			count := t.count
			assert("non ha aggiunto a_value dopo target", count - old_count = 1)
			assert("non ha modificato last_element", attached t.last_element as le and then le.value = a_value)

			t.prepend(target)
			t.append (target)
			old_count := t.count
			t.insert_multiple_before(a_value, target)
			count := t.count
			assert("non ha aggiunto tutti gli a_value", count - old_count = how_many(t, target))
			assert("non ha cambiato first_elementt", attached t.first_element as fe and then fe.value = a_value)

			t.wipeout
			assert("non ha svuotato", t.count = 0)
			assert("non ha cambiato first_element", t.first_element = void)
			assert("non ha cambiato last_element", t.last_element = void)

		end
end
