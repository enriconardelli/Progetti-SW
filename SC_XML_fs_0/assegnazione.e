note
	description: "Summary description for {ASSEGNAZIONE}."
	author: "Gabriele Cacchioni & Davide Canalis"
	date: "9-04-2015"
	revision: "0"


class
	ASSEGNAZIONE

inherit

   	AZIONE redefine make_empty, make_with_id end


create
	make_empty, make_with_id

feature --attributi

	condizione: STRING

	valore: BOOLEAN

feature -- creazione

	make_empty
	do
		create id.make_empty
		create condizione.make_empty
	end

	make_with_id (a_string: STRING)
	do
		id := a_string
		create condizione.make_empty
	end

end
