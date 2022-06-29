note
	description: "Summary description for {INTEGRATION_TESTS_FILIPPO_IEZZI}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INTEGRATION_TESTS_FILIPPO_IEZZI

inherit

	STATIC_TESTS

feature

	t_misto
		--test di varie feature combinate 2020/03/17
	local
		t: INT_LINKED_LIST
	do
		create t
		assert("la lista è vuota, active element è void",t.active_element=Void)
		t.append(5) --5
		t.prepend(8) --8-5
		assert("ho inserito 8 in testa", check_is_first(t, 8))
		assert("ho inserito 5 in coda, la lista ha 5 come last", check_is_last(t,5))
		t.insert_after (7, 5) --la lista è 8-5-7
		assert("ho inserito 7 in coda, la lista ha 5 come last", check_is_last(t,7))
		t.start -- 8 è active
		t.forth -- e 5 è l'active
		assert("ho fatto forth per la prima volta, l'active element è il secondo", check_is_active(t,5))
		t.insert_before (5,8) -- 5-8-5-7
		assert("ho inserito 5 in testa", check_is_first(t, 5))
		t.append(5) -- 5-8-5-7-5
		t.remove_all_following (5, 8) -- 5-8-7 e 8 è l'active
		assert("ho tolto tutti i 5 dopo gli 8, 7 è last", check_is_last(t,7))
		assert("ho tolto tutti i 5 dopo gli 8, 8 è active", check_is_active(t,8))
		assert("ho tolto tutti i 5 dopo gli 8, 5 prima di 8 è first", check_is_first(t,5))
		t.append(6) -- 5-8-7-6
		t.append (6) -- 5-8-7-6-6
		t.insert_after (6,5) -- 5-6-8-7-6-6
		assert("dopo varie operazioni count è 6", t.count=6)
		t.remove_latest_following (6,7) --- 5-6-8-7-6
		assert("ho tolto l'ultimo 6 dopo 7, 6 è last", check_is_last(t,6))
		t.remove_all_preceding (8, 6) -- 5-6-8-7-6
		assert("ho tolto tutti gli 8 prima del primo 6, 8 dopo il primo 6 è active", check_is_active(t,8))
		t.remove_all_preceding (8, 7) -- 5-6-7-6
		assert("ho tolto tutti gli 8 prima del primo 7, 7 è active", check_is_active(t,7))
		t.insert_multiple_after_using_has_append (9, 6) -- 5-6-9-7-6-9
		assert("dopo varie operazioni count è 6", t.count=6)
		assert("ho messo 9 dopo tutti i 6, 9 è last", check_is_last(t,9))
		t.start --l'active element è 5
		t.remove_earliest_preceding (5,6) ---- 6-9-7-6-9 e l'active è 6
		assert("ho tolto il primo 5 prima di 6, 6 è active", check_is_active(t,6))
		assert("ho tolto il primo 5 prima di 6, 6 è first", check_is_first(t,6))
		t.forth --l'active è 9
		t.remove_earliest_preceding (9,7) ---- 6-7-6-9 e l'active è 7
		assert("ho tolto il primo 9 prima di 7, 7 è active?", check_is_active(t,7))
		t.insert_multiple_before (8, 6) --8-6-7-8-6-9
		t.remove_all_following (8,8) -- 8-6-7-6-9
		assert("ho rimosso tutti gli 8 dopo il primo 8, 8 è il first",check_is_first(t,8))
		assert("dopo varie operazioni il count è 5",t.count=5)
	end

	check_is_last (t: INT_LINKED_LIST; a_value: INTEGER): BOOLEAN
		--controlla che a_value è l'ultimo
	do

	Result:=t.last_element /= Void and then (attached t.last_element as le implies le.value=a_value)

	end

	check_is_active (t: INT_LINKED_LIST; a_value: INTEGER): BOOLEAN
		--controlla che a_value è l'active
	do

	Result:=t.active_element /= Void and then (attached t.active_element as ae implies ae.value=a_value)

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

end
