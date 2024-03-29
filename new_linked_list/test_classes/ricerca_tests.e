note
	description: "Test per feature di tipo Ricerca"
	author: "Gianluca Pastorini"
	date: "08/04/23"
	revision: "$Revision$"

class
	RICERCA_TESTS

inherit

	EQA_TEST_SET

feature -- parametri

	a_value: INTEGER = 1

	other_element_1: INTEGER = 5

	other_element_2: INTEGER = 7

feature -- has
	-- Enrico Nardelli, 2020/03/06

	t_has_empty
		local
			t: INT_LINKED_LIST
		do
			create t
			assert ("t e' vuota, non pu� contenere a_value", not t.has (a_value))
		end

	t_has_with_elements
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (other_element_1)
			assert ("risulta che t non contiene a_value?", t.has (a_value))
			assert ("risulta che t contiene other_element_2", not t.has (other_element_2))
		end

feature -- get_element
	-- Riccardo Malandruccolo, 2020/03/06

	t_get_element_empty
		local
			t: INT_LINKED_LIST
		do
			create t
			assert ("errore: restituisce elemento che non esiste", t.get_element (a_value) = Void)
		end

	t_get_element_single_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (other_element_1)
			assert ("errore: non restituisce elemento che esiste", t.get_element (a_value) /= Void)
			assert ("errore: non restituisce il valore corretto", attached t.get_element (a_value) as el implies el.value = a_value)
			assert ("errore: restituisce elementi che non esistono", t.get_element (other_element_2) = Void)
		end

	t_get_element_multiple_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (other_element_1)
			t.append (a_value)
			assert ("errore: non restituisce elemento che esiste", t.get_element (a_value) /= Void)
			assert ("errore: non restituisce il valore corretto", attached t.get_element (a_value) as el implies el.value = a_value)
			assert ("errore: restituisce elementi che non esistono", t.get_element (other_element_2) = Void)
			assert ("non ha restituito il primo elemento con valore a_value", t.get_element (a_value) = t.first_element)
		end

end
