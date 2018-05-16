note
	description: "Summary description for {STATO_XOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATO_XOR

inherit

	STATO
	redefine
		make_with_id
	end

create
	make_with_id

feature -- creazione

	make_with_id (un_id: STRING)
		do
			id := un_id
			create transizioni.make_empty
			create stati.make_empty
			create stato_default.make_empty
			type:=1
		end

feature -- attributi

	stati: ARRAY [STATO]

	stato_default: STATO

feature -- setter

	add_stato (uno_stato: STATO)
	require
		uno_stato_esistente: uno_stato /= VOID
	do
		stati.force (uno_stato, stati.count + 1)
	end

	set_stato_default (lo_stato: STATO)
	require
		uno_stato_esistente: lo_stato /= VOID
	do
		stato_default:= lo_stato
	end

end
