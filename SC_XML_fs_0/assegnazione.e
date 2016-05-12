note
	description: "La classe che rappresenta l'azione di assegnazione"
	author: "Gabriele Cacchioni & Davide Canalis & Daniele Fakhoury & Eloisa Scarsella"
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

	modifica_condizioni (condizioni: HASH_TABLE [BOOLEAN, STRING])
		do
			condizioni.replace (valore, condizione)
		end

	action (condizioni: HASH_TABLE [BOOLEAN, STRING])
		local
			boolean: STRING
		do
			if valore then
				boolean := "true"
			else
				boolean := "false"
			end
			print ("Pongo " + condizione + " = " + boolean + "%N")
		   modifica_condizioni(condizioni)
		end

end
