note
	description: "Test per le feature di tipo stato con creazione esempi"
	author: "Marco Aragona & Gabriele Messina"
	date: "22/03/25"
	revision: "$Revision$"

class
	STATO_TESTS2

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

	value_follows_tests
		do --t_value_follows_single_target_no_value
			assert ("la lista contiene solo a_target, ma la lista trova a_value dopo a_target", not (list_builder.list_T).value_follows (a_value, a_target))

				--	t_value_follows_single_target_single_value

			assert ("non trova a_value dopo a_target", (list_builder.list_TV).value_follows (a_value, a_target))

				--	t_value_follows_single_target_multiple_value

			assert ("non trova a_value dopo a_target", (list_builder.list_VTV).value_follows (a_value, a_target))

				--  t_value_follows_multiple_target_multiple_value_all_before

			assert ("trova a_value dopo a_target", not (list_builder.list_VVTT).value_follows (a_value, a_target))

				--	t_value_follows_multiple_target_multiple_value

			assert ("non trova a_value dopo a_target", (list_builder.list_VTVT).value_follows (a_value, a_target))

				--	t_value_follows_target_far_from_value
				--questo test serve per testare se la feature riesce a trovare a_value molto distante da a_target
			assert (" non trova a_value dopo a_target", (list_builder.list_e1Te2e1e2e1e2e1Ve2).value_follows (a_value, a_target))
		end

	value_after_tests
		do --t_value_after_single_target_no_value

			assert ("la lista contiene solo a_target, ma t trova a_value subito dopo a_target", not (list_builder.list_T).value_after (a_value, a_target))

				--t_value_after_single_target_single_value

			assert ("non trova a_value subito dopo a_target", (list_builder.list_TV).value_after (a_value, a_target))

				--t_value_after_single_target_multiple_value

			assert ("non trova a_value subito dopo a_target", (list_builder.list_VTV).value_after (a_value, a_target))

				--t_value_after_no_after_first
				-- In questo test c'è un a_value dopo un a_target ma è dopo il secondo

			assert ("trova a_value subito dopo il primo a_target", not (list_builder.list_VTTV).value_after (a_value, a_target))

				--t_value_after_multiple_value

			assert ("non trova a_value subito dopo il primo a_target", (list_builder.list_Ve1TV).value_after (a_value, a_target))
		end

	value_precedes_tests

			--	t_value_precedes_single_target_no_value
		do
			assert ("t contiene solo a_target, ma t trova a_value prima di a_target", not (list_builder.list_T).value_precedes (a_value, a_target))

				--	t_value_precedes_single_target_single_value

			assert ("non trova a_value prima di a_target", (list_builder.list_VT).value_precedes (a_value, a_target))

				--	t_value_precedes_single_target_multiple_value

			assert ("non trova a_value prima di a_target", (list_builder.list_VTV).value_precedes (a_value, a_target))

				--	t_value_precedes_multiple_target_multiple_value_all_after

			assert ("trova a_value prima di a_target", not (list_builder.list_TTVV).value_precedes (a_value, a_target))

				--	t_value_precedes_multiple_target_multiple_value

			assert (" non trova a_value prima di a_target", (list_builder.list_VTVT).value_precedes (a_value, a_target))

				--	t_value_precedes_target_far_from_value
				--questo test serve per testare se la feature riesce a trovare a_value molto distante da a_target

			assert (" non trova a_value prima di a_target", (list_builder.list_e1Ve2e1e2e1e2e1T).value_precedes (a_value, a_target))
		end

	value_before_tests

			--	t_value_before_single_target_no_value
		do
			assert ("t contiene solo a_target, ma t trova a_value subito prima di a_target", not (list_builder.list_T).value_before (a_value, a_target))

				--	t_value_before_single_target_single_value

			assert ("non trova a_value subito prima di a_target", (list_builder.list_VT).value_before (a_value, a_target))

				--	t_value_before_single_target_multiple_value

			assert ("non trova a_value subito prima di a_target", (list_builder.list_VTV).value_before (a_value, a_target))

				--	t_value_before_void_before_first
				-- In questo test c'è un a_value prima di un a_target ma è prima del secondo

			assert ("trova a_value subito prima del primo a_target", not (list_builder.list_TVT).value_before (a_value, a_target))

				--	t_value_before_no_before_first
				-- In questo test c'è un a_value prima di un a_target ma è prima del secondo

			assert ("trova a_value subito prima del primo a_target", not (list_builder.list_e1TVT).value_before (a_value, a_target))

				--	t_value_before_multiple_value

			assert ("non trova a_value subito prima del primo a_target", (list_builder.list_Ve1VT).value_before (a_value, a_target))
		end

	index__earliest_of_test

			--t_index_earliest_of_no_value
		do
			assert ("la lista non contiene a_value eppure index_earliest non è 0", (list_builder.list_e1).index_earliest_of (a_value) = 0)

				--t_index_earliest_of_single_value_first

			assert ("la lista contiene a_value come primo eppure index_earliest non è 1", (list_builder.list_Ve1e2).index_earliest_of (a_value) = 1)

				--t_index_earliest_of_single_value_last

			assert ("la lista contiene a_value come ultimo eppure index_earliest non è count", (list_builder.list_e1e2V).index_earliest_of (a_value) = (list_builder.list_e1e2V).count)

				--t_index_earliest_of_single_value_middle

			assert ("la lista contiene a_value in seconda posizione eppure index_earliest non è 2", (list_builder.list_e1Ve2).index_earliest_of (a_value) = 2)

				--	t_index_earliest_of_multiple_value

			assert ("la lista contiene a_value in seconda posizione eppure index_earliest non è 2", (list_builder.list_e1VVe2).index_earliest_of (a_value) = 2)
			assert ("ha selezionato la terza istanza di a_value", (list_builder.list_e1VVe2).index_earliest_of (a_value) /= 3)
		end

	index__latest_of_tests

			--t_index_latest_of_no_value
		do
			assert ("la lista non contiene a_value eppure index_latest non è 0", (list_builder.list_e1).index_latest_of (a_value) = 0)

				--	t_index_latest_of_single_value_first

			assert ("la lista contiene a_value come primo eppure index_latest non è 1", (list_builder.list_Ve1e2).index_latest_of (a_value) = 1)

				--	t_index_latest_of_single_value_last

			assert ("la lista contiene a_value come ultimo eppure index_latest non è count", (list_builder.list_e1e2V).index_latest_of (a_value) = (list_builder.list_e1e2V).count)

				--	t_index_latest_of_single_value_middle

			assert ("la lista contiene a_value in seconda posizione eppure index_latest non è 2", (list_builder.list_e1Ve2).index_latest_of (a_value) = 2)

				--	t_index_latest_of_multiple_value

			assert ("la lista contiene a_value in terza posizione eppure index_latest non è 3", (list_builder.list_e1VVe2).index_latest_of (a_value) = 3)
			assert ("ha selezionato la seconda istanza di a_value", (list_builder.list_e1VVe2).index_latest_of (a_value) /= 2)
		end

	value_at_tests

			--t_value_at_start_in_a_list_of_1
		do
			assert ("l'elemento a posizione 1 non è a_value", (list_builder.list_V).value_at (1) = a_value)

				--	t_value_at_last_in_a_list_of_1

			assert ("l'elemento a posizione 1 non è a_value", (list_builder.list_V).value_at (1) = a_value)

				--	t_value_at_start_in_a_list_of_3

			assert ("l'elemento a posizione 1 non è a_value", (list_builder.list_Ve1e2).value_at (1) = a_value)

				--	t_value_at_last_in_a_list_of_3

			assert ("l'elemento a posizione count non è a_value", (list_builder.list_e1e2V).value_at ((list_builder.list_e1e2V).count) = a_value)

				--	t_value_at_middle_in_a_list_of_3

			assert ("l'elemento ha posizione 2 non è a_value", (list_builder.list_e1Ve2).value_at (2) = a_value)
		end

end
