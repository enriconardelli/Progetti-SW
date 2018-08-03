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

	link_to (an_element: INT_LINKABLE)
			-- collega questo elemento con `an_element'
		do
			next := an_element
		ensure
			next = an_element
		end

	link_after (an_element: INT_LINKABLE)
			-- inserisce questo elemento dopo `an_element' conservando quello che c'era dopo di esso
		require
			an_element /= Void
		do
			link_to (an_element.next)
			an_element.link_to (Current)
		ensure
			an_element.next = Current
			an_element.next.next = old an_element.next
		end

end
