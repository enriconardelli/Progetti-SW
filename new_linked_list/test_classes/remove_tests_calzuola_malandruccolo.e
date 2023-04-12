note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	DA_CANCELLARE_REMOVE_TESTS_CALZUOLA_MALANDRUCCOLO

inherit
	STATIC_TESTS



	-- CLASSE DA CANCELLARE, TEST SPOSTATI IN INTEGRATION_TESTS




--feature -- Test routines

--	t_remove_preceding
--		local
--			t: INT_LINKED_LIST
--			a_value,target: INTEGER
--		do
--			create t
--			a_value := 1
--			target := 10

--			t.append (a_value)
--			t.append (2)
--			t.append (a_value)
--			t.append (3)
--			t.append (target)

--			t.remove_earliest_preceding (a_value, target)
--			assert("non ha rimosso il primo valore prima di target", attached t.first_element as fe and then fe.value = 2)
--			assert("ha rimosso più elementi", t.has (a_value))

--			t.prepend (a_value)
--			t.remove_latest_preceding (a_value, target)
--			assert("ha rimosso il primo elemento", attached t.first_element as fe and then fe.value = a_value)

--			t.append (2)
--			t.append (a_value)
--			t.append (3)
--			t.prepend (a_value)
--			t.remove_all_preceding (a_value, target)
--			assert("non ha rimosso solo i precedenti", t.has (a_value))
--			assert("il count di a_value è sbagliato", how_many(t,a_value) = 1)
--		end

--	t_remove_following
--		local
--			t:INT_LINKED_LIST
--			old_count, count : INTEGER
--			a_value,target: INTEGER
--		do
--			create t
--			a_value := 71
--			target := 10

--			t.append (a_value)
--			t.append (3)
--			t.append (target)
--			t.append (a_value)
--			t.last
--			-- t = [a_value,3,target,a_value]

--			t.remove_earliest_following (a_value, target)
--			assert("ha rimosso il primo a_value", attached t.first_element as fe and then fe.value = a_value)
--			assert("non ha rimosso a_value dopo target", attached t.last_element as le and then le.value = target)
--			assert("non ha cambiato active_element", attached t.active_element as ae and then ae.value = target)
--			t.append(5)
--			t.append (a_value)
--			t.append (9)
--			t.append (a_value)
--			-- t = [a_value,3,target,5,a_value,9,a_value]

--			old_count := how_many(t,a_value)
--			t.remove_latest_following (a_value, target)
--		    count := how_many(t,a_value)
--			assert("non ha rimosso l'ultimo a_value dopo target", attached t.last_element as le and then le.value = 9)
--			assert("non ha rimosso a_value", old_count - count = 1)
--			-- t = [a_value,3,target,5,a_value,9]

--			t.append(a_value)
--			-- t = [a_value,3,target,5,a_value,9,a_value]
--			old_count := how_many(t,a_value)
--			t.remove_all_following (a_value, target)
--			count := how_many(t,a_value)
--			assert("non ha rimosso a_value dopo target", old_count - count = 2)
--			assert("ha rimosso il primo a_value", attached t.first_element as fe and then fe.value = a_value)
--			-- t = [a_value,3,target,5,9]
--		end

--	t_remove_target_equals_value
--		local
--			t: INT_LINKED_LIST
--			count_prima, count_dopo: INTEGER
--			a_value, target: INTEGER
--		do
--			create t
--			a_value := 1
--			target := 1

--			t.append (2)
--			t.append (a_value)
--			-- [2,1]
--			t.append (3)
--			-- [2,1,3]
--			t.append (target)
--			-- [2,1,3,1]
--			t.append (a_value)
--			-- [2,1,3,1,1]
--			t.append (2)
--			-- [2,1,3,1,1,2]
--			t.append (a_value)
--			-- [2,1,3,1,1,2,1]

--			count_prima := how_many(t,a_value)
--			t.remove_all_preceding (a_value, target)
--			count_dopo := how_many(t,a_value)
--			assert("errore: qualche elemento è stato eliminato", count_prima = count_dopo)

--			t.remove_latest_preceding (a_value, target)
--			count_dopo := how_many(t,a_value)
--			assert("errore: qualche elemento è stato eliminato", count_prima = count_dopo)

--			t.remove_earliest_preceding (a_value, target)
--			count_dopo := how_many(t,a_value)
--			assert("errore: qualche elemento è stato eliminato", count_prima = count_dopo)

----			assert("errore: qualche a_value non è stato eliminato", count_dopo > 1)
----			assert("errore: sono stati eliminati tutti a_value", count_dopo < 1)
----		--  problema con a_value = target
----			count_dopo := how_many(t,a_value)
----			assert("errore: qualche elemento è stato eliminato", count_prima = count_dopo)
---- TODO: cancellare fino a qua perché bisogna inserire il require a_value /= target in remove_all_preceding e remove_latest_preceding

--			count_prima := how_many(t,a_value)
--			t.remove_earliest_following (a_value, target)
--			count_dopo := how_many(t,a_value)
--			assert("errore: non ha eliminato il singolo elemento", count_prima = count_dopo + 1)
--			assert("errore: non ha eliminato l'elemento giusto", (attached t.get_element (a_value) as ge and then attached ge.next as gen) and then gen.value = 3)
--			t.remove_latest_following (a_value, target)
--			assert("errore: ha rimosso l'elemento sbagliato", attached t.last_element as le and then le.value = 2)

--			t.remove_all_following (a_value, target)
--			assert("errore: non ha eliminato tutti gli elementi successivi al target", how_many(t,a_value) = 1)
--		end

end


