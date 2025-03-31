note
	description: "Test per le feature di tipo INSERT_SINGLE_FREE_TESTS"
	author: "Marco Aragona & Gabriele Messina"
	date: "29/03/25"
	revision: "$Revision$"

class
	INSERT_SINGLE_FREE_TESTS2

inherit

	EQA_TEST_SET
		redefine
			on_prepare
		end

feature -- creazione istanza di List_Builder

	on_prepare
		do
			create list_builder.make (a_value, a_target, other_element_1, other_element_2)
		end

feature -- parametri

	list_builder: LIST_BUILDER

	a_value: INTEGER = 1

	a_target: INTEGER = 2

	other_element_1: INTEGER = 5

	other_element_2: INTEGER = 7

feature

	append
		do
				--	t_append_empty
			assert ("ERRORE: ho fatto append di a_value, ma t non contiene a_value", (list_builder.list_V).has (a_value))
			assert ("ERRORE: ho fatto append solo di a_value, ma t contiene other_element_1", not (list_builder.list_V).has (other_element_1))

				--	t_append_to_element
			assert ("ERRORE: ho fatto append di a_value, ma t non contiene a_value", (list_builder.list_Ve1).has (a_value))
			assert ("ERRORE: ho fatto append anche di a_value-2 ma t non contiene other_element_1", (list_builder.list_Ve1).has (other_element_1))
			assert ("ERRORE: l'elemento a_value-2 dovrebbe essere stato messo come ultimo elemento", (list_builder.list_Ve1).last_element /= Void and then attached (list_builder.list_Ve1).last_element as le implies le.value = other_element_1)
		end

feature -- prepend
	-- Enrico Nardelli, 2021/03/02

	t_prepend_empty
		local
			t: INT_LINKED_LIST
		do
			create t
			t.prepend (a_value)
			assert ("ERRORE: ho fatto prepend di a_value, ma t non contiene a_value?", t.has (a_value))
			assert ("ERRORE: ho fatto prepend solo di a_value, ma t contiene a_value-2", not t.has (other_element_1))
		end

	t_prepend_to_element
		local
			t: INT_LINKED_LIST
		do
			create t
			t.prepend (a_value)
			t.prepend (other_element_1)
			t.last
			assert ("ERRORE: ho fatto prepend di a_value, ma t non contiene a_value?", t.has (a_value))
			assert ("ERRORE: ho fatto append anche di a_value+2 ma t non contiene a_value+2", t.has (other_element_1))
			assert ("ERRORE: l'elemento a_value-2 dovrebbe essere stato messo come primo elemento", t.first_element /= Void and then attached t.first_element as fe implies fe.value = other_element_1)
			assert ("ERRORE: l'indice non è stato aumentato di uno", t.index = t.count)
		end

end
