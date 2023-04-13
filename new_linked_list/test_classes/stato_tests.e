note
	description: "Test per le feature di tipo stato"
	author: "Gianluca Pastorini"
	date: "05/04/23"
	revision: "$Revision$"

class
	STATO_TESTS

inherit

	STATIC_TESTS

feature -- parametri

	a_value: INTEGER = 1

	a_target: INTEGER = 3

feature -- value_follows
	--Maria Ludovica Sarandrea, 2021/03/26

	t_value_follows_single_target_no_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target)
			assert ("t contiene solo a_target, ma t trova a_value dopo a_target", not t.value_follows (a_value, a_target))
		end

	t_value_follows_single_target_single_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target)
			t.append (a_value)
			assert ("non trova a_value dopo a_target", t.value_follows (a_value, a_target))
		end

	t_value_follows_single_target_multiple_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_target)
			t.append (a_value)
			assert ("non trova a_value dopo a_target", t.value_follows (a_value, a_target))
		end

	t_value_follows_multiple_target_multiple_value_all_before
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value)
			t.append (a_target)
			t.append (a_target)
			assert ("trova a_value dopo a_target", not t.value_follows (a_value, a_target))
		end

	t_value_follows_multiple_target_multiple_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_target)
			t.append (a_value)
			t.append (a_target)
			assert ("non trova a_value dopo a_target", t.value_follows (a_value, a_target))
		end

	t_value_follows_target_far_from_value
			--questo test serve per testare se la feature riesce a trovare a_value molto distante da a_target
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target - 12)
			t.append (a_target)
			t.append (a_target - 12)
			t.append (a_target - 12)
			t.append (a_target - 12)
			t.append (a_target - 12)
			t.append (a_target - 12)
			t.append (a_target - 12)
			t.append (a_value)
			t.append (a_target - 12)
			assert (" non trova a_value dopo a_target", t.value_follows (a_value, a_target))
		end

feature -- value_after
	-- Enrico Nardelli, 2021/03/23

	t_value_after_single_target_no_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target)
			assert ("t contiene solo a_target, ma t trova a_value subito dopo a_target", not t.value_after (a_value, a_target))
		end

	t_value_after_single_target_single_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target)
			t.append (a_value)
			assert ("non trova a_value subito dopo a_target", t.value_after (a_value, a_target))
		end

	t_value_after_single_target_multiple_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_target)
			t.append (a_value)
			assert ("non trova a_value subito dopo a_target", t.value_after (a_value, a_target))
		end

	t_value_after_no_after_first
			-- In questo test c'è un a_value dopo un a_target ma è dopo il secondo
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_target)
			t.append (a_target)
			t.append (a_value)
			assert ("trova a_value subito dopo il primo a_target", not t.value_after (a_value, a_target))
		end

	t_value_after_multiple_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_target - 10)
			t.append (a_target)
			t.append (a_value)
			assert ("non trova a_value subito dopo il primo a_target", t.value_after (a_value, a_target))
		end

feature -- value_precedes

		-- Maria Ludovica Sarandrea, 2021/04/03

	t_value_precedes_single_target_no_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target)
			assert ("t contiene solo a_target, ma t trova a_value prima di a_target", not t.value_precedes (a_value, a_target))
		end

	t_value_precedes_single_target_single_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_target)
			assert ("non trova a_value prima di a_target", t.value_precedes (a_value, a_target))
		end

	t_value_precedes_single_target_multiple_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_target)
			t.append (a_value)
			assert ("non trova a_value prima di a_target", t.value_precedes (a_value, a_target))
		end

	t_value_precedes_multiple_target_multiple_value_all_after
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target)
			t.append (a_target)
			t.append (a_value)
			t.append (a_value)
			assert ("trova a_value prima di a_target", not t.value_precedes (a_value, a_target))
		end

	t_value_precedes_multiple_target_multiple_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_target)
			t.append (a_value)
			t.append (a_target)
			assert (" non trova a_value prima di a_target", t.value_precedes (a_value, a_target))
		end

	t_value_precedes_target_far_from_value
			--questo test serve per testare se la feature riesce a trovare a_value molto distante da a_target
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target - 12)
			t.append (a_value)
			t.append (a_target - 12)
			t.append (a_target - 12)
			t.append (a_target - 12)
			t.append (a_target - 12)
			t.append (a_target - 12)
			t.append (a_target - 12)
			t.append (a_target)
			assert (" non trova a_value prima di a_target", t.value_precedes (a_value, a_target))
		end

feature -- value_before
	--Sara Forte 2021/03/31

	t_value_before_single_target_no_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target)
			assert ("t contiene solo a_target, ma t trova a_value subito prima di a_target", not t.value_before (a_value, a_target))
		end

	t_value_before_single_target_single_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_target)
			assert ("non trova a_value subito prima di a_target", t.value_before (a_value, a_target))
		end

	t_value_before_single_target_multiple_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_target)
			t.append (a_value)
			assert ("non trova a_value subito prima di a_target", t.value_before (a_value, a_target))
		end

	t_value_before_void_before_first
			-- In questo test c'è un a_value prima di un a_target ma è prima del secondo
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target)
			t.append (a_value)
			t.append (a_target)
			assert ("trova a_value subito prima del primo a_target", not t.value_before (a_value, a_target))
		end

	t_value_before_no_before_first
			-- In questo test c'è un a_value prima di un a_target ma è prima del secondo
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 5)
			t.append (a_target)
			t.append (a_value)
			t.append (a_target)
			assert ("trova a_value subito prima del primo a_target", not t.value_before (a_value, a_target))
		end

	t_value_before_multiple_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_target - 10)
			t.append (a_value)
			t.append (a_target)
			assert ("non trova a_value subito prima del primo a_target", t.value_before (a_value, a_target))
		end

feature -- index__earliest_of

	t_index_earliest_of_no_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 4)
			assert ("la lista non contiene a_value eppure index_earliest non è 0", t.index_earliest_of (a_value) = 0)
		end

	t_index_earliest_of_single_value_first
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value - 3)
			t.append (a_value + 2)
			assert ("la lista contiene a_value come primo eppure index_earliest non è 1", t.index_earliest_of (a_value) = 1)
		end

	t_index_earliest_of_single_value_last
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 3)
			t.append (a_value + 2)
			t.append (a_value)
			assert ("la lista contiene a_value come ultimo eppure index_earliest non è count", t.index_earliest_of (a_value) = t.count)
		end

	t_index_earliest_of_single_value_middle
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 3)
			t.append (a_value)
			t.append (a_value + 2)
			assert ("la lista contiene a_value in seconda posizione eppure index_earliest non è 2", t.index_earliest_of (a_value) = 2)
		end

	t_index_earliest_of_multiple_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 3)
			t.append (a_value)
			t.append (a_value)
			t.append (a_value + 2)
			assert ("la lista contiene a_value in seconda posizione eppure index_earliest non è 2", t.index_earliest_of (a_value) = 2)
			assert ("ha selezionato la terza istanza di a_value", t.index_earliest_of (a_value) /= 3)
		end

feature -- index__latest_of

	t_index_latest_of_no_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 4)
			assert ("la lista non contiene a_value eppure index_latest non è 0", t.index_latest_of (a_value) = 0)
		end

	t_index_latest_of_single_value_first
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value - 3)
			t.append (a_value + 2)
			assert ("la lista contiene a_value come primo eppure index_latest non è 1", t.index_latest_of (a_value) = 1)
		end

	t_index_latest_of_single_value_last
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 3)
			t.append (a_value + 2)
			t.append (a_value)
			assert ("la lista contiene a_value come ultimo eppure index_latest non è count", t.index_latest_of (a_value) = t.count)
		end

	t_index_latest_of_single_value_middle
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 3)
			t.append (a_value)
			t.append (a_value + 2)
			assert ("la lista contiene a_value in seconda posizione eppure index_latest non è 2", t.index_latest_of (a_value) = 2)
		end

	t_index_latest_of_multiple_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 3)
			t.append (a_value)
			t.append (a_value)
			t.append (a_value + 2)
			assert ("la lista contiene a_value in terza posizione eppure index_latest non è 3", t.index_latest_of (a_value) = 3)
			assert ("ha selezionato la seconda istanza di a_value", t.index_latest_of (a_value) /= 2)
		end

feature -- value_at

	t_value_at_zero
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			assert ("l'elemento a posizione 0 non è 0", t.value_at (0) = 0)
		end

	t_value_at_first
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value + 3)
			t.append (a_value - 4)
			assert ("l'elemento a posizione 1 non è a_value", t.value_at (1) = a_value)
		end

	t_value_at_last
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 2)
			t.append (a_value + 3)
			t.append (a_value)
			assert ("l'elemento a posizione count non è a_value", t.value_at (t.count) = a_value)
		end

	t_value_at_middle
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 3)
			t.append (a_value)
			t.append (a_value - 4)
			assert ("l'elemento ha posizione 2 non è a_value", t.value_at (2) = a_value)
		end

feature -- is_before

	t_is_before_one_element
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			assert ("in caso di a_value=an_element dovrebbe dare falso come risultato", not t.is_before (t.first_element, t.first_element))
			assert ("active element non è assegnato quindi non può stare prima di first element", not t.is_before (t.active_element, t.first_element))
		end

	t_is_before_multiple_element
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value + 1)
			t.append (a_value + 3)
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

	t_is_before_con_get_element
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value + 2)
			t.append (a_value + 4)
			t.append (a_value)
			assert ("il primo valore di a_value è prima del primo valore di a_value + 4", t.is_before (t.get_element (a_value), t.get_element (a_value + 4)))
			assert ("il primo valore di a_value 2 4 è dopo il primo valore di a_value + 2", not t.is_before (t.get_element (a_value + 4), t.get_element (a_value + 2)))
		end

feature -- position_of

	t_position_of_empty
		local
			t: INT_LINKED_LIST
		do
			create t
			assert ("il primo elemento non esiste eppure la sua posizione non è 0", t.position_of (t.first_element) = 0)
			assert ("l'ultimo elemento non esiste eppure la sua posizione non è 0", t.position_of (t.last_element) = 0)
			assert ("active element non esiste eppure la sua posizione non è 0", t.position_of (t.active_element) = 0)
		end

	t_position_of_one_element
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			assert ("il primo elemento è il primo eppure la sua posizione non è 1", t.position_of (t.first_element) = 1)
			assert ("l'ultimo elemento l'ultimo eppure la sua posizione non è 1", t.position_of (t.last_element) = 1)
			assert ("active element non esiste eppure la sua posizione non è 0", t.position_of (t.active_element) = 0)
		end

	t_position_of_multiple_element
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value - 2)
			t.append (a_value - 4)
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
			assert ("gli elementi di r appartengono a quelli di t", r.position_of (t.first_element) = 0)
		end

end
