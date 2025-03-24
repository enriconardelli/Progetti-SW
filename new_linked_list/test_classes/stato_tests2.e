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
        	create list_builder.make(a_value, a_target, other_element_1, other_element_2)
        end

feature -- parametri

	list_builder : LIST_BUILDER

	a_value: INTEGER = 1

	a_target: INTEGER = 3

	other_element_1: INTEGER = 5

	other_element_2: INTEGER = 7

feature -- value_follows

	t_value_follows_single_target_no_value
		do
			assert ("la lista contiene solo a_target, ma la lista trova a_value dopo a_target", not (list_builder.list_T).value_follows (a_value, a_target))
		end

	t_value_follows_single_target_single_value
		do
			assert ("non trova a_value dopo a_target", (list_builder.list_TV).value_follows (a_value, a_target))
		end

	t_value_follows_single_target_multiple_value
		do
			assert ("non trova a_value dopo a_target",(list_builder.list_VTV).value_follows (a_value, a_target))
		end

	t_value_follows_multiple_target_multiple_value_all_before
		do
			assert ("trova a_value dopo a_target", not (list_builder.list_VVTT).value_follows (a_value, a_target))
		end

	t_value_follows_multiple_target_multiple_value
		do
			assert ("non trova a_value dopo a_target", (list_builder.list_VTVT).value_follows (a_value, a_target))
		end

	t_value_follows_target_far_from_value
			--questo test serve per testare se la feature riesce a trovare a_value molto distante da a_target
		do
			assert (" non trova a_value dopo a_target", (list_builder.list_e1Te2e1e2e1e2e1Ve2).value_follows (a_value, a_target))
		end

feature -- value_after

	t_value_after_single_target_no_value
		do
			assert ("la lista contiene solo a_target, ma t trova a_value subito dopo a_target", not (list_builder.list_T).value_after (a_value, a_target))
		end

	t_value_after_single_target_single_value
		do
			assert ("non trova a_value subito dopo a_target", (list_builder.list_TV).value_after (a_value, a_target))
		end

	t_value_after_single_target_multiple_value
		do
			assert ("non trova a_value subito dopo a_target", (list_builder.list_VTV).value_after (a_value, a_target))
		end

	t_value_after_no_after_first
			-- In questo test c'è un a_value dopo un a_target ma è dopo il secondo
		do
			assert ("trova a_value subito dopo il primo a_target", not (list_builder.list_VTTV).value_after (a_value, a_target))
		end

	t_value_after_multiple_value
		do
			assert ("non trova a_value subito dopo il primo a_target", (list_builder.list_Ve1TV).value_after (a_value, a_target))
		end

feature -- value_precedes

	t_value_precedes_single_target_no_value
		do
			assert ("t contiene solo a_target, ma t trova a_value prima di a_target", not (list_builder.list_T).value_precedes (a_value, a_target))
		end

	t_value_precedes_single_target_single_value
		do
			assert ("non trova a_value prima di a_target", (list_builder.list_VT).value_precedes (a_value, a_target))
		end

	t_value_precedes_single_target_multiple_value
		do
			assert ("non trova a_value prima di a_target", (list_builder.list_VTV).value_precedes (a_value, a_target))
		end

	t_value_precedes_multiple_target_multiple_value_all_after
		do
			assert ("trova a_value prima di a_target", not (list_builder.list_TTVV).value_precedes (a_value, a_target))
		end

	t_value_precedes_multiple_target_multiple_value
		do
			assert (" non trova a_value prima di a_target", (list_builder.list_VTVT).value_precedes (a_value, a_target))
		end

	t_value_precedes_target_far_from_value
			--questo test serve per testare se la feature riesce a trovare a_value molto distante da a_target
		do
			assert (" non trova a_value prima di a_target", (list_builder.list_e1Ve2e1e2e1e2e1T).value_precedes (a_value, a_target))
		end

feature -- value_before

	t_value_before_single_target_no_value
		do
			assert ("t contiene solo a_target, ma t trova a_value subito prima di a_target", not (list_builder.list_T).value_before (a_value, a_target))
		end

	t_value_before_single_target_single_value
		do
			assert ("non trova a_value subito prima di a_target", (list_builder.list_VT).value_before (a_value, a_target))
		end

	t_value_before_single_target_multiple_value
		do
			assert ("non trova a_value subito prima di a_target", (list_builder.list_VTV).value_before (a_value, a_target))
		end

	t_value_before_void_before_first
			-- In questo test c'è un a_value prima di un a_target ma è prima del secondo
		do
			assert ("trova a_value subito prima del primo a_target", not (list_builder.list_TVT).value_before (a_value, a_target))
		end

	t_value_before_no_before_first
			-- In questo test c'è un a_value prima di un a_target ma è prima del secondo
		do
			assert ("trova a_value subito prima del primo a_target", not (list_builder.list_e1TVT).value_before (a_value, a_target))
		end

	t_value_before_multiple_value
		do
			assert ("non trova a_value subito prima del primo a_target", (list_builder.list_Ve1VT).value_before (a_value, a_target))
		end

feature -- index__earliest_of

	t_index_earliest_of_no_value
		do
			assert ("la lista non contiene a_value eppure index_earliest non è 0", (list_builder.list_e1).index_earliest_of (a_value) = 0)
		end

	t_index_earliest_of_single_value_first
		do
			assert ("la lista contiene a_value come primo eppure index_earliest non è 1", (list_builder.list_Ve1e2).index_earliest_of (a_value) = 1)
		end

	t_index_earliest_of_single_value_last
		do
			assert ("la lista contiene a_value come ultimo eppure index_earliest non è count", (list_builder.list_e1e2V).index_earliest_of (a_value) = (list_builder.list_e1e2V).count)
		end

	t_index_earliest_of_single_value_middle
		do
			assert ("la lista contiene a_value in seconda posizione eppure index_earliest non è 2", (list_builder.list_e1Ve2).index_earliest_of (a_value) = 2)
		end

	t_index_earliest_of_multiple_value
		do
			assert ("la lista contiene a_value in seconda posizione eppure index_earliest non è 2", (list_builder.list_e1VVe2).index_earliest_of (a_value) = 2)
			assert ("ha selezionato la terza istanza di a_value", (list_builder.list_e1VVe2).index_earliest_of (a_value) /= 3)
		end

feature -- index__latest_of

	t_index_latest_of_no_value
		do
			assert ("la lista non contiene a_value eppure index_latest non è 0", (list_builder.list_e1).index_latest_of (a_value) = 0)
		end

	t_index_latest_of_single_value_first
		do
			assert ("la lista contiene a_value come primo eppure index_latest non è 1", (list_builder.list_Ve1e2).index_latest_of (a_value) = 1)
		end

	t_index_latest_of_single_value_last
		do
			assert ("la lista contiene a_value come ultimo eppure index_latest non è count", (list_builder.list_e1e2V).index_latest_of (a_value) = (list_builder.list_e1e2V).count)
		end

	t_index_latest_of_single_value_middle
		do
			assert ("la lista contiene a_value in seconda posizione eppure index_latest non è 2", (list_builder.list_e1Ve2).index_latest_of (a_value) = 2)
		end

	t_index_latest_of_multiple_value
		do
			assert ("la lista contiene a_value in terza posizione eppure index_latest non è 3", (list_builder.list_e1VVe2).index_latest_of (a_value) = 3)
			assert ("ha selezionato la seconda istanza di a_value", (list_builder.list_e1VVe2).index_latest_of (a_value) /= 2)
		end

feature -- value_at

	t_value_at_start_in_a_list_of_1
		do
			assert ("l'elemento a posizione 1 non è a_value", (list_builder.list_V).value_at (1) = a_value)
		end

	t_value_at_last_in_a_list_of_1
		do
			assert ("l'elemento a posizione 1 non è a_value", (list_builder.list_V).value_at (1) = a_value)
		end

	t_value_at_start_in_a_list_of_3
		do
			assert ("l'elemento a posizione 1 non è a_value", (list_builder.list_Ve1e2).value_at (1) = a_value)
		end

	t_value_at_last_in_a_list_of_3
		do
			assert ("l'elemento a posizione count non è a_value", (list_builder.list_e1e2V).value_at ((list_builder.list_e1e2V).count) = a_value)
		end

	t_value_at_middle_in_a_list_of_3
		do
			assert ("l'elemento ha posizione 2 non è a_value", (list_builder.list_e1Ve2).value_at (2) = a_value)
		end

feature -- is_before

	t_is_before_one_element
		do
			assert ("in caso di a_value=an_element dovrebbe dare falso come risultato", not (list_builder.list_V).is_before ((list_builder.list_V).first_element, (list_builder.list_V).first_element))
			assert ("active element non è assegnato quindi non può stare prima di first element", not (list_builder.list_V).is_before ((list_builder.list_V).active_element, (list_builder.list_V).first_element))
		end

t_is_before_multiple_element
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (other_element_1)
			t.append (other_element_2)
			t.last
				-- imposto active_element a last_element
			assert ("last_element dovrebbe essere dopo first_element", t.is_before (t.first_element, t.active_element))
			assert ("in caso di a_value=an_element dovrebbe dare falso come risultato", not t.is_before (t.last_element, t.active_element))
			t.start
			t.forth
				-- imposto active_element al secondo elemento
			assert ("il secondo elemento dovrebbe essere dopo first_element", not t.is_before (t.active_element, t.first_element))
			assert ("il secondo elemento dovrebbe essere prima di last_element", t.is_before (t.active_element, t.last_element))
			assert ("l'ultimo elemento dovrebbe essere dopo primo", not t.is_before (t.last_element, t.first_element))
		end

feature -- position_of

	t_position_of_empty
		local
			t: INT_LINKED_LIST
		do
			create t
			assert ("il primo elemento non esiste eppure la sua posizione non è 0", (list_builder.list_empty).position_of ((list_builder.list_empty).first_element) = 0)
			assert ("l'ultimo elemento non esiste eppure la sua posizione non è 0", (list_builder.list_empty).position_of ((list_builder.list_empty).last_element) = 0)
			assert ("active element non esiste eppure la sua posizione non è 0", (list_builder.list_empty).position_of ((list_builder.list_empty).active_element) = 0)
		end

	t_position_of_one_element
		do
			assert ("il primo elemento è il primo eppure la sua posizione non è 1", (list_builder.list_V).position_of ((list_builder.list_V).first_element) = 1)
			assert ("l'ultimo elemento l'ultimo eppure la sua posizione non è 1", (list_builder.list_V).position_of ((list_builder.list_V).last_element) = 1)
			assert ("active element non esiste eppure la sua posizione non è 0", (list_builder.list_V).position_of ((list_builder.list_V).active_element) = 0)
		end

	t_position_of_multiple_element --da fare
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (other_element_1)
			t.append (other_element_2)
			assert ("il primo elemento non esiste eppure la sua posizione non è 1", t.position_of (t.first_element) = 1)
			assert ("l'ultimo elemento non esiste eppure la sua posizione non è 3", t.position_of (t.last_element) = 3)
			assert ("active element non esiste eppure la sua posizione non è 0", t.position_of (t.active_element) = 0)
			t.go_i_th (2)
			assert ("active element è in seconda posizione ma la sua posizione non è 2", t.position_of (t.active_element) = 2)
		end

	t_position_of_with_external
		local
			t: INT_LINKED_LIST
			r: INT_LINKED_LIST
		do
			create t
			create r
			t.append (a_value)
			r.append (a_value)
			assert ("gli elementi di r appartengono a quelli di t", t.position_of (r.first_element) = 0)
			assert ("gli elementi di t appartengono a quelli di r", r.position_of (t.first_element) = 0)
		end

end
