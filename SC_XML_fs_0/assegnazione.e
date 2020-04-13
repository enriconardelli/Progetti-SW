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

	condizione_da_modificare: STRING

	valore_da_assegnare: BOOLEAN

feature -- creazione

	make_with_cond_and_value (una_condizione: STRING; un_valore: BOOLEAN)
		do
			condizione_da_modificare := una_condizione
			valore_da_assegnare := un_valore
		end

	modifica_condizioni (condizioni: HASH_TABLE [BOOLEAN, STRING])
		do
			condizioni.replace (valore_da_assegnare, condizione_da_modificare)
		end

	action (condizioni: HASH_TABLE [BOOLEAN, STRING])
		do
			print ("Pongo " + condizione_da_modificare + " = " + valore_da_assegnare.out + "%N")
			modifica_condizioni(condizioni)
		end

end
