note
	description: "Test per le feature del tipo remove single targeted"
	author: "Gianluca Pastorini"
	date: "12/04/23"
	revision: "$Revision$"

class
	REMOVE_SINGLE_TARGETED_TESTS

inherit

	STATIC_TESTS

feature -- supporto

	a_value: INTEGER = 2

	a_target: INTEGER = 7
			-- ATTENZIONE NON INSERIRE a_target=2*a_value/3*a_value/4*a_value per come sono scritti i test

	how_many_following_a_value_after_target (t: INT_LINKED_LIST; value, target: INTEGER): INTEGER
			-- return how many times `a_value' occurs in `t' following target
		local
			current_element: INT_LINKABLE
			target_found: BOOLEAN
		do
			if t.count < 2 then
				Result := 0
			else
				from
					current_element := t.first_element
				until
					current_element = Void
				loop
					if attached current_element then
						if current_element.value = target then
							target_found := true
						end
						if current_element.value = value and target_found then
							Result := Result + 1
						end
					end
					current_element := current_element.next
				end
			end
		end

	how_many_before (t: INT_LINKED_LIST; value, target: INTEGER): INTEGER
			--ci dice quante occorrenze di value prima di target ci sono nella lista
		require
			ha_almeno_target: t.has (target)
		local
			current_element: INT_LINKABLE
			count: INTEGER
		do
			Result := 0
			from
				current_element := t.first_element
			until
				current_element = t.get_element (target)
			loop
				if attached current_element as ce then
					if ce.value = value then
						Result := Result + 1
					end
					current_element := current_element.next
				end
			end
		ensure
			ha_contato_qualche_a_value_presente: t.value_follows (target, value) implies Result > 0
			non_ha_contato_se_non_presente: not (t.value_follows (target, value)) implies Result = 0
		end

feature -- remove_earliesr_following
	-- Arianna Calzuola 2020/03/12

	t_remove_earliest_following_a_value_before_target
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_target)
			t.remove_earliest_following (a_value, a_target)
			assert ("rimosso elemento ma a_value era prima di target", t.has (a_value))
		end

	t_remove_earliest_following_two_elements
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target)
			t.append (a_value)
			t.remove_earliest_following (a_value, a_target)
			assert ("non ha rimosso a_value", not t.has (a_value))
			assert ("non ha modificato last_element", attached t.last_element as le and then le.value = a_target)
		end

	t_remove_earliest_following_a_value_equal_target
		local
			t: INT_LINKED_LIST
			count: INTEGER
		do
			create t
			t.append (a_value)
			t.append (3 * a_value)
			t.append (a_value)
			count := t.count
			t.remove_earliest_following (a_value, a_value)
			assert ("ha eliminato sia il target che a_value", t.count = count - 1)
			assert ("non ha eliminato a_value giusto", attached t.first_element as fe and then fe.value = a_value)
		end

	t_remove_earliest_following_two_a_value
		local
			t: INT_LINKED_LIST
			old_count, new_count: INTEGER
		do
			create t
			t.append (a_target)
			t.append (4 * a_value)
			t.append (a_value)
			t.append (2 * a_value)
			t.append (3 * a_value)
			t.append (a_value)
			old_count := how_many_following_a_value_after_target (t, a_value, a_target)
			t.remove_earliest_following (a_value, a_target)
			new_count := how_many_following_a_value_after_target (t, a_value, a_target)
			assert ("ha tolto tutti gli a_value", old_count - new_count = 1)
			assert ("ha tolto a_value giusto", attached t.last_element as le implies le.value = a_value)
		end

feature -- remove_earliest_preciding
	--Claudia Agulini

	t_remove_earliest_preciding_no_value_two_elements
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
			assert ("errore: lista di due elementi non contiene value", count_prima = count_dopo)
		end

	t_remove_earliest_preciding_no_value_three_elements
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
			assert ("errore: lista di tre elementi non contiene value", count_prima = count_dopo)
		end

	t_remove_earliest_preciding_value_first_two_elements
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
			assert ("errore: count prima e dopo scorretto", count_prima = count_dopo + 1)
			assert ("errore: rimosso elemento sbagliato in testa", attached t.first_element as fe implies fe.value /= a_value)
		end

	t_remove_earliest_preciding_value_first_three_elements
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
			assert ("errore: count prima e dopo scorretto", count_prima = count_dopo + 1)
			assert ("errore: rimosso elemento sbagliato in testa", attached t.first_element as fe implies fe.value /= a_value)
		end

	t_remove_earliest_preciding_multiple_values
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
			count_prima := how_many (t, a_value)
			t.remove_earliest_preceding (a_value, a_value + 3)
			count_dopo := how_many (t, a_value)
			assert ("errore: lista con più occorrenze di value", count_dopo = count_prima - 1)
		end

	t_remove_earliest_preciding_same_value_target
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.append (a_value + 1)
			t.append (a_value + 2)
			count_prima := how_many (t, a_value + 1)
			t.remove_earliest_preceding (a_value + 1, a_value + 1)
			count_dopo := how_many (t, a_value + 1)
			assert ("errore: count prima e dopo scorretto", count_prima = count_dopo)
		end

	t_remove_earliest_preciding_multiple_value_first
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.append (a_value + 1)
			t.append (a_value)
			t.append (a_value + 2)
			count_prima := how_many (t, a_value)
			t.remove_earliest_preceding (a_value, a_value + 2)
			count_dopo := how_many (t, a_value)
			assert ("errore: count prima e dopo scorretto", count_prima = count_dopo + 1)
			assert ("errore: rimosso elemento sbagliato in testa", attached t.first_element as fe implies fe.value /= a_value)
		end

	t_remove_earliest_preciding_multiple_target
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (a_value + 4)
			t.append (a_value + 1)
			t.append (a_value)
			t.append (a_value + 1)
			count_prima := how_many (t, a_value)
			t.remove_earliest_preceding (a_value, a_value + 1)
			count_dopo := how_many (t, a_value)
			assert ("errore: count prima e dopo scorretto", count_prima = count_dopo)
		end

feature -- remove_latest_following
	-- Alessandro Filippo

	t_remove_latest_following_lista_senza_value
		local
			t: INT_LINKED_LIST
			s: INTEGER
		do
			create t
			t.append (a_value + 1)
			t.append (a_value + 3)
			t.append (a_value + 2)
			s := how_many (t, a_value)
			t.remove_latest_following (a_value, a_value + 3)
			assert ("Nella lista non c'è a_value", s = how_many (t, a_value))
		end

	t_remove_latest_following_con_value_dopo_target
			--la funzione deve partire dal primo target che trova e togliere l'ultimo a_value
		local
			t: INT_LINKED_LIST
			l, k_1, k_2: INTEGER
		do
			create t
			k_1 := a_value + a_target + 1
			k_2 := a_value + a_target + 2
			t.append (a_value) --non deve toglierlo
			t.append (a_target) --qui ho il mio a_target
			t.append (a_value) --non deve toglierlo
			t.append (a_target) --se ci sono anche più a_target?
			t.append (k_1)
			t.append (a_value) --deve togliere questo
			t.append (k_2)
			l := how_many (t, a_value) --conto quanti ci sono all'inizio
			t.remove_latest_following (a_value, a_target)
			assert ("E' stata rimossa una occorrenza di val", how_many (t, a_value) = l - 1)
			assert ("E' stata tolta quella giusta", attached t.get_element (k_1) as t1 implies t1.next = t.get_element (k_2))
		end

	t_remove_latest_following_con_value_prima_di_target
			--la funzione deve partire dal primo a_target che trova e togliere l'ultimo a_value
		local
			t: INT_LINKED_LIST
			l, k_1: INTEGER
		do
			create t
			k_1 := a_value + a_target + 1
			t.append (k_1)
			t.append (a_value) --non deve toglierlo
			t.append (a_target) --qui ho il mio a_target
			t.append (k_1)
			l := how_many (t, a_value) --conto quanti ci sono all'inizio
			t.remove_latest_following (a_value, a_target)
			assert ("Non è stata rimossa una occorrenza di val", l = how_many (t, a_value))
		end

	t_remove_latest_following_con_active_e_last
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target + 2)
			t.append (a_target)
			t.append (a_value)
			t.last -- l'active e il last valgono value
			t.remove_latest_following (a_value, a_target)
			assert ("ERRORE: cattiva gestione di active", t.active_element /= Void and then attached t.active_element as te implies te.value = a_target)
			assert ("ERRORE: cattiva gestione di last", t.last_element /= Void and then attached t.last_element as le implies le.value = a_target)
		end

feature -- remove_latest_preceding
	--Federico Fiorini

	t_remove_latest_preceding_only_one_element
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (34)
			if t.has (a_target) then
				t.remove_latest_preceding (a_value, a_target)
			end
			assert ("Errore: cambiato numero di elementi di una lista con un solo", t.count = 1)
			assert ("Errore: tolto un elemento, ma la lista aveva solo quello", not (t.count = 0))
		end

	t_remove_latest_preceding_no_value
		local
			t: INT_LINKED_LIST
			values, values_before: INTEGER
		do
			create t
			t.append (a_value + 1)
			t.append (a_value + 2)
			t.append (a_value + 3)
			t.append (a_value - 1)
			t.append (a_value)
				--a_value-1 svolgerà il ruolo di target
			values := how_many (t, a_value)
			values_before := how_many_before (t, a_value, a_value - 1)
			t.remove_latest_preceding (a_value, a_value - 1)
				--l' unica ricorrenza è dopo target, non dovrebbe essere rimossa
			assert ("errore: la lista non conteneva a_value prima di target, ma è stato rimosso qualche elemento", values = how_many (t, a_value))
			assert ("errore: c' era un a_value, ma non è stato contato correttamente", values = 1)
			assert ("errore: non c' erano a_value prima del target, ma non sono stati contati correttamente", values_before = 0)
		end

	t_remove_latest_preceding_single_value_first
		local
			t: INT_LINKED_LIST
			s: INTEGER
		do
			create t
			t.append (a_value)
			t.append (a_value + 1)
			t.append (a_value + 2)
			t.append (a_value - 1)
			t.append (a_value)
			s := how_many (t, a_value)
			t.remove_latest_preceding (a_value, a_value - 1)
			assert ("errore: gli elementi non sono stati rimossi correttamente", s = how_many (t, a_value) + 1)
			assert ("errore: il primo elemento è ancora a_value", attached t.first_element as fe implies fe.value /= a_value)
			assert ("errore: è stato rimosso un elemento dopo target", attached t.last_element as le implies le.value = a_value)
		end

	t_remove_latest_preceding_single_value_middle
		local
			t: INT_LINKED_LIST
			s: INTEGER
		do
			create t
			t.append (a_value + 2)
			t.append (a_value)
			t.append (a_value + 1)
			t.append (a_value - 1)
			t.append (a_value)
			s := how_many (t, a_value)
			t.remove_latest_preceding (a_value, a_value - 1)
			assert ("errore: gli elementi non sono stati rimossi correttamente", s = how_many (t, a_value) + 1)
			assert ("errore: è stato rimosso un elemento dopo target", attached t.last_element as le implies le.value = a_value)
		end

	t_remove_latest_preceding_multiple_value
		local
			t: INT_LINKED_LIST
			s: INTEGER
		do
			create t
			t.append (a_value)
			t.append (a_value + 2)
			t.append (a_value)
			t.append (a_value + 1)
			t.append (a_value - 1)
			t.append (a_value)
			t.append (a_value - 1)
			t.append (a_value)
			s := how_many (t, a_value)
			t.remove_latest_preceding (a_value, a_value - 1)
			assert ("errore: gli elementi non sono stati rimossi correttamente", s = how_many (t, a_value) + 1)
			assert ("errore: è stato rimosso un elemento dopo target", attached t.last_element as le implies le.value = a_value)
			t.remove_latest_preceding (a_value, a_value - 1)
			assert ("errore: gli elementi non sono stati rimossi correttamente", s = how_many (t, a_value) + 2)
			assert ("errore: il primo elemento è ancora a_value", attached t.first_element as fe implies fe.value /= a_value)
			assert ("errore: è stato rimosso un elemento dopo target", attached t.last_element as le implies le.value = a_value)
			t.remove_latest_preceding (a_value, a_value - 1)
			assert ("errore: è stato rimosso qualche a_value, ma non dovrebbero essercene più", s = how_many (t, a_value) + 2)
			assert ("errore: il primo elemento è ancora a_value", attached t.first_element as fe implies fe.value /= a_value)
			assert ("errore: è stato rimosso un elemento dopo target", attached t.last_element as le implies le.value = a_value)
		end

end
