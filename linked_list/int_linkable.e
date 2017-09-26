note
	description: "Summary description for {INT_LINKABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INT_LINKABLE

create
	make

feature -- accesso

	value: INTEGER
			-- l'intero memorizzato in questo elemento

	set_value (new_value: INTEGER)
			-- assegna l'intero memorizzato in questo elemento
		do
			value := new_value
		ensure
			value = new_value
		end

	next: INT_LINKABLE
			-- il successivo elemento della lista

	make (a_value: INTEGER)
			-- crea l’elemento
		do
			value := a_value
		ensure
			value = a_value
		end

	link_to (other: INT_LINKABLE)
			-- collega questo elemento con `other'
		do
			next := other
		ensure
			next = other
		end

	link_after (other: INT_LINKABLE)
			-- inserisce questo elemento dopo `other' conservando quello che c'era dopo di esso
		require
			other /= Void
		do
			link_to (other.next)
			other.link_to (Current)
		ensure
			other.next = Current
			other.next.next = old other.next
		end

end
