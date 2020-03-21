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

	t_misto_1
		local
			t: INT_LINKED_LIST
			count, old_count: INTEGER
			sum, old_sum: INTEGER
			a_value, target: INTEGER
		do
			a_value := 8
			target := 6
			create t

			t.append (a_value)
			t.start
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
			assert("ha cancellato tutti gli a_value",  t.has(a_value))
			assert("non ho aggiornato active_element",  attached t.active_element as ae and then ae.value = 3)
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

	t_misto_2
		local
			t, t_inv: INT_LINKED_LIST
			a_value, target: INTEGER
		do
			a_value := 1
			target := 10
			create t

			t.append (a_value)
			t.start
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

	t_misto_3
		local
			t: INT_LINKED_LIST
			count, old_count: INTEGER
			a_value, target: INTEGER
		do
			a_value := 71
			target := 10
			create t
			
			t.append (1)
			t.start
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
