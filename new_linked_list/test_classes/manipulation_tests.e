note
	description: "Test per le feature di tipo MANIPULATION"
	author: "Gianluca Pastorini"
	date: "$03/04/23"
	revision: "$Revision$"

class
	MANIPULATION_TESTS

inherit

	EQA_TEST_SET

feature -- parametri

	a_value: INTEGER = 1

	a_target: INTEGER = 2

	other_element_1: INTEGER = 5

	other_element_2: INTEGER = 7

feature -- invert
	-- Federico Fiorini, 2020/03/08

	t_invert_four_elements_invert
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (other_element_1)
			t.append (other_element_2)
			t.append (- a_value)
			t.invert
			assert ("errore: il numero di elementi della lista è cambiato", t.count = 4)
			t.start
				--siamo al primo elemento
			if attached t.active_element as ae then
				assert ("il primo elemento della lista invertita non risulta l'ultimo della lista originale", ae.value = - a_value)
			end
			t.forth
				--siamo al secondo elemento
			if attached t.active_element as ae then
				assert ("gli elementi in mezzo della lista non si sono scambiati", ae.value = other_element_2)
			end
			t.forth
				--siamo al terzo elemento
			if attached t.active_element as ae then
				assert ("gli elementi in mezzo della lista non si sono scambiati", ae.value = other_element_1)
			end
			t.forth
				--siamo al quarto elemento
			if attached t.active_element as ae then
				assert ("l'ultimo elemento della lista non risulta il primo dell'originale", ae.value = a_value)
			end
		end

	t_invert_three_elements_invert
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (other_element_1)
			t.append (other_element_2)
			t.invert
			assert ("errore: il numero di elementi della lista è cambiato", t.count = 3)
			t.start
				--siamo al primo elemento
			if attached t.active_element as ae then
				assert ("il primo elemento della lista invertita non risulta l'ultimo della lista originale", ae.value = other_element_2)
			end
			t.forth
				--siamo al secondo elemento
			if attached t.active_element as ae then
				assert ("il secondo elemento della lista invertita non risluta il secondo della originale", ae.value = other_element_1)
			end
			t.forth
				--siamo al terzo elemento
			if attached t.active_element as ae then
				assert ("l'ultimo elemento della lista non risulta il primo dell'originale", ae.value = a_value)
			end
		end

	t_invert_index
		local
			t: INT_LINKED_LIST
			k: INTEGER
		do
			create t
			t.append (a_value)
			t.append (other_element_1)
			t.append (other_element_2)
			t.start
			t.invert
			assert ("l'indice non è stato invertito dal primo elemento all'ultimo", t.index = t.count)
			t.invert
				--ritorno alla lista originale
			t.forth
			k := t.index
			t.invert
			assert ("l'indice sarebbe dovuto rimanere fermo", t.index = k)
			t.invert
				--ritorno alla lista originale
			t.forth
			t.invert
			assert ("l'indice non è stato invertito dall'ultimo al primo", t.index = 1)
		end

feature -- head_list

	t_head_list_one_element
			-- lista con solo un elemento
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			assert ("errore: l'unico elemento non coincide con quello della lista originale", attached t.head_list (1).first_element as fe implies fe.value = a_value)
		end

	t_head_list_three_element_copy_two
			-- lista con tre elementi e ne copio due
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (other_element_1)
			t.append (other_element_2)
			assert ("errore: il primo elemento non coincide con quello della lista originale", attached t.head_list (2).first_element as fe implies fe.value = a_value)
			assert ("errore: il secondo elemento non coincide con quello della lista originale", attached t.head_list (2).last_element as fe implies fe.value = other_element_1)
		end

	t_head_list_three_element_three_coopy
			-- lista con tre elementi e ne copio tre
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (other_element_1)
			t.append (other_element_2)
			assert ("errore: il primo elemento non coincide con quello della lista originale", attached t.head_list (3).first_element as fe implies fe.value = a_value)
			assert ("errore: l'ultimo elemento non coincide con quello della lista originale", attached t.head_list (3).last_element as fe implies fe.value = other_element_2)
		end

	t_head_list_does_not_copy_changes
			-- questo test serve per vedere che cambiamenti sulla lista originale non portano cambiamenti sulla nuova lista
		local
			t: INT_LINKED_LIST
			r: INT_LINKED_LIST
		do
			create t
			create r
			t.append (a_value)
			t.append (other_element_1)
			t.append (other_element_2)
			t.append (other_element_1)
			t.append (other_element_2)
			r := t.head_list (3)
			t.prepend (other_element_1)
			assert ("Il primo elemento della testa è stato modificato", r.first_element /= Void and then attached r.first_element as fe implies fe.value = a_value)
		end

	t_head_list_does_not_change_original
			-- questo test serve per vedere che cambiamenti sulla nuova lista non portano cambiamenti sull'originale
		local
			t: INT_LINKED_LIST
			r: INT_LINKED_LIST
		do
			create t
			create r
			t.append (a_value)
			t.append (other_element_1)
			t.append (other_element_2)
			t.append (other_element_1)
			t.append (other_element_2)
			r := t.head_list (3)
			r.prepend (other_element_1)
			assert ("Il primo elemento dell'originale è stato modificato", t.first_element /= Void and then attached t.first_element as fe implies fe.value = a_value)
		end

feature -- tail_list

	t_tail_list_one_element
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			assert ("errore: l'unico elemento non coincide con quello della lista originale", attached t.tail_list (1).first_element as fe implies fe.value = a_value)
		end

	t_tail_list_three_element_copy_two
			-- lista con tre elementi e ne copio due
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (other_element_1)
			t.append (other_element_2)
			assert ("errore: il penultimo elemento non coincide con quello della lista originale", t.tail_list (2).first_element /= Void and attached t.tail_list (2).first_element as fe implies fe.value = other_element_1)
			assert ("errore: l'ultimo elemento non coincide con quello della lista originale", attached t.tail_list (2).last_element as fe implies fe.value = other_element_2)
		end

	t_tail_list_three_element_three_coopy
			-- lista con tre elementi e ne copio tre
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (other_element_1)
			t.append (other_element_2)
			assert ("errore: il primo elemento non coincide con quello della lista originale", attached t.tail_list (3).first_element as fe implies fe.value = a_value)
			assert ("errore: l'ultimo elemento non coincide con quello della lista originale", attached t.tail_list (3).last_element as fe implies fe.value = other_element_2)
		end

	t_tail_list_does_not_copy_changes
			-- questo test serve per vedere che cambiamenti sulla lista originale non portano cambiamenti sulla nuova lista
		local
			t: INT_LINKED_LIST
			r: INT_LINKED_LIST
		do
			create t
			create r
			t.append (other_element_1)
			t.append (other_element_2)
			t.append (other_element_1)
			t.append (other_element_2)
			t.append (a_target)
			r := t.tail_list (3)
			t.append (a_value)
			assert ("L'ultimo elemento della coda è stato modificato", r.last_element /= Void and then attached r.last_element as le implies le.value = a_target)
		end

	t_tail_list_does_not_change_original
			-- questo test serve per vedere che cambiamenti sulla nuova lista non portano cambiamenti sull'originale
		local
			t: INT_LINKED_LIST
			r: INT_LINKED_LIST
		do
			create t
			create r
			t.append (a_value)
			t.append (other_element_1)
			t.append (other_element_2)
			t.append (other_element_1)
			t.append (a_target)
			r := t.tail_list (3)
			r.append (a_value)
			assert ("L'ultimo elemento dell'originale è stato modificato", t.last_element /= Void and then attached t.last_element as le implies le.value = a_target)
		end

end
