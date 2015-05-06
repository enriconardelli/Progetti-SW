note
	description: "Summary description for {ASSEGNAZIONE}."
	author: "Gabriele Cacchioni & Davide Canalis"
	date: "9-04-2015"
	revision: "0"

class
	ASSEGNAZIONE

inherit

	AZIONE

create
	make_with_cond_and_value

feature --attributi

	condizione: STRING

	valore: BOOLEAN

feature -- creazione

	make_with_cond_and_value (una_condizione: STRING; un_valore: BOOLEAN)
		do
			condizione := una_condizione
			valore := un_valore
		end

end
