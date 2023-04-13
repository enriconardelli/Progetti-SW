note
	description: "Test di tipo Integration"
	author: "Gianluca Pastorini"
	date: "07/04/23"
	revision: "$Revision$"

class
	INTEGRATION_TESTS

inherit

	STATIC_TESTS

feature -- servizio

		-- parte di AGULINI_FIORINI

		-- TO DO: le funzioni di supporto how_many/how_many_after/how_many_before possono essere sostituite dalle feature interne
		-- di INT_LINKED_LIST count_of/count_of_after/count_of_before

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

	how_many_before (t: INT_LINKED_LIST; a_value, target: INTEGER): INTEGER
			--ci dice quante occorrenze di value prima di target ci sono nella lista
		require
			ha_almeno_target: t.has (target)
		local
			current_element: INT_LINKABLE
		do
			Result := 0
			from
				current_element := t.first_element
			until
				current_element = t.get_element (target)
			loop
				if attached current_element as ce then
					if ce.value = a_value then
						Result := Result + 1
					end
					current_element := current_element.next
				end
			end
		ensure
			ha_contato_qualche_a_value_presente: t.value_follows (target, a_value) implies Result > 0
			non_ha_contato_se_non_presente: not (t.value_follows (target, a_value)) implies Result = 0
		end

	how_many_after (t: INT_LINKED_LIST; a_value, target: INTEGER): INTEGER
			--ci dice quante occorrenze di value dopo target ci sono nella lista
		require
			ha_almeno_target: t.has (target)
		local
			current_element: INT_LINKABLE
		do
			Result := 0
			from
				current_element := t.get_element (target)
			until
				current_element = Void
			loop
				if attached current_element as ce then
					if ce.value = a_value and current_element /= t.get_element (target) then
						Result := Result + 1
					end
					current_element := current_element.next
				end
			end
		ensure
			ha_contato_qualche_a_value_presente: t.value_follows (a_value, target) implies Result > 0
			non_ha_contato_se_non_presente: not (t.value_follows (a_value, target)) implies Result = 0
		end

	check_is_last (t: INT_LINKED_LIST; a_value: INTEGER): BOOLEAN
			--controlla che a_value è l'ultimo
		do
			Result := t.last_element /= Void and then (attached t.last_element as le implies le.value = a_value)
		end

	check_is_active (t: INT_LINKED_LIST; a_value: INTEGER): BOOLEAN
			--controlla che a_value è l'active
		do
			Result := t.active_element /= Void and then (attached t.active_element as ae implies ae.value = a_value)
		end

	check_is_first (t: INT_LINKED_LIST; a_value: INTEGER): BOOLEAN
			--controlla se first_element punta a a_value
		do
			if t.first_element = Void then
				Result := False
			else
				if attached t.first_element as fe then
					if fe.value = a_value then
						Result := True
					else
						Result := False
					end
				end
			end
		end

feature -- test

	t_insert
			--alcuni test sulle feature di inserimento
		local
			t: INT_LINKED_LIST
		do
			create t
			t.prepend (1)
				--[1]
			assert ("Errore 1.1: il numero di elementi non è corretto", t.count = 1)
			assert ("Errore 1.2: first_element non è corretto", attached t.first_element as fe and then fe.value = 1)
			assert ("Errore 1.3: last_element non è corretto", attached t.last_element as le and then le.value = 1)
			t.start
				--[1] active element è 1
			assert ("Errore 2.1: active_element non è corretto", attached t.active_element as ae and then ae.value = 1)
			t.prepend (2)
				--[2,1] active element è 1
			assert ("Errore 3.1: il numero di elementi non è corretto", t.count = 2)
			assert ("Errore 3.2: first_element non è corretto", attached t.first_element as fe and then fe.value = 2)
			assert ("Errore 3.3: last_element non è corretto", attached t.last_element as le and then le.value = 1)
			assert ("Errore 3.4: active_element non è corretto", attached t.active_element as ae and then ae.value = 1)
			t.insert_after (3, -1) --inserisce 3 dopo -1
				--[2,1,3] active element è 1
			assert ("Errore 4.1: il numero di elementi non è corretto", t.count = 3)
			assert ("Errore 4.2: first_element non è corretto", attached t.first_element as fe and then fe.value = 2)
			assert ("Errore 4.3: last_element non è corretto", attached t.last_element as le and then le.value = 3)
			assert ("Errore 4.4: active_element non è corretto", attached t.active_element as ae and then ae.value = 1)
			t.insert_after (4, 1) --inserisce 4 dopo 1
			t.forth --scorro la lista
				--[2,1,4,3] active element è 4
			assert ("Errore 5.1: il numero di elementi non è corretto", t.count = 4)
			assert ("Errore 5.2: first_element non è corretto", attached t.first_element as fe and then fe.value = 2)
			assert ("Errore 5.3: last_element non è corretto", attached t.last_element as le and then le.value = 3)
			assert ("Errore 5.4: active_element non è corretto", attached t.active_element as ae and then ae.value = 4)
			t.insert_before (5, 2) --inserisce 5 prima di 2
				--[5,2,1,4,3] active element è 4
			assert ("Errore 6.1: il numero di elementi non è corretto", t.count = 5)
			assert ("Errore 6.2: first_element non è corretto", attached t.first_element as fe and then fe.value = 5)
			assert ("Errore 6.3: last_element non è corretto", attached t.last_element as le and then le.value = 3)
			assert ("Errore 6.4: active_element non è corretto", attached t.active_element as ae and then ae.value = 4)
			t.insert_after_CON_get_element_append (6, 4) --inserisce 6 dopo 4
				--[5,2,1,4,6,3] active element è 4
			assert ("Errore 7.1: il numero di elementi non è corretto", t.count = 6)
			assert ("Errore 7.2: first_element non è corretto", attached t.first_element as fe and then fe.value = 5)
			assert ("Errore 7.3: last_element non è corretto", attached t.last_element as le and then le.value = 3)
			assert ("Errore 7.4: active_element non è corretto", attached t.active_element as ae and then ae.value = 4)
			t.forth
				--[5,2,1,4,6,3] active element è 6
			assert ("Errore 8.1: active_element non è corretto", attached t.active_element as ae and then ae.value = 6)
			t.insert_after (7, 3)
				--[5,2,1,4,6,3,7] active element è 6
			assert ("Errore 9.1: il numero di elementi non è corretto", t.count = 7)
			assert ("Errore 9.2: first_element non è corretto", attached t.first_element as fe and then fe.value = 5)
			assert ("Errore 9.3: last_element non è corretto", attached t.last_element as le and then le.value = 7)
			assert ("Errore 9.4: active_element non è corretto", attached t.active_element as ae and then ae.value = 6)
			t.insert_after_CON_get_element_append (8, 8)
			t.forth
			t.forth
			t.forth
				--[5,2,1,4,6,3,7,8] active element è 8
			assert ("Errore 10.1: il numero di elementi non è corretto", t.count = 8)
			assert ("Errore 10.2: first_element non è corretto", attached t.first_element as fe and then fe.value = 5)
			assert ("Errore 10.3: last_element non è corretto", attached t.last_element as le and then le.value = 8)
			assert ("Errore 10.4: active_element non è corretto", attached t.active_element as ae and then ae.value = 8)
			t.insert_multiple_after_CON_has_append (9, 4) --inserisce 9 dopo ogni 4
			t.start
				--[5,2,1,4,9,6,3,7,8] active element è 5
			t.insert_multiple_after_CON_has_append (9, 8)
				--[5,2,1,4,9,6,3,7,8,9] active element è 5
			assert ("Errore 11.1: il numero di elementi non è corretto", t.count = 10)
			assert ("Errore 11.2: first_element non è corretto", attached t.first_element as fe and then fe.value = 5)
			assert ("Errore 11.3: last_element non è corretto", attached t.last_element as le and then le.value = 9)
			assert ("Errore 11.4: active_element non è corretto", attached t.active_element as ae and then ae.value = 5)
			t.insert_multiple_after_CON_has_append (9, 9)
				--[5,2,1,4,9,9,6,3,7,8,9,9] active element è 5
			assert ("Errore 12.1: il numero di elementi non è corretto", t.count = 12)
			assert ("Errore 12.2: first_element non è corretto", attached t.first_element as fe and then fe.value = 5)
			assert ("Errore 12.3: last_element non è corretto", attached t.last_element as le and then le.value = 9)
			assert ("Errore 12.4: active_element non è corretto", attached t.active_element as ae and then ae.value = 5)
			assert ("Errore 12.5: il numero di 9 non è quello che mi aspetto", how_many (t, 9) = 4)
			t.prepend (9)
			t.start
				--[9,5,2,1,4,9,9,6,3,7,8,9,9] active element è il primo 9
			t.insert_multiple_before (4, 9) --inserisco un 5 prima di ogni 9
				--[4,9,5,2,1,4,4,9,4,9,6,3,7,8,4,9,4,9] active element è il primo 9
			assert ("Errore 13.1: il numero di elementi non è corretto", t.count = 18)
			assert ("Errore 13.2: first_element non è corretto", attached t.first_element as fe and then fe.value = 4)
			assert ("Errore 13.3: last_element non è corretto", attached t.last_element as le and then le.value = 9)
			assert ("Errore 13.4: active_element non è corretto", attached t.active_element as ae and then ae.value = 9)
			assert ("Errore 13.5: il numero di 4 non è quello che mi aspetto", how_many (t, 4) = 6)
			t.wipeout
				--[]
			assert ("Errore 14.1: il numero di elementi non è corretto", t.count = 0)
			assert ("Errore 14.2: first_element non è corretto", t.first_element = Void)
			assert ("Errore 14.3: last_element non è corretto", t.last_element = Void)
			assert ("Errore 14.4: active_element non è corretto", t.active_element = Void)
		end

	t_remove
			-- test vari sulle feature di rimozione
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo, a_value, target: INTEGER
		do
			create t
			t.append (1)
			t.append (2)
			t.append (3)
				-- t = [1,2,3]; t.active_element.value = 1
			t.start
			t.remove_active -- t = [2,3], t.active_element.value = 2
			assert ("Errore 15.1: il numero di elementi non è corretto", t.count = 2)
			assert ("Errore 15.2: active element non aggiornato correttamente", attached t.active_element as ae and then ae.value = 2)
			assert ("Errore 15.3: first element non aggiornato correttamente", attached t.first_element as fe and then fe.value = 2)
			t.forth -- t.active_element.value = 3
			assert ("Errore 16: active element non aggiornato correttamente", attached t.active_element as ae and then ae.value = 3)
			t.prepend (4) -- t = [4, 2, 3]
			t.remove_active -- t = [4, 2]
			assert ("Errore 17.1: il numero di elementi non è corretto", t.count = 2)
			assert ("Errore 17.2: active element non aggiornato correttamente", attached t.active_element as ae and then ae.value = 2)
			assert ("Errore 17.3: last element non aggiornato correttamente", attached t.last_element as le and then le.value = 2)
			t.remove_latest (2) -- t = [4]
			assert ("Errore 18.1: il numero di elementi non è corretto", t.count = 1)
			assert ("Errore 18.2: last element non aggiornato correttamente", attached t.last_element as le and then le.value = 4)
			assert ("Errore 18.3: active element non aggiornato correttamente", attached t.active_element as ae and then ae.value = 4)
			t.wipeout
			a_value := 50
			target := 42
			t.append (a_value)
			t.start -- t.active_element.value = a_value
			t.append (3)
			t.append (a_value)
			t.append (a_value)
			t.append (target)
			t.append (a_value)
			t.append (4)
			t.append (a_value)
			t.append (5)
			t.append (a_value)
			t.append (a_value) -- t = [a_value, 3, a_value, a_value, target, a_value, 4, a_value, a_value]
			count_prima := how_many_before (t, a_value, target)
			t.remove_earliest_preceding (a_value, target) -- t = [3, a_value, a_value, target, a_value, 4, a_value, a_value]
			count_dopo := how_many_before (t, a_value, target)
			assert ("Errore 19.1 count prima e dopo non corretto", count_prima = count_dopo + 1)
			assert ("Errore 19.2: first element non aggiornato correttamente", attached t.first_element as fe and then fe.value = 3)
			assert ("Errore 19.3: active element non aggiornato correttamente", attached t.active_element as ae and then ae.value = 3)
			t.forth -- t.active_element.value = a_value
			count_prima := how_many_before (t, a_value, target)
			t.remove_latest_preceding (a_value, target)
			count_dopo := how_many_before (t, a_value, target)
			assert ("Errore 20: count prima e dopo non corretto", count_prima = count_dopo + 1)
			t.prepend (a_value) -- t = [a_value, 3, a_value, target, a_value, 4, a_value, a_value]
			t.remove_all_preceding (a_value, target) -- t = [3, target, a_value, 4, a_value, a_value]
				-- t.active_element.value = target
			assert ("Errore 21.1: non ha rimosso tutte le occorrenze di a_value", how_many_before (t, a_value, target) = 0)
			assert ("Errore 21.2: first element non aggiornato correttamente", attached t.first_element as fe and then fe.value = 3)
			assert ("Errore 21.3: active element non aggiornato correttamente", attached t.active_element as ae and then ae.value = target)
			count_prima := how_many_after (t, a_value, target)
			t.forth -- t.active_element.value = a_value
			t.remove_earliest_following (a_value, target) -- t = [3, target, 4, a_value, a_value], t.active_element.value = 4
			count_dopo := how_many_after (t, a_value, target)
			assert ("Errore 22.1: count prima e dopo non corretto", count_prima = count_dopo + 1)
			assert ("Errore 22.2: active element non aggiornato correttamente", attached t.active_element as ae and then ae.value = 4)
			t.remove_all_following (a_value, target) -- t = [3, target, 4]
			assert ("Errore 23.1: non ha rimosso tutte le occorrenze di a_value", how_many_after (t, a_value, target) = 0)
				-- assert ("Errore 23.2: last element non aggiornato correttamente", attached t.last_element as le and then le.value = 4)

			t.append (a_value)
			t.append (5)
			t.append (a_value) -- t = [3, target, 4, a_value, 5, a_value]
			t.last -- t.active_element.value = a_value
			count_prima := how_many_after (t, a_value, target)
			t.remove_latest_following (a_value, target) -- t = [3, target, 4, a_value, 5]
			count_dopo := how_many_after (t, a_value, target)
			assert ("Errore 24.1: count prima e dopo non corretto", count_prima = count_dopo + 1)
			assert ("Errore 24.2: active element non aggiornato correttamente", attached t.active_element as ae and then ae.value = 5)
			assert ("Errore 24.3: last element non aggiornato correttamente", attached t.last_element as le and then le.value = 5)
		end

feature -- Test routines

		-- parte di CALZUOLA_MALANDRUCCOLO

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
			if t.has (target) then
				assert ("value_follows ha trovato a_value dopo target ma il target non è presente nella lista", not t.value_follows (a_value, target))
			end
			t.append (target)
			t.append (2)
			t.append (a_value)
			assert ("non ha trovato a_value dopo target", t.value_follows (a_value, target))
			t.last
			t.append (3)
			assert ("last non punta ad a_value", attached t.active_element as ae and then ae.value = a_value)
			assert ("last non punta ad a_value", attached t.active_element as ae and then attached ae.next as aen and then aen.value = 3)
			old_count := how_many (t, a_value)
			t.remove_latest (a_value)
			count := how_many (t, a_value)
			assert ("non ho cancellato a_value nonostante ci sia un a_value dopo target", old_count - count = 1)
			assert ("non ha cancellato a_value dopo target", not t.value_follows (a_value, target))
			assert ("ha cancellato tutti gli a_value", t.has (a_value))
			assert ("non ho aggiornato active_element", attached t.active_element as ae and then ae.value = 3)
			assert ("non ha inserito l'elemento all'inizio", attached t.first_element as fe and then fe.value = a_value)
			old_sum := t.sum_of_positive
			assert ("la somma è negativa", sum <= 0)
			t.append (3)
			sum := t.sum_of_positive
			assert ("non ha aggiunto la il numero corretto", sum - old_sum = 3)
			old_sum := t.sum_of_positive
			t.append (-5)
			sum := t.sum_of_positive
			assert ("ha considerato anche un numero negativo", old_sum - sum = 0)
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
			assert ("invert non inverte la lista", (attached t.first_element as fe and attached t_inv.last_element as le) and then fe.value = le.value)
			assert ("le liste hanno dimensioni diverse", t.count = t_inv.count)
			t.remove_earliest_preceding (a_value, target)
			assert ("non è stato rimosso il valore", how_many (t, a_value) = 1)
			t_inv.remove_latest_preceding (a_value, target)
			assert ("è stato rimosso il valore", how_many (t_inv, a_value) = 2)
			t_inv.remove_latest_following (a_value, target)
			assert ("non è stato rimosso il valore", how_many (t_inv, a_value) = 1)
			t_inv.wipeout
			assert ("non ha svuotato la lista", t_inv.first_element = void and t_inv.last_element = void)

				-- t = [a_value,2,3,target,3]
			t.insert_after (target, target)
			assert ("non è stato aggiunto l'elemento", how_many (t, target) = 2)
			t.insert_multiple_before (5, target)
				-- t = [a_value,2,3,5,target,5,target,3]
			assert ("non sono stati aggiunti i valori", how_many (t, 5) = 2)
			assert ("non è stato aggiunto il valore nel posto giusto", attached t.get_element (5) as ge and then attached ge.next as gen and then gen.value = target)
			t.start
			t.remove_active
				-- t = [a_value,2,3,5,target,5,target,3]
			assert ("non è stato rimosso il valore", how_many (t, a_value) = 0)
			assert ("non è stato spostato il first_element", attached t.first_element as fe and then fe.value = 2)
			t.insert_before (a_value, 2)
			assert ("non è stato spostato il first_element", attached t.first_element as fe and then fe.value = a_value)
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
			if t.has (target) then
				assert ("value_follows ha trovato a_value dopo target ma il target non è presente nella lista", not t.value_follows (a_value, target))
			end
			t.append (target)
			old_count := t.count
			t.insert_after (a_value, target)
			count := t.count
			assert ("non ha aggiunto a_value dopo target", count - old_count = 1)
			assert ("non ha modificato last_element", attached t.last_element as le and then le.value = a_value)
			t.prepend (target)
			t.append (target)
			old_count := t.count
			t.insert_multiple_before (a_value, target)
			count := t.count
			assert ("non ha aggiunto tutti gli a_value", count - old_count = how_many (t, target))
			assert ("non ha cambiato first_elementt", attached t.first_element as fe and then fe.value = a_value)
			t.wipeout
			assert ("non ha svuotato", t.count = 0)
			assert ("non ha cambiato first_element", t.first_element = void)
			assert ("non ha cambiato last_element", t.last_element = void)
		end

feature

		-- parte di FILIPPO_IEZZI

	t_misto
			--test di varie feature combinate 2020/03/17
		local
			t: INT_LINKED_LIST
		do
			create t
			assert ("la lista è vuota, active element è void", t.active_element = Void)
			t.append (5) --5
			t.prepend (8) --8-5
			assert ("ho inserito 8 in testa", check_is_first (t, 8))
			assert ("ho inserito 5 in coda, la lista ha 5 come last", check_is_last (t, 5))
			t.insert_after (7, 5) --la lista è 8-5-7
			assert ("ho inserito 7 in coda, la lista ha 5 come last", check_is_last (t, 7))
			t.start -- 8 è active
			t.forth -- e 5 è l'active
			assert ("ho fatto forth per la prima volta, l'active element è il secondo", check_is_active (t, 5))
			t.insert_before (5, 8) -- 5-8-5-7
			assert ("ho inserito 5 in testa", check_is_first (t, 5))
			t.append (5) -- 5-8-5-7-5
			t.remove_all_following (5, 8) -- 5-8-7 e 8 è l'active
			assert ("ho tolto tutti i 5 dopo gli 8, 7 è last", check_is_last (t, 7))
			assert ("ho tolto tutti i 5 dopo gli 8, 8 è active", check_is_active (t, 8))
			assert ("ho tolto tutti i 5 dopo gli 8, 5 prima di 8 è first", check_is_first (t, 5))
			t.append (6) -- 5-8-7-6
			t.append (6) -- 5-8-7-6-6
			t.insert_after (6, 5) -- 5-6-8-7-6-6
			assert ("dopo varie operazioni count è 6", t.count = 6)
			t.remove_latest_following (6, 7) --- 5-6-8-7-6
			assert ("ho tolto l'ultimo 6 dopo 7, 6 è last", check_is_last (t, 6))
			t.remove_all_preceding (8, 6) -- 5-6-8-7-6
			assert ("ho tolto tutti gli 8 prima del primo 6, 8 dopo il primo 6 è active", check_is_active (t, 8))
			t.remove_all_preceding (8, 7) -- 5-6-7-6
			assert ("ho tolto tutti gli 8 prima del primo 7, 7 è active", check_is_active (t, 7))
			t.insert_multiple_after_CON_has_append (9, 6) -- 5-6-9-7-6-9
			assert ("dopo varie operazioni count è 6", t.count = 6)
			assert ("ho messo 9 dopo tutti i 6, 9 è last", check_is_last (t, 9))
			t.start --l'active element è 5
			t.remove_earliest_preceding (5, 6) ---- 6-9-7-6-9 e l'active è 6
			assert ("ho tolto il primo 5 prima di 6, 6 è active", check_is_active (t, 6))
			assert ("ho tolto il primo 5 prima di 6, 6 è first", check_is_first (t, 6))
			t.forth --l'active è 9
			t.remove_earliest_preceding (9, 7) ---- 6-7-6-9 e l'active è 7
			assert ("ho tolto il primo 9 prima di 7, 7 è active?", check_is_active (t, 7))
			t.insert_multiple_before (8, 6) --8-6-7-8-6-9
			t.remove_all_following (8, 8) -- 8-6-7-6-9
			assert ("ho rimosso tutti gli 8 dopo il primo 8, 8 è il first", check_is_first (t, 8))
			assert ("dopo varie operazioni il count è 5", t.count = 5)
		end

feature -- Test routines
	-- parte di CALZUOLA_MALANDRUCCOLO
	-- test vari sulle feature di remove

	t_remove_preceding
		local
			t: INT_LINKED_LIST
			a_value, target: INTEGER
		do
			create t
			a_value := 1
			target := 10
			t.append (a_value)
			t.append (2)
			t.append (a_value)
			t.append (3)
			t.append (target)
			t.remove_earliest_preceding (a_value, target)
			assert ("non ha rimosso il primo valore prima di target", attached t.first_element as fe and then fe.value = 2)
			assert ("ha rimosso più elementi", t.has (a_value))
			t.prepend (a_value)
			t.remove_latest_preceding (a_value, target)
			assert ("ha rimosso il primo elemento", attached t.first_element as fe and then fe.value = a_value)
			t.append (2)
			t.append (a_value)
			t.append (3)
			t.prepend (a_value)
			t.remove_all_preceding (a_value, target)
			assert ("non ha rimosso solo i precedenti", t.has (a_value))
			assert ("il count di a_value è sbagliato", how_many (t, a_value) = 1)
		end

	t_remove_following
		local
			t: INT_LINKED_LIST
			old_count, count: INTEGER
			a_value, target: INTEGER
		do
			create t
			a_value := 71
			target := 10
			t.append (a_value)
			t.append (3)
			t.append (target)
			t.append (a_value)
			t.last
				-- t = [a_value,3,target,a_value]

			t.remove_earliest_following (a_value, target)
			assert ("ha rimosso il primo a_value", attached t.first_element as fe and then fe.value = a_value)
			assert ("non ha rimosso a_value dopo target", attached t.last_element as le and then le.value = target)
			assert ("non ha cambiato active_element", attached t.active_element as ae and then ae.value = target)
			t.append (5)
			t.append (a_value)
			t.append (9)
			t.append (a_value)
				-- t = [a_value,3,target,5,a_value,9,a_value]

			old_count := how_many (t, a_value)
			t.remove_latest_following (a_value, target)
			count := how_many (t, a_value)
			assert ("non ha rimosso l'ultimo a_value dopo target", attached t.last_element as le and then le.value = 9)
			assert ("non ha rimosso a_value", old_count - count = 1)
				-- t = [a_value,3,target,5,a_value,9]

			t.append (a_value)
				-- t = [a_value,3,target,5,a_value,9,a_value]
			old_count := how_many (t, a_value)
			t.remove_all_following (a_value, target)
			count := how_many (t, a_value)
			assert ("non ha rimosso a_value dopo target", old_count - count = 2)
			assert ("ha rimosso il primo a_value", attached t.first_element as fe and then fe.value = a_value)
				-- t = [a_value,3,target,5,9]
		end

	t_remove_target_equals_value
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
			a_value, target: INTEGER
		do
			create t
			a_value := 1
			target := 1
			t.append (2)
			t.append (a_value)
				-- [2,1]
			t.append (3)
				-- [2,1,3]
			t.append (target)
				-- [2,1,3,1]
			t.append (a_value)
				-- [2,1,3,1,1]
			t.append (2)
				-- [2,1,3,1,1,2]
			t.append (a_value)
				-- [2,1,3,1,1,2,1]

			count_prima := how_many (t, a_value)
			t.remove_all_preceding (a_value, target)
			count_dopo := how_many (t, a_value)
			assert ("errore: qualche elemento è stato eliminato", count_prima = count_dopo)
			t.remove_latest_preceding (a_value, target)
			count_dopo := how_many (t, a_value)
			assert ("errore: qualche elemento è stato eliminato", count_prima = count_dopo)
			t.remove_earliest_preceding (a_value, target)
			count_dopo := how_many (t, a_value)
			assert ("errore: qualche elemento è stato eliminato", count_prima = count_dopo)

				--			assert("errore: qualche a_value non è stato eliminato", count_dopo > 1)
				--			assert("errore: sono stati eliminati tutti a_value", count_dopo < 1)
				--		--  problema con a_value = target
				--			count_dopo := how_many(t,a_value)
				--			assert("errore: qualche elemento è stato eliminato", count_prima = count_dopo)
				-- TODO: cancellare fino a qua perché bisogna inserire il require a_value /= target in remove_all_preceding e remove_latest_preceding

			count_prima := how_many (t, a_value)
			t.remove_earliest_following (a_value, target)
			count_dopo := how_many (t, a_value)
			assert ("errore: non ha eliminato il singolo elemento", count_prima = count_dopo + 1)
			assert ("errore: non ha eliminato l'elemento giusto", (attached t.get_element (a_value) as ge and then attached ge.next as gen) and then gen.value = 3)
			t.remove_latest_following (a_value, target)
			assert ("errore: ha rimosso l'elemento sbagliato", attached t.last_element as le and then le.value = 2)
			t.remove_all_following (a_value, target)
			assert ("errore: non ha eliminato tutti gli elementi successivi al target", how_many (t, a_value) = 1)
		end

feature -- Controllo lista
	-- test vari sul controllo dellol stato della lista

	t_lista_vuota
			-- Calzuola e Malandruccolo 2020/03/21
		local
			t_vuota: INT_LINKED_LIST
			a_value: INTEGER
		do
			create t_vuota
			a_value := 1
			assert ("has trova il valore su lista vuota", not t_vuota.has (a_value))
			assert ("get_element restituisce un elemento su lista vuota", t_vuota.get_element (a_value) = void)
			assert ("la lista non è vuota", t_vuota.count = 0)
		end

	t_lista_un_elemento
			-- Calzuola e Malandruccolo 2020/03/21
		local
			t_one_element: INT_LINKED_LIST
			a_value: INTEGER
			a_different: INTEGER
		do
			a_value := 7
			a_different := 9
			create t_one_element
			t_one_element.append (a_value)
			assert ("non ho aggiunto il valore corretto", t_one_element.has (a_value) and not t_one_element.has (a_different))
			assert ("non ho una lista con un elemento", t_one_element.count = 1)
			assert ("first_element diverso da last_element", t_one_element.first_element = t_one_element.last_element)
			assert ("first_element diverso da a_value", attached t_one_element.first_element as fe and then fe.value = a_value)
			assert ("last_element diverso da a_value", attached t_one_element.last_element as le and then le.value = a_value)
			assert ("restituisce un void ma dovrebbe restituire a_value", t_one_element.get_element (a_value) /= void)
			assert ("non restituisce a_value", attached t_one_element.get_element (a_value) as ge and then ge.value = a_value)
			assert ("ho un valore che non dovrei avere", t_one_element.get_element (a_different) = void)
		end

	t_lista_due_elementi
			-- Calzuola e Malandruccolo 2020/03/21
		local
			t_due: INT_LINKED_LIST
			a_value: INTEGER
		do
			create t_due
			a_value := 1
			t_due.append (a_value)
			t_due.append (2 * a_value)
			assert ("has non trova il valore", t_due.has (a_value))
			assert ("get_element non trova l'elemento", t_due.get_element (a_value) /= void)
			assert ("la lista non ha due elementi", t_due.count = 2)
			assert ("il first_element non è impostato correttamente", attached t_due.first_element as fe and then fe.value = a_value)
			assert ("il last_element non è impostato correttamente", attached t_due.last_element as le and then le.value = 2 * a_value)
		end

end
