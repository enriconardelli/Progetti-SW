note
	description: "Summary description for {STATO}."
	author: "Gabriele Cacchioni & Davide Canalis"
	date: "9-04-2015"
	revision: "0.1"

class
	STATO

create
	make_with_id

feature --creazione

	make_with_id (un_id: STRING)
		require
			non_e_una_stringa_vuota: un_id /= Void
		do
			id := un_id
			finale := FALSE
			create transizioni.make_empty
		ensure
			attributo_assegnato: id = un_id
		end

feature --attributi

	transizioni: ARRAY [TRANSIZIONE]

	finale: BOOLEAN

	id: STRING

feature --setter

	set_final
		do
			finale := TRUE
		ensure
			ora_e_finale: finale
		end

		--add_transition

feature --routines

	determinismo (evento_corrente: STRING): BOOLEAN --attenzione: NON tiene conto della mutua esclusività delle transizioni
													--cioè in questa implementazione se due transizioni sono attivate dallo stesso evento,
													--NON si fa un controllo sulle condizioni e si restituisce sempre FALSE		
	local

		index_count: INTEGER
		numero_di_transizioni_attivate_da_evento_corrente: INTEGER -- questo conta il numero di transizioni nell'array che sono attivate dall'evento corrente


		do
				-- ritorna vero se con evento_corrente è attivabile nella configurazione corrente al più 1 transizione
				-- ritorna falso se con evento_corrente sono attivabili nella configurazione corrente almeno 2 transizioni

			from
				index_count:= transizioni.lower  --si parte a scorrere l'array di transizioni dal suo indice più piccolo
				numero_di_transizioni_attivate_da_evento_corrente:= 0
			until
				index_count=transizioni.upper --si esce dal ciclo quando l'array è finito
			loop
				if
					transizioni.entry (index_count).evento.is_equal (evento_corrente)
				then
					numero_di_transizioni_attivate_da_evento_corrente:=numero_di_transizioni_attivate_da_evento_corrente+1
				end

				index_count:=index_count+1
			end


			if
				numero_di_transizioni_attivate_da_evento_corrente>1
			then
				result := FALSE
			else
				result := TRUE
			end


		end

	target (evento_corrente: STRING): detachable STATO
		require
			determinismo (evento_corrente)
		do
			result := void
				-- ritorna Void se con evento_corrente nella configurazione corrente non è attivabile alcuna transizione
				-- ritorna lo stato a cui porta l'unica transizione attivabile nella configurazione corrente con evento_corrente
		end

end
