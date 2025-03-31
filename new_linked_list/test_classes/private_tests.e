note
	description: "Test per le feature di tipo stato con creazione esempi"
	author: "Marco Aragona & Gabriele Messina"
	date: "22/03/25"
	revision: "$Revision$"


class
	PRIVATE_TESTS

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

	a_target: INTEGER = 3

	other_element_1: INTEGER = 5

	other_element_2: INTEGER = 7

feature --test
	is_before_tests

			--t_is_before_one_element
		do
			assert ("in caso di a_value=an_element dovrebbe dare falso come risultato", not (list_builder.list_V).is_before ((list_builder.list_V).first_element, (list_builder.list_V).first_element))
			assert ("active element non è assegnato quindi non può stare prima di first element", not (list_builder.list_V).is_before ((list_builder.list_V).active_element, (list_builder.list_V).first_element))

				--	t_is_before_multiple_element

			(list_builder.list_Ve1e2).last
				-- imposto active_element a last_element
			assert ("last_element dovrebbe essere dopo first_element", (list_builder.list_Ve1e2).is_before ((list_builder.list_Ve1e2).first_element, (list_builder.list_Ve1e2).active_element))
			assert ("in caso di a_value=an_element dovrebbe dare falso come risultato", not (list_builder.list_Ve1e2).is_before ((list_builder.list_Ve1e2).last_element, (list_builder.list_Ve1e2).active_element))
			(list_builder.list_Ve1e2).go_i_th (1)
			(list_builder.list_Ve1e2).forth
				-- imposto active_element al secondo elemento
			assert ("il secondo elemento dovrebbe essere dopo first_element", not (list_builder.list_Ve1e2).is_before ((list_builder.list_Ve1e2).active_element, (list_builder.list_Ve1e2).first_element))
			assert ("il secondo elemento dovrebbe essere prima di last_element", (list_builder.list_Ve1e2).is_before ((list_builder.list_Ve1e2).active_element, (list_builder.list_Ve1e2).last_element))
			assert ("l'ultimo elemento dovrebbe essere dopo primo", not (list_builder.list_Ve1e2).is_before ((list_builder.list_Ve1e2).last_element, (list_builder.list_Ve1e2).first_element))
			(list_builder.list_Ve1e2).go_i_th (1)
		end

	position_of_tests
		local
			list_V_duplicate: INT_LINKED_LIST
			--	t_position_of_empty
		do
			assert ("il primo elemento non esiste eppure la sua posizione non è 0", (list_builder.list_empty).position_of ((list_builder.list_empty).first_element) = 0)
			assert ("l'ultimo elemento non esiste eppure la sua posizione non è 0", (list_builder.list_empty).position_of ((list_builder.list_empty).last_element) = 0)
			assert ("active element non esiste eppure la sua posizione non è 0", (list_builder.list_empty).position_of ((list_builder.list_empty).active_element) = 0)

				--	t_position_of_one_element

			assert ("il primo elemento è il primo eppure la sua posizione non è 1", (list_builder.list_V).position_of ((list_builder.list_V).first_element) = 1)
			assert ("l'ultimo elemento l'ultimo eppure la sua posizione non è 1", (list_builder.list_V).position_of ((list_builder.list_V).last_element) = 1)
			assert ("active element non esiste eppure la sua posizione non è 0", (list_builder.list_V).position_of ((list_builder.list_V).active_element) = 0)

				--	t_position_of_multiple_element

			assert ("il primo elemento non esiste eppure la sua posizione non è 1", (list_builder.list_Ve1e2).position_of ((list_builder.list_Ve1e2).first_element) = 1)
			assert ("l'ultimo elemento non esiste eppure la sua posizione non è 3", (list_builder.list_Ve1e2).position_of ((list_builder.list_Ve1e2).last_element) = 3)
			assert ("active element non esiste eppure la sua posizione non è 0", (list_builder.list_Ve1e2).position_of ((list_builder.list_Ve1e2).active_element) = 0)
			(list_builder.list_Ve1e2).go_i_th (2)
			assert ("active element è in seconda posizione ma la sua posizione non è 2", (list_builder.list_Ve1e2).position_of ((list_builder.list_Ve1e2).active_element) = 2)
			(list_builder.list_Ve1e2).go_i_th (1)

				--	t_position_of_with_external

			create list_V_duplicate
			list_V_duplicate.append (a_value)
			assert ("gli elementi di list_V_duplicate appartengono a quelli di (list_builder.list_V)", (list_builder.list_V).position_of (list_V_duplicate.first_element) = 0)
			assert ("gli elementi di (list_builder.list_V) appartengono a quelli di list_V_duplicate", list_V_duplicate.position_of ((list_builder.list_V).first_element) = 0)
		end
end
