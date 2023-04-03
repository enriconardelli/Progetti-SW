note
	description: "Test per le feature di tipo Manipulation"
	author: "Gianluca Pastorini"
	date: "$03/04/23"
	revision: "$Revision$"

class
	MANIPULATION_TESTS

inherit

	STATIC_TESTS

feature -- head_list

	t_one_element (a_value: INTEGER)
			-- lista con solo un elemento
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			assert ("errore: l'unico elemento non coincide con quello della lista originale", attached t.head_list (1).first_element as fe implies fe.value = a_value)
		end

	t_three_element_copy_two (a_value: INTEGER)
			-- lista con tre elementi e ne copio due
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value + 1)
			t.append (a_value + 2)
			assert ("errore: il primo elemento non coincide con quello della lista originale", attached t.head_list (1).first_element as fe implies fe.value = a_value)
			assert ("errore: il secondo elemento non coincide con quello della lista originale",  attached t.head_list(2).last_element as fe implies fe.value = a_value+1)
		end

	t_three_element_three_coopy (a_value: INTEGER)
			--lista con tre elementi e ne copio tre
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

	t_head_list
		do
		    t_one_element (1)
			t_three_element_copy_two (1)
			t_three_element_three_coopy (1)
		end

end
