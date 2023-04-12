note
	description: "Test per feature del tipo inserimento singolo vincolato"
	author: "Gianluca Pastorini"
	date: "12/04/23"
	revision: "$Revision$"

class
	INSERT_MULTIPLE_TARGETED_TESTS

inherit

	STATIC_TESTS

feature -- parametri

	a_value: INTEGER = 1

	a_target: INTEGER = 2

feature -- t_insert_multiple_after
	-- Sara Forte, 2021/03/30
	-- EN, 2021/08/18

	t_insert_multiple_after_empty
		local
			t: INT_LINKED_LIST
		do
			create t
			t.insert_multiple_after (a_value, a_target)
			assert ("errore: lista vuota ma insert_multiple_after NON inserisce a_value", t.has (a_value))
			assert ("errore: lista vuota ma insert_multiple_after NON assegna first_element a a_value", attached t.first_element as fe implies fe.value = a_value)
			assert ("errore: lista vuota ma insert_multiple_after NON assegna last_element a a_value", attached t.last_element as le implies le.value = a_value)
		end

	t_insert_multiple_after_no_target
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target - 3)
			t.append (a_target - 2)
			t.insert_multiple_after (a_value, a_target)
			assert ("errore: insert_multiple_after NON inserisce a_value", t.has (a_value))
			assert ("errore: la lista non contiente target ma insert_multiple_after NON assegna last_element a a_value", attached t.last_element as le implies le.value = a_value)
		end

	t_insert_multiple_after_single_target_last
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target - 3)
			t.append (a_target - 2)
			t.append (a_target)
			t.insert_multiple_after (a_value, a_target)
			assert ("errore: insert_multiple_after NON inserisce a_value", t.has (a_value))
			assert ("errore: target è ultimo elemento ma insert_multiple_after NON assegna last_element a a_value", attached t.last_element as le implies le.value = a_value)
			assert ("errore: a_value non è subito dopo a_target", t.value_after (a_value, a_target))
		end

	t_insert_multiple_after_single_target_middle
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target - 3)
			t.append (a_target)
			t.append (a_target - 2)
			t.insert_multiple_after (a_value, a_target)
			assert ("errore: insert_multiple_after NON inserisce a_value", t.has (a_value))
			assert ("errore: a_value non è subito dopo a_target", t.value_after (a_value, a_target))
		end

	t_insert_multiple_after_multiple_target
		local
			t: INT_LINKED_LIST
			ct: INTEGER -- count dei target
			cl: INTEGER -- count della lista
		do
			create t
			t.append (a_target - 3)
			t.append (a_target)
			t.append (a_target - 2)
			t.append (a_target)
			ct := t.count_of (a_target)
			cl := t.count
			t.insert_multiple_after (a_value, a_target)
			assert ("errore: insert_multiple_after NON inserisce a_value", t.has (a_value))
			assert ("errore: non ha inserito il numero giusto di elementi", t.count = ct + cl)
			assert ("errore: a_value non è subito dopo a_target", t.value_after (a_value, a_target))
			assert ("errore: target è ultimo elemento ma insert_multiple_after NON assegna last_element a a_value", attached t.last_element as le implies le.value = a_value)
		end

feature -- insert_multiple_before

	t_insert_multiple_before_empty
		local
			t: INT_LINKED_LIST
		do
			create t
			t.insert_multiple_before (a_value, a_target)
			assert ("errore: lista vuota ma insert_multiple_before NON inserisce a_value", t.has (a_value))
			assert ("errore: lista vuota ma insert_multiple_before NON assegna first_element a a_value", attached t.first_element as fe implies fe.value = a_value)
			assert ("errore: lista vuota ma insert_multiple_before NON assegna last_element a a_value", attached t.last_element as le implies le.value = a_value)
		end

	t_insert_multiple_before_no_target
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target - 3)
			t.append (a_target - 2)
			t.insert_multiple_before (a_value, a_target)
			assert ("errore: insert_multiple_before NON inserisce a_value", t.has (a_value))
			assert ("errore: la lista non contiente target ma insert_multiple_before NON assegna first_element a a_value", attached t.first_element as fe implies fe.value = a_value)
		end

	t_insert_multiple_before_single_target_first
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target)
			t.append (a_target - 2)
			t.append (a_target - 4)
			t.insert_multiple_before (a_value, a_target)
			assert ("errore: insert_multiple_before NON inserisce a_value", t.has (a_value))
			assert ("errore: target è il primo elemento ma insert_multiple_before NON assegna first_element a a_value", attached t.first_element as fe implies fe.value = a_value)
			assert ("errore: a_value non è subito dopo a_target", t.value_before (a_value, a_target))
		end

	t_insert_multiple_before_single_target_middle
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target - 3)
			t.append (a_target)
			t.append (a_target - 2)
			t.insert_multiple_before (a_value, a_target)
			assert ("errore: insert_multiple_before NON inserisce a_value", t.has (a_value))
			assert ("errore: a_value non è subito dopo a_target", t.value_before (a_value, a_target))
		end

	t_insert_multiple_before_multiple_target
		local
			t: INT_LINKED_LIST
			ct: INTEGER -- count dei target
			cl: INTEGER -- count della lista
		do
			create t
			t.append (a_target)
			t.append (a_target - 3)
			t.append (a_target)
			t.append (a_target - 2)
			t.append (a_target)
			ct := t.count_of (a_target)
			cl := t.count
			t.insert_multiple_before (a_value, a_target)
			assert ("errore: insert_multiple_before NON inserisce a_value", t.has (a_value))
			assert ("errore: non ha inserito il numero giusto di elementi", t.count = ct + cl)
			assert ("errore: a_value non è subito dopo a_target", t.value_before (a_value, a_target))
			assert ("errore: target è il primo elemento ma insert_multiple_before NON assegna first_element a a_value", attached t.first_element as fe implies fe.value = a_value)
		end

end
