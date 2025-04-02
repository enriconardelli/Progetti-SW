note
	description: "Summary description for {LIST_BUILDER}."
	author: "Marco Aragona & Gabriele Messina"
	date: "22/03/2025"
	revision: "$Revision$"

class
	LIST_BUILDER

create
	default_creation

feature {NONE}

	default_creation
		once
			a_value := 1
			a_target := 2
			other_element_1 := 5
			other_element_2 := 7
		end

feature -- parametri

	a_value: INTEGER
	a_target: INTEGER
	other_element_1: INTEGER
	other_element_2: INTEGER

feature -- Istanze di liste

	list_T: INT_LINKED_LIST
		once
			create Result
			Result.append (a_target)
		end

	list_TV: INT_LINKED_LIST
		once
			create Result
			Result.append (a_target)
			Result.append (a_value)
		end

	list_VTV: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value)
			Result.append (a_target)
			Result.append (a_value)
		end

	list_VVTT: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value)
			Result.append (a_value)
			Result.append (a_target)
			Result.append (a_target)
		end

	list_VTVT: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value)
			Result.append (a_target)
			Result.append (a_value)
			Result.append (a_target)
		end

	list_e1Te2e1e2e1e2e1Ve2: INT_LINKED_LIST
		once
			create Result
			Result.append (other_element_1)
			Result.append (a_target)
			Result.append (other_element_2)
			Result.append (other_element_1)
			Result.append (other_element_2)
			Result.append (other_element_1)
			Result.append (other_element_2)
			Result.append (other_element_1)
			Result.append (a_value)
			Result.append (other_element_2)
		end

	list_VTTV: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value)
			Result.append (a_target)
			Result.append (a_target)
			Result.append (a_value)
		end

	list_Ve1TV: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value)
			Result.append (other_element_1)
			Result.append (a_target)
			Result.append (a_value)
		end

	list_Ve1: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value)
			Result.append (other_element_1)
		end

	list_VT: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value)
			Result.append (a_target)
		end

	list_VTe1: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value)
			Result.append (a_target)
			Result.append (other_element_1)
		end

	list_TTVV: INT_LINKED_LIST
		once
			create Result
			Result.append (a_target)
			Result.append (a_target)
			Result.append (a_value)
			Result.append (a_value)
		end

	list_e1Ve2e1e2e1e2e1T: INT_LINKED_LIST
		once
			create Result
			Result.append (other_element_1)
			Result.append (a_value)
			Result.append (other_element_2)
			Result.append (other_element_1)
			Result.append (other_element_2)
			Result.append (other_element_1)
			Result.append (other_element_2)
			Result.append (other_element_1)
			Result.append (a_target)
		end

	list_TVT: INT_LINKED_LIST
		once
			create Result
			Result.append (a_target)
			Result.append (a_value)
			Result.append (a_target)
		end

	list_e1TVT: INT_LINKED_LIST
		once
			create Result
			Result.append (other_element_1)
			Result.append (a_target)
			Result.append (a_value)
			Result.append (a_target)
		end

	list_Ve1VT: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value)
			Result.append (other_element_1)
			Result.append (a_value)
			Result.append (a_target)
		end

	list_e1: INT_LINKED_LIST
		once
			create Result
			Result.append (other_element_1)
		end

	list_e1TV: INT_LINKED_LIST
		once
			create Result
			Result.append (other_element_1)
			Result.append (a_target)
			Result.append (a_value)
		end

	list_Ve1VTV: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value)
			Result.append (other_element_1)
			Result.append (a_value)
			Result.append (a_target)
			Result.append (a_value)
		end

	list_Ve1TVe2V: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value)
			Result.append (other_element_1)
			Result.append (a_target)
			Result.append (a_value)
			Result.append (other_element_2)
			Result.append (a_value)
		end

	list_Ve1VTVTVe2: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value)
			Result.append (other_element_1)
			Result.append (a_value)
			Result.append (a_target)
			Result.append (a_value)
			Result.append (a_target)
			Result.append (a_value)
			Result.append (other_element_2)
		end

	list_Ve1VTVT: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value)
			Result.append (other_element_1)
			Result.append (a_value)
			Result.append (a_target)
			Result.append (a_value)
			Result.append (a_target)
		end

	list_Ve1e2: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value)
			Result.append (other_element_1)
			Result.append (other_element_2)
		end

	list_VVe1: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value)
			Result.append (a_value)
			Result.append (other_element_2)
		end

	list_VVless1Vless3: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value)
			Result.append (a_value - 1)
			Result.append (a_value - 3)
		end

	list_Vless1Vless4V: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value - 1)
			Result.append (a_value - 4)
			Result.append (a_value)
		end

	list_Vless1VVless4: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value - 1)
			Result.append (a_value)
			Result.append (a_value - 4)
		end

	list_negabsV_negabse1_negabse1: INT_LINKED_LIST
		once
			create Result
			Result.append (- a_value.abs)
			Result.append (- other_element_1.abs)
			Result.append (- other_element_1.abs)
		end

	list_absV_abse1: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value.abs)
			Result.append (other_element_1.abs)
		end

	list_absV_abse1_negabsV: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value.abs)
			Result.append (other_element_1.abs)
			Result.append (- a_value.abs)
		end

	list_e1e2V: INT_LINKED_LIST
		once
			create Result
			Result.append (other_element_1)
			Result.append (other_element_2)
			Result.append (a_value)
		end

	list_e1Ve2: INT_LINKED_LIST
		once
			create Result
			Result.append (other_element_1)
			Result.append (a_value)
			Result.append (other_element_2)
		end

	list_e1VVe2: INT_LINKED_LIST
		once
			create Result
			Result.append (other_element_1)
			Result.append (a_value)
			Result.append (a_value)
			Result.append (other_element_2)
		end

	list_V: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value)
		end

	list_Ve1e2V: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value)
			Result.append (other_element_1)
			Result.append (other_element_2)
			Result.append (a_value)
		end

	list_empty: INT_LINKED_LIST
		once
			create Result
		end

	list_V_duplicate: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value)
		end

	list_Ve1V: INT_LINKED_LIST
		once
			create Result
			Result.append (a_value)
			Result.append (other_element_1)
			Result.append (a_value)
		end

end
