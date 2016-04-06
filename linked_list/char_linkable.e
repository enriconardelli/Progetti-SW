note
	description: "Summary description for {CHAR_LINKABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CHAR_LINKABLE

create
	make

feature

	value: CHARACTER
			-- the character stored in this cell

	set_value (new_value: CHARACTER)
			-- assign the character stored in this cell
		do
			value := new_value
		ensure
			value = new_value
		end

	next: detachable CHAR_LINKABLE
			-- the next cell in the list

	make (i: CHARACTER)
			-- create this cell
		do
			value := i
		end

	link_to (other: detachable CHAR_LINKABLE)
			-- connect this cell to `other'
		do
			next := other
		ensure
			next = other
		end

	insert_after (other: detachable CHAR_LINKABLE)
			-- insert this cell after `other' preserving what was after it
		require
			other /= Void
		do
			link_to (other.next)
			other.link_to (Current)
		ensure
			other.next = Current
			other.next.next = old other.next
		end

	exec_nothing
			-- do nothing
		do
			print ("%N instance of CHAR_LINKABLE doing nothing - to test class invariants")
		end

end
