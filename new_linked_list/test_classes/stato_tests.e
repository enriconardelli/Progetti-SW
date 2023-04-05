note
	description: "Test per le feature di tipo stato"
	author: "Gianluca Pastorini"
	date: "05/04/23"
	revision: "$Revision$"

class
	STATO_TESTS

inherit

	STATIC_TESTS

feature -- is_before

	a_value: INTEGER = 1

	t_is_before_one_element
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			assert ("in caso di a_value=an_element dovrebbe dare falso come risultato", not t.is_before (t.first_element, t.first_element))
		end

	t_is_before_multiple_element
	local
		t:INT_LINKED_LIST
		do
			create t
			t.append(a_value)
			t.append(a_value+1)
			t.append (a_value+3)
			t.last
			-- imposto active_element a last_element
			assert ("last_element dovrebbe essere dopo first_element", t.is_before (t.first_element, t.active_element))
			assert ("in caso di a_value=an_element dovrebbe dare falso come risultato", not t.is_before (t.last_element, t.active_element))
		end

end
