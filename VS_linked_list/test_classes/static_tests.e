note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	STATIC_TESTS

inherit
	EQA_TEST_SET

feature -- Test routines

	t_lista_vuota
			-- Verifica che alcune feature ritornino valore corretto quando la lista è vuota
	local
		lista_zero: INT_LINKED_LIST
		ok: INTEGER
	do
		create lista_zero
		ok := 3

		assert ("errore: has su lista vuota", not lista_zero.has(ok))
		assert ("errore: get_element su lista vuota", lista_zero.get_element(ok) = Void)
		assert ("errore: sum_of_positive su lista vuota", lista_zero.sum_of_positive = 0)
		assert ("errore: count su lista vuota", lista_zero.count = 0)
	end

	t_lista_uno
			-- Verifica che alcune feature ritornino valore corretto quando la lista ha un solo elemento
	local
		lista_uno: INT_LINKED_LIST
		ok, ko: INTEGER
	do
		create lista_uno
		ko := 7
		ok := 3
		lista_uno.append (ok)
		-- il valore di lista_uno adesso è (3)
		assert ("errore: has su lista_uno", lista_uno.has(ok) and (not lista_uno.has (ko)))
		assert ("errore: get_element su lista_uno", lista_uno.get_element(ok) /= Void)
		-- negli ensure di get_element ho già che Result /= Void implies Result.value = a_value
		assert ("errore: sum_of_positive su lista_uno", lista_uno.sum_of_positive = ok)
		assert ("errore: valore di first_element e last_element su lista_uno", attached lista_uno.first_element as l1 implies l1.value = ok)
    	assert ("errore: append non aggiorna count su lista_uno", lista_uno.count = 1)
	end

	t_lista_due
			-- Verifica che alcune feature ritornino valore corretto quando la lista ha esattamente due elementi
	local
		lista_due: INT_LINKED_LIST
		ok1, ok2, ko: INTEGER
	do
		create lista_due
		ko := 7
		ok1 := 3
		ok2 := -1
		lista_due.append (ok1)
		lista_due.append (ok2)
		-- il valore di lista_due adesso è (3,-1)
		assert ("errore: has su lista_due", lista_due.has(ok1) and lista_due.has(ok2) and (not lista_due.has (ko)))
		assert ("errore: get_element su lista_due", (lista_due.get_element(ok1) /= Void) and (lista_due.get_element(ok2) /= Void) and (lista_due.get_element(ko) = Void))
		assert ("errore: first_element su lista due", lista_due.first_element = lista_due.get_element(ok1))
		assert ("errore: last_element su lista_due", lista_due.last_element = lista_due.get_element(ok2))
		assert ("errore: last_element su lista_due", attached lista_due.get_element(ok1) as l2 implies l2.next = lista_due.last_element)
		assert ("errore: sum_of_positive su lista_due", lista_due.sum_of_positive = ok1)
		assert ("errore: append non aggiorna count su lista_due", lista_due.count = 2)
	end

	t_lista_n
			-- Verifica che alcune feature ritornino valore corretto quando la lista ha più di due elementi
	local
		lista_n: INT_LINKED_LIST
		ok1, ok2, ok3,  ko: INTEGER
	do
		create lista_n
		ko := 7
		ok1 := 12
		ok2 := -5
		ok3 := 0
		lista_n.append (ok1)
		lista_n.append (ok2)
		lista_n.append (ok3)
		-- il valore di lista_n adesso è (12,-5,0)
		assert ("errore: has su lista_n", lista_n.has(ok2) and lista_n.has(ok1) and lista_n.has(ok3))
		assert ("errore: get_element su lista_n", (lista_n.get_element(ok2) /= Void) and (lista_n.get_element(ok3) /= Void) and (lista_n.get_element(ok1) /= Void) and (lista_n.get_element(ko) = Void))
		assert ("errore: get_element su lista_n", attached lista_n.get_element(ok2) as l_n implies (attached l_n.next as l_nn implies l_nn.value = ok3))
		assert ("errore: first_element su lista_n", lista_n.first_element = lista_n.get_element(ok1))
		assert ("errore: last_element su lista_n", lista_n.last_element = lista_n.get_element(ok3))
		assert ("errore: last_element su lista_n", attached lista_n.get_element(ok1) as l_n implies (attached l_n.next as l_nn implies l_nn.next = lista_n.last_element))
		assert ("errore: sum_of_positive su lista_n", lista_n.sum_of_positive = ok1)
	end

end


