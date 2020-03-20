note
	description: "Summary description for {INTEGRATION_TESTS_AGULINI_FIORINI}."
	author: "Claudia Agulini - Federico Fiorini"
	date: "$Date$"
	revision: "$Revision$"

class
	INTEGRATION_TESTS_AGULINI_FIORINI

inherit

	STATIC_TESTS

feature

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
			t.insert_after_reusing (6, 4) --inserisce 6 dopo 4
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
			t.insert_after_reusing (8, 8)
			t.forth
			t.forth
			t.forth
				--[5,2,1,4,6,3,7,8] active element è 8
			assert ("Errore 10.1: il numero di elementi non è corretto", t.count = 8)
			assert ("Errore 10.2: first_element non è corretto", attached t.first_element as fe and then fe.value = 5)
			assert ("Errore 10.3: last_element non è corretto", attached t.last_element as le and then le.value = 8)
			assert ("Errore 10.4: active_element non è corretto", attached t.active_element as ae and then ae.value = 8)
			t.insert_multiple_after (9, 4) --inserisce 9 dopo ogni 4
			t.start
				--[5,2,1,4,9,6,3,7,8] active element è 5
			t.insert_multiple_after (9, 8)
				--[5,2,1,4,9,6,3,7,8,9] active element è 5
			assert ("Errore 11.1: il numero di elementi non è corretto", t.count = 10)
			assert ("Errore 11.2: first_element non è corretto", attached t.first_element as fe and then fe.value = 5)
			assert ("Errore 11.3: last_element non è corretto", attached t.last_element as le and then le.value = 9)
			assert ("Errore 11.4: active_element non è corretto", attached t.active_element as ae and then ae.value = 5)
			t.insert_multiple_after (9, 9)
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
		do
			create t
			t.append (1)
			t.append (2)
			t.append (3)
				-- t = [1,2,3]; t.active_element.value = 1
			t.start
			t.remove_active -- t = [2,3], t.active_element.value = 2
			assert ("errore: il numero di elementi non è corretto", t.count = 2)
			assert ("errore_1: active element non aggiornato correttamente", attached t.active_element as ae and then ae.value = 2)
			assert ("errore: first element non aggiornato correttamente", attached t.first_element as fe and then fe.value = 2)
			t.forth -- t.active_element.value = 3
			assert ("errore_2: active element non aggiornato correttamente", attached t.active_element as ae and then ae.value = 3)
			t.prepend (4) -- t = [4, 2, 3]
			t.remove_active -- t = [4, 2]
			assert ("errore: il numero di elementi non è corretto", t.count = 2)
			assert ("errore_3: active element non aggiornato correttamente", attached t.active_element as ae and then ae.value = 2)
			assert ("errore: last element non aggiornato correttamente", attached t.last_element as le and then le.value = 2)
			t.remove_latest (2) -- t = [4]
			assert ("errore: il numero di elementi non è corretto", t.count = 1)
			assert ("errore: last element non aggiornato correttamente", attached t.last_element as le and then le.value = 4)
			assert ("errore: active element non aggiornato correttamente", attached t.active_element as ae and then ae.value = 4)
			t_remove_values (50, 42)
		end

	t_remove_values (a_value, target: INTEGER)
		local
			t: INT_LINKED_LIST
			count_prima, count_dopo: INTEGER
		do
			create t
			t.append (a_value)
			t.start
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
				-- t.active_element.value = a_value
			count_prima := how_many_before (t, a_value, target)
			t.remove_earliest_preceding (a_value, target) -- t = [3, a_value, a_value, target, a_value, 4, a_value, a_value]
			count_dopo := how_many_before (t, a_value, target)
			assert ("errore: count prima e dopo non corretto", count_prima = count_dopo + 1)
			assert ("errore: first element non aggiornato correttamente", attached t.first_element as fe and then fe.value = 3)
			assert ("errore_4: active element non aggiornato correttamente", attached t.active_element as ae and then ae.value = 3)
			t.forth -- t.active_element.value = a_value
			count_prima := how_many_before (t, a_value, target)
			t.remove_latest_preceding (a_value, target)
			count_dopo := how_many_before (t, a_value, target)
			assert ("errore: count prima e dopo non corretto", count_prima = count_dopo + 1)
			t.prepend (a_value) -- t = [a_value, 3, a_value, target, a_value, 4, a_value, a_value]
			t.remove_all_preceding (a_value, target) -- t = [3, target, a_value, 4, a_value, a_value]
				-- t.active_element.value = target
			assert ("errore: non ha rimosso tutte le occorrenze di a_value", how_many_before (t, a_value, target) = 0)
			assert ("errore: first element non aggiornato correttamente", attached t.first_element as fe and then fe.value = 3)
			assert ("errore_5: active element non aggiornato correttamente", attached t.active_element as ae and then ae.value = target)
			count_prima := how_many_after (t, a_value, target)
			t.forth -- t.active_element.value = a_value
			t.remove_earliest_following (a_value, target) -- t = [3, target, 4, a_value, a_value], t.active_element.value = 4
			count_dopo := how_many_after (t, a_value, target)
			assert ("errore: count prima e dopo non corretto", count_prima = count_dopo + 1)
			assert ("errore_6: active element non aggiornato correttamente", attached t.active_element as ae and then ae.value = 4)
			t.remove_all_following (a_value, target) -- t = [3, target, 4]
			assert ("errore: non ha rimosso tutte le occorrenze di a_value", how_many_after (t, a_value, target) = 0)
				--assert("errore: last element non aggiornato correttamente", attached t.last_element as le and then le.value = 4)

			t.append (a_value)
			t.append (5)
			t.append (a_value) -- t = [3, target, 4, a_value, 5, a_value]
			t.last -- t.active_element.value = a_value
			count_prima := how_many_after (t, a_value, target)
			t.remove_latest_following (a_value, target) -- t = [3, target, 4, a_value, 5]
			count_dopo := how_many_after (t, a_value, target)
			assert ("errore: count prima e dopo non corretto", count_prima = count_dopo + 1)
			assert ("errore: active element non aggiornato correttamente", attached t.active_element as ae and then ae.value = 5)
				--assert ("errore: last element non aggiornato correttamente", attached t.last_element as le and then le.value = 5)
		end

end
