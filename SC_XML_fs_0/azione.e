note
	description: "Summary description for {AZIONE}."
	author: "Gabriele Cacchioni & Davide Canalis"
	date: "9-04-2015"
	revision: "0"


deferred class
	AZIONE

feature --attributi

	id: STRING


feature --creazione

	make_empty
	do
		create id.make_empty
	end

	make_with_id(a_string: STRING)
    do
		id := a_string
    ensure
		id = a_string
	end

end
