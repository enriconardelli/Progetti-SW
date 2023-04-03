note
	description: "Test per le feature di tipo Manipulation"
	author: "Gianluca Pastorini"
	date: "$03/04/23"
	revision: "$Revision$"

class
	COMPUTATION_TESTS

inherit

	STATIC_TESTS

feature -- highest

	t_one_element (a_value: INTEGER)
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			ensure ("errore il massimo non è il primo elemento", t.highest=a_value)
		end

	t_three_elements_fisrt (a_value:INTEGER)
		local
			t: INT_LINKED_LIST
		do
			create.t
			t.append (a_value)
			t.append(a_value-1)
			t.append(a_value-3)
			ensure ("errore il massimo non è il primo elemento", t.highest=a_value)
		end

	t_three_elements_last (a_value:INTEGER)
		local
			t: INT_LINKED_LIST
		do
			create.t
			t.append (a_value-1)
			t.append(a_value-4)
			t.append(a_value)
			ensure ("errore il massimo non è l'ultimo elemento", t.highest=a_value)
		end

	t_three_elements_middle (a_value:INTEGER)
		local
			t: INT_LINKED_LIST
		do
			create.t
			t.append (a_value-1)
			t.append(a_value)
			t.append(a_value-4)
			ensure ("errore il massimo non è l'ultimo elemento", t.highest=a_value)
		end


		t_highest
		do
			t_one_element (1)
			t_three_elements_fisrt (1)
			t_three_elements_middle (1)
			t_three_elements_last (1)
		end
end
