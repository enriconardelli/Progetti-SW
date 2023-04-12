note
	description: "Test per feature del tipo inserimento singolo libero"
	author: "Gianluca Pastorini"
	date: "12/04/23"
	revision: "$Revision$"

class
	INSERT_SINGLE_TARGETED

inherit

	STATIC_TESTS

feature -- insert_after
	-- Alessandro Filippo, 2020/03/06
	-- riscritto EN, 2021/08/18

	a_value: INTEGER = 1

	a_target: INTEGER = 2

	t_insert_after_void
		local
			t: INT_LINKED_LIST
		do
			create t
			t.insert_after (a_value, a_target)
			assert ("errore: lista è vuota, ma insert_after NON inserisce a_value", t.has (a_value))
			assert ("errore: lista è vuota, ma insert_after NON assegna first_element a a_value", attached t.first_element as fe implies fe.value = a_value)
			assert ("errore: lista è vuota, ma insert_after NON assegna last_element a a_value", attached t.last_element as le implies le.value = a_value)
		end

	t_insert_after_no_target
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target - 2)
			t.append (a_target + 2)
			t.insert_after (a_value, a_target)
			assert ("errore: insert_after NON inserisce a_value", t.has (a_value))
			assert ("errore: non c'è a_target ma insert_after NON assegna last_element a a_value", attached t.last_element as le implies le.value = a_value)
		end

	t_insert_after_with_target_middle
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target - 2)
			t.append (a_target)
			t.append (a_target - 4)
			t.insert_after (a_value, a_target)
			assert ("errore: insert_after NON inserisce a_value", t.has (a_value))
			assert ("errore: non inserisce a_value subito dopo a_target", t.value_after (a_value, a_target))
		end

	t_insert_after_with_target_last
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target - 2)
			t.append (a_target - 3)
			t.append (a_target)
			t.insert_after (a_value, a_target)
			assert ("errore: insert_after NON inserisce a_value", t.has (a_value))
			assert ("errore: non inserisce a_value subito dopo a_target", t.value_after (a_value, a_target))
			assert ("errore: a_target è l'ultimo valore ma insert_after NON assegna last_element a a_value", attached t.last_element as le implies le.value = a_value)
		end

	t_insert_after_with_multiple_target
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target - 2)
			t.append (a_target)
			t.append (a_target)
			t.insert_after (a_value, a_target)
			assert ("errore: insert_after NON inserisce a_value", t.has (a_value))
			assert ("errore: non inserisce a_value subito dopo a_target", t.value_after (a_value, a_target))
			assert ("errore: non ha inserito a_value dopo la PRIMA istanza di a_target", t.last_element /= Void and then attached t.last_element as le implies le.value = a_target)
		end

feature -- insert_before

		-- Maria Ludovica Sarandrea, 2021/03/26
		-- EN, 2021/08/18

	t_insert_before_Void
		local
			t: INT_LINKED_LIST
		do
			create t
			t.insert_before (a_value, a_target)
			assert ("errore: lista è vuota, ma insert_after NON inserisce a_value", t.has (a_value))
			assert ("errore: lista è vuota, ma insert_after NON assegna first_element a a_value", attached t.first_element as fe implies fe.value = a_value)
			assert ("errore: lista è vuota, ma insert_after NON assegna last_element a a_value", attached t.last_element as le implies le.value = a_value)
		end

	t_insert_before_no_target
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target - 2)
			t.append (a_target + 2)
			t.insert_before (a_value, a_target)
			assert ("errore: insert_before NON inserisce a_value", t.has (a_value))
			assert ("errore: non c'è a_target ma insert_before NON assegna first_element a a_value", attached t.first_element as fe implies fe.value = a_value)
		end

	t_insert_before_with_target_middle
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target - 2)
			t.append (a_target)
			t.append (a_target - 4)
			t.insert_before (a_value, a_target)
			assert ("errore: insert_before NON inserisce a_value", t.has (a_value))
			assert ("errore: non inserisce a_value subito prima a_target", t.value_before (a_value, a_target))
		end

	t_insert_before_with_target_first
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target)
			t.append (a_target - 3)
			t.append (a_target - 2)
			t.insert_before (a_value, a_target)
			assert ("errore: insert_before NON inserisce a_value", t.has (a_value))
			assert ("errore: non inserisce a_value subito prima a_target", t.value_before (a_value, a_target))
			assert ("errore: a_target è il primo valore ma insert_before NON assegna first_element a a_value", attached t.first_element as fe implies fe.value = a_value)
		end

	t_insert_before_with_multiple_target
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_target - 3)
			t.append (a_target)
			t.append (a_target)
			t.insert_before (a_value, a_target)
			assert ("errore: insert_before NON inserisce a_value", t.has (a_value))
			assert ("errore: non inserisce a_value subito prima a_target", t.value_before (a_value, a_target))
			assert ("errore: non ha inserito a_value prima la PRIMA istanza di a_target", t.value_before (a_target - 3, a_value))
		end

end
