note
	description: "Summary description for {STATO}."
	author: "Gabriele Cacchioni & Davide Canalis"
	date: "9-04-2015"
	revision: "0"

class
	STATO

create


feature--attributi

	id: STRING

	--iniziale: BOOLEAN ???non serve???

	finale: BOOLEAN

	transizioni: ARRAY[TRANSIZIONE]


feature --routines

	determinismo (evento_corrente: STRING): BOOLEAN

		do
			-- ritorna vero se con evento_corrente è attivabile nella configurazione corrente al più 1 transizione
			-- ritorna falso se con evento_corrente sono attivabili nella configurazione corrente almeno 2 transizioni
		end


	target (evento_corrente: STRING): STATO

		require
			determinismo(evento_corrente)

		do
			-- ritorna Void se con evento_corrente nella configurazione corrente non è attivabile alcuna transizione
			-- ritorna lo stato a cui porta l'unica transizione attivabile nella configurazione corrente con evento_corrente
		end

end
