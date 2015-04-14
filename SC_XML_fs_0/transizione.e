note
	description: "La classe che rappresenta le transizioni"
	author: "Gabriele Cacchioni & Davide Canalis"
	date: "9-04-2015"
	revision: "0"

class
	TRANSIZIONE

create

make


feature

	make

	do

		create target.make_with_id ("dummy") --sto istanziando un target farlocco, sennò toccava a metterlo detachable


	end


feature --attributi

	evento: STRING

	condizione: STRING

	--azione: AZIONE

	target: STATO

feature --setter

	set_evento (un_evento: STRING)
		do
			evento := un_evento
		ensure
			properly_setted: evento = un_evento
		end

end
