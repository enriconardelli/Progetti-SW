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
			create stati_figli.make_empty
			create stato_default.make_empty
			type:=1
		end

feature -- attributi

	stati_figli: ARRAY [STATO]

feature -- setter

	add_figlio (uno_stato: STATO)
	require
		uno_stato_esistente: uno_stato /= Void
	do
		stati_figli.force (uno_stato, stati_figli.count + 1)
	end

	set_stato_default (lo_stato: STATO)
	require
		uno_stato_esistente: lo_stato /= Void
	do
		stato_default:= lo_stato
	end

end
