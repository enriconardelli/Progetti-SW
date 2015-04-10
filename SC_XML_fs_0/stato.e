note

	description: "Summary description for {STATO}."
	author: "Gabriele Cacchioni & Davide Canalis"
	date: "9-04-2015"
	revision: "0.1"

class
	STATO

create

		make_with_id


feature--creazione

		make_with_id(un_id: STRING)

		require

			non_e_una_stringa_vuota: un_id /= Void

		do

			id := un_id

			finale := FALSE

			create transizioni.make_empty

		ensure

			attributo_assegnato: id = un_id

		end


feature--attributi


	transizioni: ARRAY[TRANSIZIONE]

	finale: BOOLEAN

	id: STRING

feature --setter

		set_final

			do

				finale:= TRUE

			ensure

				ora_e_finale: finale

			end


		--add_transition




feature --routines

	determinismo (evento_corrente: STRING): BOOLEAN

		do
			-- ritorna vero se con evento_corrente � attivabile nella configurazione corrente al pi� 1 transizione
			-- ritorna falso se con evento_corrente sono attivabili nella configurazione corrente almeno 2 transizioni

			result := TRUE

		end


	target (evento_corrente: STRING): STATO

		require
			determinismo(evento_corrente)

		do

			result := void
			-- ritorna Void se con evento_corrente nella configurazione corrente non � attivabile alcuna transizione
			-- ritorna lo stato a cui porta l'unica transizione attivabile nella configurazione corrente con evento_corrente
		end

end
