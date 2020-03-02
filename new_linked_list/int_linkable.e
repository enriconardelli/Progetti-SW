note
	description: "Summary description for {INT_LINKABLE}."
	author: "Project new_linked_list"
	date: "$Date$"
	revision: "$Revision$"

class
	INT_LINKABLE

create
	set_value

feature -- Access

	value: INTEGER
			-- the integer stored in this cell

	next: detachable INT_LINKABLE
			-- the next cell in the list

feature {NONE} -- Initialization

	set_value (a_value: INTEGER)
			-- assign the integer stored in this cell
		do
			value := a_value
		ensure
			value = a_value
		end

feature -- Processing

	link_to (other: detachable INT_LINKABLE)
			-- connect this cell to `other'
		do
			next := other
		ensure
			next = other
		end

	link_after (other: INT_LINKABLE)
			-- insert this cell after `other' preserving what was after it
		do
			link_to (other.next)
			other.link_to (Current)
		ensure
			next = old other.next
			other.next = Current
		end

invariant

	everything_OK: True -- no other invariant for the time being

end
