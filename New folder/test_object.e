note
	description: "Summary description for {TEST_OBJECT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_OBJECT [G]

Create
	make

feature

	value: INTEGER

	set_value (new_value: INTEGER)
		do
			value := new_value
		ensure
			value = new_value
		end

	make (a_value: INTEGER)
		do
			value := a_value
		ensure
			value = a_value
		end

end
