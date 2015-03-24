note
	description : "SC_flat_simple root class"
	date        : "26.02.15"
	revision    : "v 3.0"

class
	APPLICATION

inherit
	ARGUMENTS
	EXCEPTIONS

create
	make

feature {NONE} -- Initialization

	input: PLAIN_TEXT_FILE

	output: PLAIN_TEXT_FILE

	lista_eventi: PLAIN_TEXT_FILE

	lista_condizioni: PLAIN_TEXT_FILE

	stato_iniziale: STATO

	stato_finale: STATO

	stato_attivo: STATO

	stati: ARRAY[STATO]

	tab_stati: HASH_TABLE[INTEGER,STRING]

	tab_condizioni: HASH_TABLE[BOOLEAN,STRING]

	acquisisci_stato(s: STRING)
		-- crea un nuovo stato che pone all'ultimo posto
		-- dell'array stati, e gli imposta il nome s
		local
			stato_supporto: STATO
		do
			create stato_supporto.crea_stato
			stati.force (stato_supporto, stati.count + 1)
			stati[stati.count].imposta_nome (s)
		end

	aggiorna_stato(s: STRING; evento: STRING)
		do
			-- Controllo target: se non esiste, interrompo il programma
			if not tab_stati.has (s) then
				output.put_string("Errore: il target "+s+" dello stato "+stato_attivo.nome+" per l'evento "+evento+" non esiste.")
				die(1)
			else
			stato_attivo := stati[tab_stati.item (s)]
			end
		end

	make
		local
			i: INTEGER
			j: INTEGER
			errori: INTEGER
			indice_iniziale: INTEGER
			indice_finale: INTEGER
			fine_eventi: STRING
			fine_stati: STRING
			target: STRING
			evento: STRING
			azione: STRING
			condizione: STRING
			valore: BOOLEAN
			target_attivo: STRING
			conto_iniziali: INTEGER
			conto_finali: INTEGER
			stati_transitori: INTEGER

		do
			create input.make_open_read("model.txt")
			create lista_eventi.make_open_read("lista_eventi.txt")
			create lista_condizioni.make_open_read("lista_condizioni.txt")
			create output.make_open_write("output.txt")

			-- creazione stati
			create stati.make_empty
			create stato_iniziale.crea_stato
			create stato_finale.crea_stato
			create stato_attivo.crea_stato

			fine_eventi := "fine_eventi"
			fine_stati := "fine_stati"
			evento := "evento"
			azione := "azione"
			target := "target"
			condizione := "condizione"

			-- LETTURA lista_condizioni.txt e CREAZIONE TABELLA CONDIZIONE/VALORE

			create tab_condizioni.make (0)
			from
				i :=1
			until
				lista_condizioni.end_of_file
			loop
				lista_condizioni.read_word
				if not lista_condizioni.last_string.is_equal ("/") then
					condizione := lista_condizioni.last_string.twin
				end
				lista_condizioni.read_word
				lista_condizioni.read_integer
				if lista_condizioni.last_integer = 1 then
					valore := true
					tab_condizioni.put (valore,condizione)
					output.put_string (condizione+" = ")
					output.put_boolean (valore)
					output.new_line
				elseif lista_condizioni.last_integer = 0 then
					valore := false
					tab_condizioni.put (valore,condizione)
					output.put_string (condizione+" = ")
					output.put_boolean (valore)
					output.new_line
				else
					output.put_string ("Il valore booleano associato a "+condizione+" non e' booleano. Errore")
					output.new_line
					io.put_string ("Il valore booleano associato a "+condizione+" non e' booleano. Errore")
					io.new_line
					errori := errori + 1
					io.put_integer (errori)
					io.put_new_line
				end

			end
			tab_condizioni.put (true,"nessuna condizione")
			output.new_line

			-- LETTURA model.txt E ACQUISIZIONE STATI

			i := 1
			from

			until
				fine_stati.is_equal ("*")
			loop
				fine_eventi := "fine_eventi"
				fine_stati := "fine_stati"

				-- lettura e impostazione nome dell'i-esimo stato
				input.read_word
				acquisisci_stato(input.last_string)

				-- Impostazione di un eventuale stato iniziale
				if stati[stati.count].nome.head (1).is_equal ("$") then
					stati[stati.count].nome.keep_tail (stati[stati.count].nome.count -1)
					indice_iniziale := stati.count.twin
					conto_iniziali := conto_iniziali + 1
				end
				if conto_iniziali > 1 then
					output.put_string ("Errore: è presente più di uno stato iniziale!")
					output.new_line
					die(1)
				end
				-- Impostazione di un eventuale stato finale
				if stati[stati.count].nome.head (1).is_equal ("£") then
					-- Se il nome di uno stato comincia con "£", lo tolgo dal nome
					stati[stati.count].nome.keep_tail(stati[stati.count].nome.count - 1)
					indice_finale := stati.count.twin
					conto_finali := conto_finali + 1
				end
				if conto_finali > 1 then
					output.put_string ("Errore: è presente più di uno stato finale!")
					output.new_line
					die(1)
				end
				output.put_string (stati[stati.count].nome)
				output.new_line

				-- Passo alla linea successiva al nome
				input.next_line

				-- loop per lettura quaterne dell'i-esimo stato
				from

				until
					fine_eventi.is_equal("+") or fine_eventi.is_equal("*")
				loop
					fine_eventi := "fine_eventi"

					-- Inizio acquisizione quaterna
					input.read_word

					-- Controllo esistenza della quaterna: se non c'è, assegno fine_eventi e non faccio altro
					if input.last_string.is_equal("+") or input.last_string.is_equal ("*") then
						fine_eventi := input.last_string

					-- Se la quaterna c'è, l'acquisisco
					else
						-- Lettura e acquisizione evento
						if not input.last_string.is_equal ("/") then
							evento := input.last_string.twin
							input.read_word
						else
							evento := "evento vuoto"
						end

						-- Lettura e acquisizione condizione
						input.read_word
						if not input.last_string.is_equal("/") then
							condizione := input.last_string.twin
							input.read_word
							-- Stampa di errore (a video e su output.txt) se condizione non è presente in lista_condizioni.txt
							if not tab_condizioni.has (condizione) then
								errori := errori + 1
								io.put_string ("La condizione "+condizione+" non e' presente in lista_condizioni.txt")
								io.put_new_line
								io.put_integer (errori)
								io.put_new_line
								output.put_string ("***** La condizione "+condizione+" non è presente in lista_condizioni.txt. *****")
								output.put_new_line
							end
						else
							condizione := "nessuna condizione"
						end

						-- Determinazione transitorietà
						-- Se ho un evento vuoto e la condizione associata è vera, imposto lo stato come stato transitorio
						-- NOTA: basta una sola transizione senza evento con condizione vera affinché lo stato sia transitorio
						if evento.is_equal ("evento vuoto") and then tab_condizioni.has (condizione) and then tab_condizioni[condizione] then
							stati[i].imposta_transitorio (true)
						end

						-- Lettura e acquisizione azione
						input.read_word
						if not input.last_string.is_equal ("/") then
							azione := input.last_string.twin
							input.read_word
						else
							azione := "nessuna azione"
						end

						-- Lettura e acquisizione target
						-- L'uso della feature read_line consente di leggere fino a end_of_line senza passare alla riga successiva;
						-- non vengono però ignorati gli spazi iniziali, che devono quindi essere eliminati.
						input.read_line
						input.last_string.left_adjust
						target := input.last_string.twin

						-- Acquisizione quaterna dall'i-esimo stato
						stati[i].acquisisci_quaterna(evento,condizione,azione,target,output)

						-- Controllo un'eventuale fine degli eventi: se la prima "parola" è "+" o "*", uscirò dal loop
						input.read_stream(1)
						fine_eventi := input.last_string
						input.back
					end
				end

				-- Se fine_eventi.is_equal("+"), devo passare alla riga successiva
				input.next_line
				if stati[i].transitorio then
					stati_transitori := stati_transitori+1
				end

				-- Controllo che lo stato non sia vuoto
				if stati[i].non_vuoto then
					-- Controllo la presenza di eventi attivabili multipli
					if stati[i].evento_attivabile_multiplo (tab_condizioni) then
						errori := errori + 1
						io.put_integer (errori)
						io.put_new_line
						-- Stampa errore (a video e su output.txt) evento multiplo
						io.put_string ("Lo stato "+stati[i].nome+" presenta lo stesso evento attivabile molteplici volte.")
						io.put_new_line
						output.put_string ("***** Lo stato "+stati[i].nome+" presenta lo stesso evento attivabile molteplici volte.*****")
						output.put_new_line
					end
				else
					errori := errori + 1

					-- Stampa errore (a video e su otuput.txt) stato vuoto
					io.put_string ("Lo stato "+stati[i].nome+" risulta vuoto.")
					io.put_new_line
					io.put_integer (errori)
					io.put_new_line
					output.put_string ("***** Lo stato "+stati[i].nome+" risulta vuoto.*****")
					output.put_new_line
				end

				i := i+1
				fine_stati := fine_eventi
				output.new_line

			end -- fine acquisizione stati

			if conto_iniziali = 0 then
				stato_iniziale := stati[1].twin
			else
				stato_iniziale := stati[indice_iniziale].twin
			end

			if conto_finali = 0 then
				stato_finale := stati[stati.count].twin
			else
				stato_finale := stati[indice_finale].twin
			end

			output.put_string ("stato_iniziale = "+stato_iniziale.nome)
			output.new_line
			output.put_string ("stato_finale = "+stato_finale.nome)
			output.new_line
			output.new_line

			-- CREAZIONE TABELLA tab_stati TARGET/INDICI

			create tab_stati.make(stati.count)
			from
				i := 1
			until
				i > stati.count
			loop
				tab_stati.put(i, stati[i].nome)
				i := i+1
			end

			-- Controllo che i target corrispondano a stati esistenti
			from
				i := 1
			until
				i > stati.count
			loop
				if stati[i].non_vuoto then
					from
						j := 1
					until
						j > stati[i].transizioni.count
					loop
						if not tab_stati.has(stati[i].transizioni[j].target) then
							errori := errori +1
							-- Stampa errore (a video e su output.txt) di target non presente
							io.put_string ("Il target "+stati[i].transizioni[j].target+" dello stato "+stati[i].nome+" associato all'evento "+stati[i].transizioni[j].evento+" con condizione "+stati[i].transizioni[j].condizione+" non esiste.")
							io.put_new_line
							io.put_integer (errori)
							io.put_new_line
							output.put_string ("***** Il target "+stati[i].transizioni[j].target+" dello stato "+stati[i].nome+" associato all'evento "+stati[i].transizioni[j].evento+" con condizione "+stati[i].transizioni[j].condizione+" non esiste. *****")
							output.put_new_line
						end
						j := j+1
					end
				end
				i := i+1
			end

			-- Richiesta all'utente esecuzione state chart
			if errori > 0 then
				io.put_string ("Il programma presenta ")
				io.put_integer (errori)
				io.put_string (" errori. Si desidera continuare? y/n")
				io.put_new_line
				from

				until
					io.last_string.is_equal("y") or io.last_string.is_equal("n")
				loop
					io.read_line
				end
				if io.last_string.is_equal("n") then
					die(1)
				end
			end

			-- ESECUZIONE STATE CHART
			output.put_new_line
			output.put_string ("INIZIO ESECUZIONE STATE CHART")
			output.put_new_line

			stato_attivo := stato_iniziale

			from

			until
				lista_eventi.end_of_file or stato_attivo.nome.is_equal (stato_finale.nome)
			loop
				-- Eseguo le transizioni senza evento fino a quando lo stato_attivo NON è transitorio
				from

				until
					not stato_attivo.transitorio
				loop
					if stato_attivo.non_vuoto then
						stato_attivo := stati[tab_stati[stato_attivo.gestisci_transitorio(output,tab_stati,tab_condizioni)]]
					else
						output.put_string ("***** Lo stato "+stato_attivo.nome+" risulta vuoto. Errore *****")
						die(1)
					end
				end
				if stato_attivo.non_vuoto then
					lista_eventi.read_word
					target_attivo := stato_attivo.gestisci_evento(lista_eventi.last_string,tab_condizioni,output)
					-- Se non trovo l'evento nello stato_attivo, "gestisci_evento" restituisce "target_nullo":
					-- in questo caso, l'evento_corrente è ignorato e si passa al successivo
					if not target_attivo.is_equal ("target_nullo") then
						aggiorna_stato(target_attivo,lista_eventi.last_string)
					end
					lista_eventi.next_line
				else
					output.put_string ("***** Lo stato "+stato_attivo.nome+" risulta vuoto. Errore *****")
					die(1)
				end
			end
			if lista_eventi.end_of_file then
				output.put_string ("Esecuzione state chart conclusa: fine lista eventi")
			else
				output.put_string ("Esecuzione state chart conclusa: stato finale raggiunto")
			end
	end
end
