note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	NEW_TEST_SET

inherit
	EQA_TEST_SET

feature -- Test routines

	t_has
		local
			t: INT_LINKED_LIST
		do
			create t
			assert("errore: la lista è vuota", not t.has (3))
			t.append (3)
			assert("errore: la lista contiene 3", t.has (3))
			t.append (7)
			assert("errore: la lista contiene 3", t.has (3))
			assert("errore: la lista non contiene 4", not t.has (4))
			assert("errore: la lista contiene 7", t.has (7))
		end

	t_append
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append(0)
			assert("errore: la lista contiene 0", t.has (0))
			assert("errore: non aggiorna count con lista vuota", t.count = 1)
			t.append(-4)
			assert("errore: il numero aggiunto non è last_element", attached t.last_element as le implies le.value = -4)
		end

	t_get_element
		local
			t: INT_LINKED_LIST
		do
			create t
			assert("errore: restituisce elemento che non esiste", t.get_element (3) = void)
			t.append (3)
			assert("errore: non restituisce elemento che esiste", t.get_element (3) /= void)
			assert("errore: non restituisce il valore corretto", attached t.get_element(3) as el implies el.value = 3)
			assert("errore: restituisce elementi che non esistono", t.get_element(4) = void)

			t.append (7)
			assert("errore: non restituisce elemento che esiste", t.get_element (3) /= void)
			assert("errore: restituisce elemento che non esiste", t.get_element (4) = void)
			assert("errore: non restituisce elemento che esiste", t.get_element (7) /= void)
			assert("errore: restituisce valore sbagliato di elemento che esiste", attached t.get_element (3) as el implies el.value = 3)
			assert("errore: restituisce valore sbagliato di elemento che esiste", attached t.get_element (7) as el implies el.value = 7)
		end

end


