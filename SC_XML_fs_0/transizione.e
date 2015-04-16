note
	description: "La classe che rappresenta le transizioni"
	author: "Gabriele Cacchioni & Davide Canalis"
	date: "14-04-2015"
	revision: "0.2"

class
	TRANSIZIONE

create
	make_with_target

feature --creazione

	make_with_target(uno_stato: STATO)
		do
			target:= uno_stato
			azione := Void
		end

feature --attributi

	evento: STRING

	condizione: STRING

	azione: detachable AZIONE

	target: STATO

feature --setter

	set_evento (a_string: STRING)
		require
			not_void: a_string /= Void
		do
			evento := a_string
		end

	set_condizione (a_string: STRING)
		require
			not_void: a_string /= Void
		do
			condizione := a_string
		end

	set_azione (un_azione: AZIONE)
		require
			not_void: un_azione /= Void
		do
			azione := un_azione
		end

	set_target (uno_stato: STATO)
		do
			target := uno_stato
		end

end
