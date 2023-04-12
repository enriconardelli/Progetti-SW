note
	description: "Summary description for {REMOVE_ALL_FOLLOWING_TESTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DA_CANCELLARE_REMOVE_ALL_FOLLOWING_TESTS
	--Giulia Iezzi 2020/03/11



	-- CLASSE DA CANCELLARE, TEST SPOSTATI IN REMOVE_MULTIPLE_TAGETED_TESTS



inherit

	STATIC_TESTS

--feature

--	how_many_after (t: INT_LINKED_LIST; a_value, target: INTEGER): INTEGER
--			--conta le occorrenze di a_value successive a target
--		require
--			t.has (target)
--		local
--			current_element: INT_LINKABLE
--		do
--			if t.count = 1 then
--				Result := 0
--			end
--			if attached t.get_element (target) as tar then
--				from
--					current_element := tar.next
--				until
--					current_element = Void
--				loop
--					if current_element.value = a_value then
--						Result := Result + 1
--					end
--					current_element := current_element.next
--				end
--			end
--		end

--	t_lista_senza_value (a_value: INTEGER)
--		local
--			t: INT_LINKED_LIST
--			s: INTEGER
--		do
--			create t
--			t.append (a_value + 1)
--			t.append (a_value + 3)
--			t.append (a_value + 2)
--			s := how_many (t, a_value)
--			t.remove_all_following (a_value, a_value + 3)
--			assert ("Nella lista non c'è a_value", s = how_many (t, a_value))
--		end

--	t_lista (tar, val: INTEGER)
--		local
--			t: INT_LINKED_LIST
--			b, h: INTEGER
--		do
--			create t
--			t.append (tar + val + 1)
--			t.append (val)
--			t.append (5)
--			t.append (tar)
--			t.append (val)
--			t.append (6)
--			t.append (7)
--			t.append (val + tar + 3)
--			h := how_many (t, val)
--			b := how_many_after (t, val, tar)
--			t.remove_all_following (val, tar)
--			assert ("E' stato rimosso il giusto numero di occorrenze di val", how_many (t, val) = h - b)
--		end
--		

--	t_remove_all_following
--		do
--			t_lista_senza_value (6)
--			t_lista (7, 5)
--		end

	end
