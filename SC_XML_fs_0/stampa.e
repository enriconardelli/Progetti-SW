note
	description: "Summary description for {FITTIZIA}."
	author: "Gabriele Cacchioni & Davide Canalis"
	date: "9-04-2015"
	revision: "0"

class
	STAMPA

create
	make_with_text

feature --attributi

	testo: STRING

feature --creazione

	make_with_text (una_stringa: STRING)
		require
			not_void: una_stringa /= Void
		do
			create testo.make_empty
			testo := una_stringa
		ensure
			testo_non_void: testo /= Void
		end

end
