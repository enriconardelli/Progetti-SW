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

end
