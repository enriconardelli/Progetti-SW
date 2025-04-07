note
	description: "Test per le feature di tipo COMPUTATION"
	author: "Marco Aragona & Gabriele Messina"
	date: "29/03/25"
	revision: "$Revision$"

class
	MANIPULATION_TESTS2
inherit

	EQA_TEST_SET
		redefine
			on_prepare
		end

feature -- creazione istanza di List_Builder

	on_prepare
		do
			create a_list_builder
		end

feature -- parametri

	a_list_builder: LIST_BUILDER

feature -- t_invert
	-- Federico Fiorini, 2020/03/08

	t_invert_four_elements_invert
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_list_builder.a_value)
			t.append (a_list_builder.other_element_1)
			t.append (a_list_builder.other_element_2)
			t.append (- a_list_builder.a_value)
			t.invert
			assert ("errore: il numero di elementi della lista è cambiato", t.count = 4)
			t.start
				--siamo al primo elemento
			if attached t.active_element as ae then
				assert ("il primo elemento della lista invertita non risulta l'ultimo della lista originale", ae.value = - a_list_builder.a_value)
			end
			t.forth
				--siamo al secondo elemento
			if attached t.active_element as ae then
				assert ("gli elementi in mezzo della lista non si sono scambiati", ae.value = a_list_builder.other_element_2)
			end
			t.forth
				--siamo al terzo elemento
			if attached t.active_element as ae then
				assert ("gli elementi in mezzo della lista non si sono scambiati", ae.value = a_list_builder.other_element_1)
			end
			t.forth
				--siamo al quarto elemento
			if attached t.active_element as ae then
				assert ("l'ultimo elemento della lista non risulta il primo dell'originale", ae.value = a_list_builder.a_value)
			end
		end

	t_invert_three_elements_invert
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_list_builder.a_value)
			t.append (a_list_builder.other_element_1)
			t.append (a_list_builder.other_element_2)
			t.invert
			assert ("errore: il numero di elementi della lista è cambiato", t.count = 3)
			t.start
				--siamo al primo elemento
			if attached t.active_element as ae then
				assert ("il primo elemento della lista invertita non risulta l'ultimo della lista originale", ae.value = a_list_builder.other_element_2)
			end
			t.forth
				--siamo al secondo elemento
			if attached t.active_element as ae then
				assert ("il secondo elemento della lista invertita non risluta il secondo della originale", ae.value = a_list_builder.other_element_1)
			end
			t.forth
				--siamo al terzo elemento
			if attached t.active_element as ae then
				assert ("l'ultimo elemento della lista non risulta il primo dell'originale", ae.value = a_list_builder.a_value)
			end
		end

	t_invert_index
		local
			t: INT_LINKED_LIST
			k: INTEGER
		do
			create t
			t.append (a_list_builder.a_value)
			t.append (a_list_builder.other_element_1)
			t.append (a_list_builder.other_element_2)
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

feature --t_head
	t_head_list
	local
		t1: INT_LINKED_LIST
		t2: INT_LINKED_LIST
		r1: INT_LINKED_LIST
		r2: INT_LINKED_LIST

	do
	--t_head_list_one_element
			-- lista con solo un elemento

			assert ("errore: l'unico elemento non coincide con quello della lista originale", attached (a_list_builder.list_V).head_list (1).first_element as fe implies fe.value = a_list_builder.a_value)


	--t_head_list_three_element_copy_two
			-- lista con tre elementi e ne copio due

			assert ("errore: il primo elemento non coincide con quello della lista originale", attached (a_list_builder.list_Ve1e2).head_list (2).first_element as fe implies fe.value = a_list_builder.a_value)
			assert ("errore: il secondo elemento non coincide con quello della lista originale", attached (a_list_builder.list_Ve1e2).head_list (2).last_element as fe implies fe.value = a_list_builder.other_element_1)


	--t_head_list_three_element_three_coopy
			-- lista con tre elementi e ne copio tre


			assert ("errore: il primo elemento non coincide con quello della lista originale", attached (a_list_builder.list_Ve1e2).head_list (3).first_element as fe implies fe.value = a_list_builder.a_value)
			assert ("errore: l'ultimo elemento non coincide con quello della lista originale", attached (a_list_builder.list_Ve1e2).head_list (3).last_element as fe implies fe.value = a_list_builder.other_element_2)


	--t_head_list_does_not_copy_changes
			-- questo test serve per vedere che cambiamenti sulla lista originale non portano cambiamenti sulla nuova lista
			create t1
			create r1
			t1.append (a_list_builder.a_value)
			t1.append (a_list_builder.other_element_1)
			t1.append (a_list_builder.other_element_2)
			t1.append (a_list_builder.other_element_1)
			t1.append (a_list_builder.other_element_2)
			r1 := t1.head_list (3)
			t1.prepend (a_list_builder.other_element_1)
			assert ("Il primo elemento della testa è stato modificato", r1.first_element /= Void and then attached r1.first_element as fe implies fe.value = a_list_builder.a_value)


	--t_head_list_does_not_change_original
			-- questo test serve per vedere che cambiamenti sulla nuova lista non portano cambiamenti sull'originale
			create t2
			create r2
			t2.append (a_list_builder.a_value)
			t2.append (a_list_builder.other_element_1)
			t2.append (a_list_builder.other_element_2)
			t2.append (a_list_builder.other_element_1)
			t2.append (a_list_builder.other_element_2)
			r2 := t2.head_list (3)
			r2.prepend (a_list_builder.other_element_1)
			assert ("Il primo elemento dell'originale è stato modificato", t2.first_element /= Void and then attached t2.first_element as fe implies fe.value = a_list_builder.a_value)
		end

feature --t_tail
	t_tail_list
	local
		t1: INT_LINKED_LIST
		t2: INT_LINKED_LIST
		r1: INT_LINKED_LIST
		r2: INT_LINKED_LIST
	do

--	t_tail_list_one_element

			assert ("errore: l'unico elemento non coincide con quello della lista originale", attached (a_list_builder.list_V).tail_list (1).first_element as fe implies fe.value = a_list_builder.a_value)


--	t_tail_list_three_element_copy_two
			-- lista con tre elementi e ne copio due

			assert ("errore: il penultimo elemento non coincide con quello della lista originale", (a_list_builder.list_Ve1e2).tail_list (2).first_element /= Void and attached (a_list_builder.list_Ve1e2).tail_list (2).first_element as fe implies fe.value = a_list_builder.other_element_1)
			assert ("errore: l'ultimo elemento non coincide con quello della lista originale", attached (a_list_builder.list_Ve1e2).tail_list (2).last_element as fe implies fe.value = a_list_builder.other_element_2)


--	t_tail_list_three_element_three_coopy
			-- lista con tre elementi e ne copio tre

			assert ("errore: il primo elemento non coincide con quello della lista originale", attached (a_list_builder.list_Ve1e2).tail_list (3).first_element as fe implies fe.value = a_list_builder.a_value)
			assert ("errore: l'ultimo elemento non coincide con quello della lista originale", attached (a_list_builder.list_Ve1e2).tail_list (3).last_element as fe implies fe.value = a_list_builder.other_element_2)


--	t_tail_list_does_not_copy_changes
			-- questo test serve per vedere che cambiamenti sulla lista originale non portano cambiamenti sulla nuova lista
			create t1
			create r1
			t1.append (a_list_builder.other_element_1)
			t1.append (a_list_builder.other_element_2)
			t1.append (a_list_builder.other_element_1)
			t1.append (a_list_builder.other_element_2)
			t1.append (a_list_builder.a_target)
			r1 := t1.tail_list (3)
			t1.append (a_list_builder.a_value)
			assert ("L'ultimo elemento della coda è stato modificato", r1.last_element /= Void and then attached r1.last_element as le implies le.value = a_list_builder.a_target)


--	t_tail_list_does_not_change_original
			-- questo test serve per vedere che cambiamenti sulla nuova lista non portano cambiamenti sull'originale
			create t2
			create r2
			t2.append (a_list_builder.a_value)
			t2.append (a_list_builder.other_element_1)
			t2.append (a_list_builder.other_element_2)
			t2.append (a_list_builder.other_element_1)
			t2.append (a_list_builder.a_target)
			r2 := t2.tail_list (3)
			r2.append (a_list_builder.a_value)
			assert ("L'ultimo elemento dell'originale è stato modificato", t2.last_element /= Void and then attached t2.last_element as le implies le.value = a_list_builder.a_target)
		end

end
