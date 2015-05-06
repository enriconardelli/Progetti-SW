note
	description: "Summary description for {FITTIZIA}."
	author: "Gabriele Cacchioni & Davide Canalis"
	date: "9-04-2015"
	revision: "0"

class
	FITTIZIA

inherit

	AZIONE

create
	make_with_id

feature --attributi

	id: STRING

feature--creazione

	make_with_id (un_id: STRING)

		do
			id := un_id
		end

end
