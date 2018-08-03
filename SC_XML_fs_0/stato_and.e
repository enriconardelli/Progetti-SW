note
	description: "Summary description for {STATO_AND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATO_AND

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
			Precursor (un_id)
			create stati_figli.make_empty
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

	set_stato_default
		local
			i: INTEGER
			j: INTEGER
		do

			from
				i:= stati_figli.lower
			until
				i= stati_figli.upper + 1
			loop
				if attached {STATO_XOR} stati_figli.item (i) as sf then
					sf.set_stato_default (sf)
					from
						j:=sf.stato_default.lower
					until
						j=sf.stato_default.upper +1
					loop
						stato_default.force (sf.stato_default.item (j), stato_default.count +1)
						j:=j+1
					end

				end
				i:= i+1
			end
		end

end
