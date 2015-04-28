note
	description: "Summary description for {STATO}."
	author: "Gabriele Cacchioni & Davide Canalis"
	date: "9-04-2015"
	revision: "0.1"

class
	STATO

create
	make_with_id, make_empty

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

	make_empty
		do
			create transizioni.make_empty
			finale := false
			create id.make_empty
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

	agg_trans (tr: TRANSIZIONE)
		do
			transizioni.force (tr, transizioni.count + 1)
		end

	determinismo (evento_corrente: STRING; hash_delle_condizioni: HASH_TABLE [BOOLEAN, STRING]): BOOLEAN
		local
			index_count: INTEGER
			numero_di_transizioni_attivate_da_evento_corrente: INTEGER -- questo conta il numero di transizioni nell'array che sono attivate dall'evento corrente
			numero_di_transizioni_senza_evento_con_condizione_vera: INTEGER --questo conta il numero di transizione nell'array cn campo evento vuoto e condizione vera

		do
				-- ritorna vero se con evento_corrente è attivabile nella configurazione corrente al più 1 transizione
				-- ritorna falso se con evento_corrente sono attivabili nella configurazione corrente almeno 2 transizioni

			from
				index_count := transizioni.lower --si parte a scorrere l'array di transizioni dal suo indice più piccolo
				numero_di_transizioni_attivate_da_evento_corrente := 0
				numero_di_transizioni_senza_evento_con_condizione_vera := 0
			until
				index_count = transizioni.upper + 1 or numero_di_transizioni_attivate_da_evento_corrente > 1 or numero_di_transizioni_senza_evento_con_condizione_vera > 1
			loop
				if attached transizioni [index_count].evento as ang then
					if ang.is_equal (evento_corrente) then
						if attached transizioni [index_count].condizione as cond then
							if attached hash_delle_condizioni.item (cond) as cond_in_hash then
								if cond_in_hash = TRUE then
									numero_di_transizioni_attivate_da_evento_corrente := numero_di_transizioni_attivate_da_evento_corrente + 1
								end
							end
						end
					end
				else
					if attached transizioni [index_count].condizione as cond then
						if attached hash_delle_condizioni.item (cond) as cond_in_hash then
							if cond_in_hash = TRUE then
								numero_di_transizioni_senza_evento_con_condizione_vera := numero_di_transizioni_senza_evento_con_condizione_vera + 1
							end
						end
					end
				end
				index_count := index_count + 1
			end
			if numero_di_transizioni_attivate_da_evento_corrente > 1 or numero_di_transizioni_senza_evento_con_condizione_vera > 1 then
				result := FALSE
			else
				result := TRUE
			end
		end

	target (evento_corrente: STRING; hash_delle_condizioni: HASH_TABLE [BOOLEAN, STRING]): detachable STATO
		require
			determinismo (evento_corrente, hash_delle_condizioni)
		local
			target_della_transizione: detachable STATO
			index_count: INTEGER
		do
			target_della_transizione := Void
			from
				index_count := transizioni.lower
			until
				index_count = transizioni.upper + 1
			loop
				if attached transizioni [index_count].evento as ang then
					if ang.is_equal (evento_corrente) then
						target_della_transizione := transizioni [index_count].target
					end
				end
				index_count := index_count + 1
			end
			result := target_della_transizione
				-- ritorna Void se con evento_corrente nella configurazione corrente non è attivabile alcuna transizione
				-- ritorna lo stato a cui porta l'unica transizione attivabile nella configurazione corrente con evento_corrente
		end

feature --cose a parte

	get_events: ARRAY [STRING]
		local
			i: INTEGER
			ev: ARRAY [STRING]
		do
			create ev.make_empty
			if attached Current.transizioni as tr then
				from
					i := 1
				until
					i = tr.count + 1
				loop
					if attached tr [i].evento as evento then
						ev.force (evento, i)
					end
					i := i + 1
				end
			end
			Result := ev
		end
end
