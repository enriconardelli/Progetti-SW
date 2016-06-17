note
	description: "Summary description for {MY_LINKABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_LINKABLE [G]
create
	make
feature

	set_value (new_value: G)
			-- assign the integer stored in this cell
		do
			value := new_value
		ensure
			value = new_value
		end

	value: G

	next: detachable MY_LINKABLE [G]
			-- the next cell in the list

	make (a_value: G)
			-- create this cell
		do
			value := a_value
		ensure
			value = a_value
		end

	link_to (other: detachable MY_LINKABLE [G])
			-- connect this cell to `other'
		do
			next := other
		ensure
			next = other
		end

	insert_after (other: detachable MY_LINKABLE [G])
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
			print ("%N instance of INT_LINKABLE doing nothing - to test class invariants")
		end

end
