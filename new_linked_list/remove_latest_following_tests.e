note
	description: "Summary description for {REMOVE_LATEST_FOLLOWING_TESTS}."
	author: "Alessandro Filippo"
	date: "$Date$"
	revision: "$Revision$"

class
	REMOVE_LATEST_FOLLOWING_TESTS

inherit

	STATIC_TESTS

feature

	how_many (t: INT_LINKED_LIST; a_value: INTEGER): INTEGER
			--ci dice quante occorrenze di value ci sono nella lista
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
					if current_element.value = a_value then
						Result := Result + 1
					end
					current_element := current_element.next
				end
			end
		end

--	t_lista_vuota
--		local
--			t: INT_LINKED_LIST
--		do
--			create t
--			t.remove_latest_following (2, 5)
--			assert ("La lista è vuota e rimane vuota", t.count = 0)
--		end

--	t_lista_senza_target (tar: INTEGER; a_value: INTEGER)
--		--da contratto non si può chiamare
--		local
--			t: INT_LINKED_LIST
--			s: INTEGER
--		do
--			create t
--			t.append (tar + 1)
--			t.append (tar + 2)
--			t.append (tar + 1)
--			s := how_many (t, a_value)
--			t.remove_latest_following (a_value, tar)
--			assert ("Nella lista non c'è il target", s = how_many (t, a_value))
--		end

	t_lista_senza_value (a_value: INTEGER)
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

	t_remove_latest_following
		do
			--t_lista_vuota
			t_lista_senza_value (5)
			--t_lista_senza_target (10, 5) --da contratto non si può chamare
			t_con_value_dopo_target (10,5)
			t_con_value_prima_di_target (10,7)
		end

	t_con_value_dopo_target (target,a_value: INTEGER)
		--la funzione deve partire dal primo target che trova e togliere l'ultimo a_value
	local
		t: INT_LINKED_LIST
		l,k_1,k_2: INTEGER
	do
		create t
		k_1:=a_value + target + 1
		k_2:=a_value + target + 2

		t.append (a_value) --non deve toglierlo
		t.append (target) --qui ho il mio target
		t.append (a_value) --non deve toglierlo
		t.append (k_1)
		t.append (a_value) --deve togliere questo
		t.append (k_2)

		l:= how_many (t,a_value) --conto quanti ci sono all'inizio
 		t.remove_latest_following (a_value, target)
		assert ("E' stata rimossa una occorrenza di val", how_many (t, a_value)=l-1)
		assert ("E' stata tolta quella giusta", attached t.get_element (k_1) as t1 implies t1.next=t.get_element (k_2))
	end

	t_con_value_prima_di_target (target,a_value: INTEGER)
		--la funzione deve partire dal primo target che trova e togliere l'ultimo a_value
	local
		t: INT_LINKED_LIST
		l,k_1: INTEGER
	do
		create t
		k_1:=a_value + target + 1

		t.append (k_1)
		t.append (a_value) --non deve toglierlo
		t.append (target) --qui ho il mio target
		t.append (k_1)

		l:= how_many (t,a_value) --conto quanti ci sono all'inizio
 		t.remove_latest_following (a_value, target)
		assert ("Non è stata rimossa una occorrenza di val", l=how_many(t,a_value))
	end


end
