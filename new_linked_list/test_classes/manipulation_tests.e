note
	description: "Test per le feature di tipo MANIPULATION"
	author: "Gianluca Pastorini"
	date: "$03/04/23"
	revision: "$Revision$"

class
	MANIPULATION_TESTS

inherit

	STATIC_TESTS

feature -- parametri

	a_value: INTEGER = 1

feature -- head_list

	t_one_element
			-- lista con solo un elemento
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			assert ("errore: l'unico elemento non coincide con quello della lista originale", attached t.head_list (1).first_element as fe implies fe.value = a_value)
		end

	t_three_element_copy_two
			-- lista con tre elementi e ne copio due
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value + 1)
			t.append (a_value + 2)
			assert ("errore: il primo elemento non coincide con quello della lista originale", attached t.head_list (1).first_element as fe implies fe.value = a_value)
			assert ("errore: il secondo elemento non coincide con quello della lista originale", attached t.head_list (2).last_element as fe implies fe.value = a_value + 1)
		end

	t_three_element_three_coopy
			-- lista con tre elementi e ne copio tre
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value + 1)
			t.append (a_value + 4)
			assert ("errore: il primo elemento non coincide con quello della lista originale", attached t.head_list (1).first_element as fe implies fe.value = a_value)
			assert ("errore: l'ultimo elemento non coincide con quello della lista originale", attached t.head_list (3).last_element as fe implies fe.value = a_value + 4)
		end

feature -- invert
	-- Federico Fiorini, 2020/03/08

	t_four_elements_invert
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value + 3)
			t.append (a_value - 2)
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
				assert ("gli elementi in mezzo della lista non si sono scambiati", ae.value = a_value - 2)
			end
			t.forth
				--siamo al terzo elemento
			if attached t.active_element as ae then
				assert ("gli elementi in mezzo della lista non si sono scambiati", ae.value = a_value + 3)
			end
			t.forth
				--siamo al quarto elemento
			if attached t.active_element as ae then
				assert ("l'ultimo elemento della lista non risulta il primo dell'originale", ae.value = a_value)
			end
		end

	t_three_elements_invert
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value + 3)
			t.append (a_value - 2)
			t.invert
				--			assert ("errore: il numero di elementi della lista è cambiato", t.count = 3) -- questo test abbiamo detto di averlo già verificato nella postcondizione
			t.start
				--siamo al primo elemento
			if attached t.active_element as ae then
				assert ("il primo elemento della lista invertita non risulta l'ultimo della lista originale", ae.value = a_value - 2)
			end
			t.forth
				--siamo al secondo elemento
			if attached t.active_element as ae then
				assert ("il secondo elemento della lista invertita non risluta il secondo della originale", ae.value = a_value + 3)
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
			t.append (a_value + 2)
			t.append (a_value - 4)
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

end
