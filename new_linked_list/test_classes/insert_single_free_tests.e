note
	description: "Test per feature del tipo inserimento singolo libero"
	author: "Gianluca Pastorini"
	date: "08/04/23"
	revision: "$Revision$"

class
	INSERT_SINGLE_FREE_TESTS

inherit

	STATIC_TESTS

feature -- parametri

	a_value: INTEGER = 1

feature -- append
	-- Enrico Nardelli, 2020/03/06

	t_append_empty
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			assert ("ERRORE: ho fatto append di a_value, ma t non contiene a_value", t.has (a_value))
			assert ("ERRORE: ho fatto append solo di a_value, ma t contiene a_value+2", not t.has (a_value + 2))
		end

	t_append_to_element
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value - 2)
			assert ("ERRORE: ho fatto append di a_value, ma t non contiene a_value", t.has (a_value))
			assert ("ERRORE: ho fatto append anche di a_value-2 ma t non contiene a_value-2", t.has (a_value - 2))
			assert ("ERRORE: l'elemento a_value-2 dovrebbe essere stato messo come ultimo elemento", t.last_element /= Void and then attached t.last_element as le implies le.value = a_value - 2)
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
			assert ("ERRORE: ho fatto prepend solo di a_value, ma t contiene a_value-2", not t.has (a_value - 2))
		end

	t_prepend_to_element
		local
			t: INT_LINKED_LIST
		do
			create t
			t.prepend (a_value)
			t.prepend (a_value + 2)
			t.last
			assert ("ERRORE: ho fatto prepend di a_value, ma t non contiene a_value?", t.has (a_value))
			assert ("ERRORE: ho fatto append anche di a_value+2 ma t non contiene a_value+2", t.has (a_value + 2))
			assert ("ERRORE: l'elemento a_value-2 dovrebbe essere stato messo come primo elemento", t.first_element /= Void and then attached t.first_element as fe implies fe.value = a_value + 2)
			assert ("ERRORE: l'indice non è stato aumentato di uno", t.index = t.count)
		end

end
