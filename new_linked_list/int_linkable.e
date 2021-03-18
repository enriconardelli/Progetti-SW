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
			-- L'intero memorizzato in questo elemento.

	next: detachable INT_LINKABLE
			-- the next cell in the list

feature {NONE} -- Initialization

	set_value (a_value: INTEGER)
			-- Assegna l'intero memorizzato in questo elemento.
		do
			value := a_value
		ensure
			value = a_value
		end

feature -- Processing

	link_to (other: detachable INT_LINKABLE)
			-- Collega questo elmento a `other'.
		do
			next := other
		ensure
			next = other
		end

	link_after (other: INT_LINKABLE)
			-- Inserisce questo elemento dopo `other' conservando quello che c'era dopo.
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
