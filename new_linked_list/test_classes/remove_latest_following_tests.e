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


	t_remove_latest_following
		do
			t_lista_senza_value (5)
			t_con_value_dopo_target (10,5)
			t_con_value_dopo_target (5,5) --provo se vale quando target e value coincidono
			t_con_value_prima_di_target (10,7)
			t_con_active_e_last(6,7)
		end

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
		t.append (target) --se ci sono anche più target?
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

	t_con_active_e_last(target,a_value: INTEGER)
	local
		t: INT_LINKED_LIST
	do
		create t
		t.append (target +2)
		t.append (target)
		t.append (a_value)
		t.last -- l'active e il last valgono value
		t.remove_latest_following (a_value, target)
		assert("ERRORE: cattiva gestione di active", t.active_element/=Void and then attached t.active_element as te implies te.value=target)
		assert("ERRORE: cattiva gestione di last", t.last_element/=Void and then attached t.last_element as le implies le.value=target)

	end


end
