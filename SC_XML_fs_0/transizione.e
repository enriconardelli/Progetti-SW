note
	description: "La classe che rappresenta le transizioni"
	author: "Gabriele Cacchioni & Davide Canalis"
	date: "14-04-2015"
	revision: "0.2"

class
	TRANSIZIONE

create
	make_with_target

feature --creazione

	make_with_target(uno_stato: STATO)
		do
			target:= uno_stato
			create stampa_log.make_with_text("no Log")
			assegnazione:=Void
			evento:= Void
			condizione:= Void
		end

feature --attributi

	evento: detachable STRING

	condizione: detachable STRING

	stampa_log: STAMPA

	assegnazione:detachable ASSEGNAZIONE

	target: STATO

feature --setter

	set_evento (a_string: STRING)
		require
			not_void: a_string /= Void
		do
			evento := a_string
		end

	set_condizione (a_string: STRING)
		require
			not_void: a_string /= Void
		do
			condizione := a_string
		end


	set_stampa_log (un_azione: STAMPA)--da modificare: serve che si prenda in input una stringa e si istanzi un'azione
								  -- a partire da quella stringa. Prima bisogna capire come fare a distinguere se la transizione è
								  --di tipo 'fittizia' o 'assegnazione' a partire dalla stringa passata.
		require
			not_void: un_azione /= Void
		do
			stampa_log := un_azione


		ensure
		azione_non_vuota:	stampa_log /= Void
			end


set_assegnazione(un_azione : ASSEGNAZIONE)

		require
			not_void: un_azione /= Void
		do
			assegnazione:= un_azione


		ensure
		azione_non_vuota:	assegnazione /= Void
			end



	set_target (uno_stato: STATO)
		do
			target := uno_stato
		end

end
