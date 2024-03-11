note
	description: "Test per feature del tipo inserimento singolo vincolato"
	author: "Gianluca Pastorini"
	date: "12/04/23"
	revision: "$Revision$"

class
	INSERT_SINGLE_TARGETED_TESTS

inherit

	EQA_TEST_SET

feature -- parametri

	a_value: INTEGER = 1

	a_target: INTEGER = 2

	other_element_1: INTEGER = 5

	other_element_2: INTEGER = 7

feature -- supporto

		-- TO DO: le funzioni di supporto how_many/how_many_after/how_many_before possono essere sostituite dalle feature interne
		-- di INT_LINKED_LIST count_of/count_of_after/count_of_before

	how_many (t: INT_LINKED_LIST; value: INTEGER): INTEGER
			-- return how many times `value' occurs in `t'
			-- è identica a count_of, solo che è una funzione esterna alla lista
		local
			current_element: INT_LINKABLE
		do
			if t.count = 0 then
				Result := 0
			else
				from
					current_element := t.first_element
				until
					current_element = Void
				loop
					if current_element.value = value then
						Result := Result + 1
					end
					current_element := current_element.next
				end
			end
		end

feature -- insert_after
	-- Alessandro Filippo, 2020/03/06
	-- riscritto EN, 2021/08/18

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
			t.append (other_element_1)
			t.append (other_element_2)
			t.insert_after (a_value, a_target)
			assert ("errore: insert_after NON inserisce a_value", t.has (a_value))
			assert ("errore: non c'è a_target ma insert_after NON assegna last_element a a_value", attached t.last_element as le implies le.value = a_value)
		end

	t_insert_after_with_target_middle
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (other_element_1)
			t.append (a_target)
			t.append (other_element_2)
			t.insert_after (a_value, a_target)
			assert ("errore: insert_after NON inserisce a_value", t.has (a_value))
			assert ("errore: non inserisce a_value subito dopo a_target", t.value_after (a_value, a_target))
		end

	t_insert_after_with_target_last
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (other_element_1)
			t.append (other_element_2)
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
			t.append (other_element_1)
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
			t.append (other_element_1)
			t.append (other_element_2)
			t.insert_before (a_value, a_target)
			assert ("errore: insert_before NON inserisce a_value", t.has (a_value))
			assert ("errore: non c'è a_target ma insert_before NON assegna first_element a a_value", attached t.first_element as fe implies fe.value = a_value)
		end

	t_insert_before_with_target_middle
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (other_element_1)
			t.append (a_target)
			t.append (other_element_2)
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
			t.append (other_element_1)
			t.append (other_element_2)
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
			t.append (other_element_1)
			t.append (a_target)
			t.append (a_target)
			t.insert_before (a_value, a_target)
			assert ("errore: insert_before NON inserisce a_value", t.has (a_value))
			assert ("errore: non inserisce a_value subito prima a_target", t.value_before (a_value, a_target))
			assert ("errore: non ha inserito a_value prima la PRIMA istanza di a_target", t.value_before (other_element_1, a_value))
		end

end
