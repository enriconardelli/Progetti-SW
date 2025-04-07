note
	description: "Test per feature di tipo Ricerca"
	author_1: "Gianluca Pastorini - 03/04/23"
	author_2: "Marco Aragona & Gabriele Messina"
	date: "29/03/25"
	revision: "$Revision$"

class
	RICERCA_TESTS2

inherit

	EQA_TEST_SET
		redefine
			on_prepare
		end

feature -- creazione istanza di List_Builder

	on_prepare
		do
			create a_list_builder
		end

feature -- parametri

	a_list_builder: LIST_BUILDER

feature --t_has
		t_has
--	t_has_empty
		do
			assert ("la lista e' vuota, non può contenere a_value", not (a_list_builder.list_empty).has (a_list_builder.a_value))
--	t_has_with_elements
			assert ("risulta che la lista non contiene a_value?", (a_list_builder.list_Ve1).has (a_list_builder.a_value))
			assert ("risulta che la lista contiene other_element_2", not (a_list_builder.list_Ve1).has (a_list_builder.other_element_2))
		end

feature -- t_get_element
	t_get_element
	--t_get_element_empty
		do
			assert ("errore: restituisce elemento che non esiste", (a_list_builder.list_empty).get_element (a_list_builder.a_value) = Void)

	--t_get_element_single_value

			assert ("errore: non restituisce elemento che esiste", (a_list_builder.list_Ve1).get_element (a_list_builder.a_value) /= Void)
			assert ("errore: non restituisce il valore corretto", attached (a_list_builder.list_Ve1).get_element (a_list_builder.a_value) as el implies el.value = a_list_builder.a_value)
			assert ("errore: restituisce elementi che non esistono", (a_list_builder.list_Ve1).get_element (a_list_builder.other_element_2) = Void)

	--t_get_element_multiple_value
			assert ("errore: non restituisce elemento che esiste", (a_list_builder.list_Ve1V).get_element (a_list_builder.a_value) /= Void)
			assert ("errore: non restituisce il valore corretto", attached (a_list_builder.list_Ve1V).get_element (a_list_builder.a_value) as el implies el.value = a_list_builder.a_value)
			assert ("errore: restituisce elementi che non esistono", (a_list_builder.list_Ve1V).get_element (a_list_builder.other_element_2) = Void)
			assert ("non ha restituito il primo elemento con valore a_value", (a_list_builder.list_Ve1V).get_element (a_list_builder.a_value) = (a_list_builder.list_Ve1V).first_element)
		end

end
