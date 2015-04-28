note
	description: "Summary description for {CONFIGURAZIONE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONFIGURAZIONE

create
	make_with_condition

feature --creazione

	make_with_condition (statoin: STATO; hash_delle_condizioni: HASH_TABLE [BOOLEAN, STRING])
		do
			condizioni := hash_delle_condizioni
			stato_corrente:= statoin
		ensure
			condizioni_settate: condizioni = hash_delle_condizioni
		end

feature --attributi

	stato_corrente: STATO

	condizioni: HASH_TABLE [BOOLEAN, STRING]

feature --routines

	set_stato_corrente (uno_stato: STATO)
		require
			stato_corrente_not_void: stato_corrente /= Void
		do
			stato_corrente := uno_stato
		end

	chiusura
		do
		end

end
