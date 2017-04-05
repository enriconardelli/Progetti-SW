note
	description: "La classe che svolge l'azione di stampa"
	author: "Gabriele Cacchioni & Davide Canalis & Daniele Fakhoury & Eloisa Scarsella"
	date: "9-04-2015"
	revision: "0"

class
	STAMPA

inherit

	AZIONE

create
	make_with_text

feature -- attributi

	testo: STRING

feature -- creazione

	make_with_text (una_stringa: STRING)
		require
			not_void: una_stringa /= Void
		do
			create testo.make_empty
			testo := una_stringa
		ensure
			testo_non_void: testo /= Void
		end

feature -- azione

	action (condizioni: HASH_TABLE [BOOLEAN, STRING])
		do
			print ("LOG:   " + testo + "%N")
		end

end
