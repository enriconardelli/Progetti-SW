note
	description: "Summary description for {LIST_BUILDER}."
	author: "Marco Aragona & Gabriele Messina"
	date: "22/03/2025"
	revision: "$Revision$"

class
	LIST_BUILDER

create
	make

feature -- Creation

	make (input_value: INTEGER; input_target: INTEGER; input_element_1 : INTEGER; input_element_2 : INTEGER)
		do
			a_value := input_value

			a_target := input_target

			other_element_1 := input_element_1

			other_element_2 := input_element_2
		end

feature -- parametri
	a_value: INTEGER

	a_target: INTEGER

	other_element_1: INTEGER

	other_element_2: INTEGER


feature -- Istanze di liste

   	list_T : INT_LINKED_LIST
        once
            create Result
            Result.append(a_target)
        end

   	list_TV : INT_LINKED_LIST
        once
            create Result
            Result.append(a_target)
            Result.append(a_value)
        end

   	list_VTV : INT_LINKED_LIST
        once
            create Result
            Result.append(a_value)
            Result.append(a_target)
            Result.append(a_value)
        end

   	list_VVTT : INT_LINKED_LIST
        once
            create Result
            Result.append(a_value)
            Result.append(a_value)
            Result.append(a_target)
            Result.append(a_target)
        end

    list_VTVT : INT_LINKED_LIST
        once
            create Result
            Result.append(a_value)
            Result.append(a_target)
            Result.append(a_value)
            Result.append(a_target)
        end

    list_e1Te2e1e2e1e2e1Ve2 : INT_LINKED_LIST
        once
            create Result
            Result.append(other_element_1)
            Result.append(a_target)
            Result.append(other_element_2)
            Result.append(other_element_1)
            Result.append(other_element_2)
            Result.append(other_element_1)
            Result.append(other_element_2)
            Result.append(other_element_1)
            Result.append(a_value)
            Result.append(other_element_2)
        end

   	list_VTTV : INT_LINKED_LIST
        once
            create Result
            Result.append(a_value)
            Result.append(a_target)
            Result.append(a_target)
            Result.append(a_value)
        end

    list_Ve1TV : INT_LINKED_LIST
        once
            create Result
            Result.append(a_value)
            Result.append(other_element_1)
            Result.append(a_target)
            Result.append(a_value)
        end

    list_VT : INT_LINKED_LIST
        once
            create Result
            Result.append(a_value)
          	Result.append(a_target)
        end

  	list_TTVV : INT_LINKED_LIST
        once
            create Result
            Result.append(a_target)
            Result.append(a_target)
            Result.append(a_value)
            Result.append(a_value)
        end

    list_e1Ve2e1e2e1e2e1T : INT_LINKED_LIST
        once
            create Result
            Result.append(other_element_1)
            Result.append(a_value)
            Result.append(other_element_2)
            Result.append(other_element_1)
            Result.append(other_element_2)
            Result.append(other_element_1)
            Result.append(other_element_2)
            Result.append(other_element_1)
            Result.append(a_target)
        end

    list_TVT : INT_LINKED_LIST
        once
            create Result
            Result.append(a_target)
            Result.append(a_value)
            Result.append(a_target)
        end

    list_e1TVT : INT_LINKED_LIST
        once
            create Result
            Result.append(other_element_1)
            Result.append(a_target)
            Result.append(a_value)
            Result.append(a_target)
        end
end
