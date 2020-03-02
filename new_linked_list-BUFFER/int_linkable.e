note
	description: "Summary description for {INT_LINKABLE}."
	author: "Project new_linked_list"
	date: "$Date$"
	revision: "$Revision$"

class
	INT_LINKABLE

create
	make

feature -- access

	value: INTEGER
			-- the integer stored in this cell

	next: detachable INT_LINKABLE
			-- the next cell in the list

feature -- value processing 

	make (a_value: INTEGER)
			-- create this cell
		do
			value := a_value
		ensure
			value = a_value
		end

	set_value (new_value: INTEGER)
			-- assign the integer stored in this cell
		do
			value := new_value
		ensure
			value = new_value
		end

feature -- link processing 

	link_to (other: detachable INT_LINKABLE)
			-- connect this cell to `other'
		do
			next := other
		ensure
			next = other
		end

	link_after (other: detachable INT_LINKABLE)
			-- insert this cell after `other' preserving what was after it
		require
			other /= Void
		do
			check attached other as o then	-- we want this Object Test to be always executed
				link_to (o.next)
				o.link_to (Current)
			end
		ensure
			attached other as o implies o.next = Current
			attached other as o implies (attached o.next as on implies on.next = old other.next)
		end

end
