note
	description: "Summary description for {FITTIZIA}."
	author: "Gabriele Cacchioni & Davide Canalis"
	date: "9-04-2015"
	revision: "0"

class
	STAMPA

inherit

	AZIONE

create
	make_with_text

feature --attributi

	testo: STRING

feature--creazione

	make_with_text (una_stringa: STRING)

		do
			testo := una_stringa
		end

end
