
class
	STATO

inherit
	ARGUMENTS
	EXCEPTIONS

create
	crea_stato

feature -- accesso

	nome: STRING

	transizioni: ARRAY[QUATERNA]

	transitorio: BOOLEAN


feature -- creazione

	crea_stato
		do
			imposta_nome("stato")
			transitorio := false
			create transizioni.make_empty
		end


feature -- modifica

	imposta_nome(s: STRING)
		require
			s /= Void
		do
			nome := s.twin
		ensure
			nome.is_equal(s)
		end

	imposta_transitorio(b: BOOLEAN)
		do
			transitorio := b
		end


	aggiungi_quaterna
	-- aggiunge quaterna vuota
		local
			nuova_quaterna: QUATERNA
		do
			create nuova_quaterna.crea_quaterna
			transizioni.force(nuova_quaterna,(transizioni.upper)+1)
		end


feature -- stato

	non_vuoto: BOOLEAN
		do
			if transizioni.count = 0 then
				Result := false
			else
				Result := true
			end
		end


	acquisisci_quaterna(evento, condizione, azione, target: STRING; output: PLAIN_TEXT_FILE)
		local
			nuova_quaterna: QUATERNA
		do
			-- Crea e "posiziona" la nuova quaterna per il nuovo evento
			create nuova_quaterna.crea_quaterna
			transizioni.force (nuova_quaterna, transizioni.count + 1)

			-- Impostazione quaterna
			nuova_quaterna.imposta_evento(evento)
			nuova_quaterna.imposta_condizione (condizione)
			nuova_quaterna.imposta_azione(azione)
			nuova_quaterna.imposta_target(target)
			output.put_string (nuova_quaterna.evento)
			output.put_string(" / ")
			output.put_string (nuova_quaterna.condizione)
			output.put_string (" / ")
			output.put_string (nuova_quaterna.azione)
			output.put_string(" / ")
			output.put_string (nuova_quaterna.target)
			output.new_line
		end


	indice_transizione(tab_condizioni: HASH_TABLE[BOOLEAN,STRING]): INTEGER
		-- Restituisce l'indice della posizione della prima transizione con condizione vera nell'array eventi dello stato,
		-- ovvero dell'unico evento eseguito dello stato.

		require
			transitorio
		local
			i: INTEGER
			transizione_trovata: BOOLEAN
		do
			i := 0

			from

			until
				transizione_trovata
			loop
				i := i+1
				if transizioni[i].evento.is_equal ("evento vuoto") and then tab_condizioni.has (transizioni[i].condizione)and then tab_condizioni[transizioni[i].condizione] then
					transizione_trovata := true
				end
			end

			Result := i
		end

	evento_attivabile_multiplo(tab_condizioni: HASH_TABLE[BOOLEAN,STRING]): BOOLEAN
		-- Controlla la presenza di quaterne che generino indeterminatezza, tali cioè che:
		-- "evento" sia uguale
		-- "condizione" sia vera
		-- "azione" e/o "target" siano diversi

		local
			i: INTEGER
			j: INTEGER

		do
			Result := false
			from
				i := 1
			until
				i = transizioni.count
			loop
			-- Effetto il controllo di evento_attivabile_multiplo solo se l'evento è attivabile
				if tab_condizioni[transizioni[i].condizione] then
					from
						j := i + 1
					until
						j > transizioni.count
					loop
						if transizioni[j].evento.is_equal (transizioni[i].evento) and  tab_condizioni[transizioni[j].condizione] then
							if not transizioni[j].uguale(transizioni[i]) then
								Result := true
							end
						end
						j := j+1
					end
				end
				i := i+1
			end
		end

	gestisci_evento(evento_corrente: STRING; tab_condizioni: HASH_TABLE[BOOLEAN,STRING]; output: PLAIN_TEXT_FILE): STRING
		-- Cerca evento_corrente con condizione vera tra gli eventi dello stato: se non presente, restituisce "target_nullo"
		-- e stampa "Evento ignorato"; se presente un'unica volta, stampa l'azione e restituisce il target; se presente
		-- molteplici volte, stampa l'errore e termina il programma.

		local
			j: INTEGER
			evento_attivabile: INTEGER
			indice_evento_attivabile: INTEGER

		do
			-- Conto il numero di volte che compare evento_corrente con condizione vera
			from
				j := 1
			until
				j > transizioni.count
			loop
				if transizioni[j].evento.is_equal(evento_corrente) and then tab_condizioni.has(transizioni[j].condizione) and then tab_condizioni[transizioni[j].condizione] then
					evento_attivabile := evento_attivabile + 1
					indice_evento_attivabile := j.twin
				elseif not tab_condizioni.has (transizioni[j].condizione) then
					output.put_string ("Il valore booleano di "+transizioni[j].condizione+" non è determinato. Errore")
					die(1)
				end
				j := j+1
			end

			Result := "Result"

			-- Se evento_corrente è presente una volta in modo attivabile, stampo l'azione
			if evento_attivabile = 1 then
				output.put_string("Eseguo "+transizioni[indice_evento_attivabile].azione+" per l'evento "+evento_corrente+" dello stato "+nome)
				output.new_line
				Result := transizioni[indice_evento_attivabile].target
			-- Se è presente più d'una, stampo un errore
			elseif evento_attivabile > 1 then
				output.put_string("L'evento "+evento_corrente+" è presente molteplici volte con condizione vera. Errore")
				output.new_line
				die(1)
			-- Se non è presente, verrà ignorato
			elseif evento_attivabile < 1 then
				Result := "target_nullo"
				output.put_string ("Evento ignorato")
				output.new_line
			end
		end


	gestisci_transitorio(output: PLAIN_TEXT_FILE; tab_stati: HASH_TABLE[INTEGER,STRING]; tab_condizioni: HASH_TABLE[BOOLEAN,STRING]): STRING
		-- Stampa l'azione della prima transizione senza evento con condizione vera presente e restituisce il target.
		-- Se il target non esiste, dà errore.
		require
			transitorio
		do
			output.put_string ("Eseguo l'azione "+transizioni[indice_transizione(tab_condizioni)].azione+" della transizione senza evento dello stato "+nome+" con condizione "+transizioni[indice_transizione(tab_condizioni)].condizione)
			output.new_line
			if tab_stati.has(transizioni[indice_transizione(tab_condizioni)].target) then
				imposta_nome (transizioni[indice_transizione(tab_condizioni)].target)
			else
				output.put_string ("***** Lo stato "+transizioni[indice_transizione(tab_condizioni)].target+" non esiste. Errore *****")
				die(1)
			end
			Result := nome
		end


end
