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
            create azioni.make_empty
			evento:= Void
			condizione:= "condizione_vuota"
		end

feature --attributi

	evento: detachable STRING

	condizione: STRING

    azioni: ARRAY [AZIONE]

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

	set_target (uno_stato: STATO)
		do
			target := uno_stato
		end

feature --check

	check_evento (istante: HASH_TABLE [STRING, STRING]): BOOLEAN
		do
			if attached evento as e then
				if istante.has (e) then
					result:= TRUE
				end
			else
				result:= TRUE
			end
		end

	check_condizione (hash_delle_condizioni: HASH_TABLE [BOOLEAN, STRING] ): BOOLEAN
	--Controlla se la condizione dell'evento è verificata.
	do
		if attached condizione as c then
			if hash_delle_condizioni.has (c) then
				result:= TRUE
			end
		else
			result:= TRUE
		end
	end

end
