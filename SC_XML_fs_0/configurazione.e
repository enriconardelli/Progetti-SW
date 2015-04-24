note
	description: "Summary description for {CONFIGURAZIONE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONFIGURAZIONE

create

	make_with_all

feature--creazione

	make_with_all(stato_iniziale: STATO ; hash_delle_condizioni: HASH_TABLE[BOOLEAN,STRING])

	do

		stato_corrente:= stato_iniziale
		condizioni:= hash_delle_condizioni

	ensure

		stato_settato: stato_corrente= stato_iniziale
		condizioni_settate: condizioni= hash_delle_condizioni

	end

feature--attributi

	stato_corrente: STATO
	condizioni: HASH_TABLE[BOOLEAN,STRING]

feature--routines

	chiusura

	do

	end

end
