note
	description: "Classe radice del progetto"
	author: " Daniele Fakhoury & Eloisa Scarsella "
	date: "$Date$"
	revision: "  "

class
	ESECUTORE

create
	start --, make

feature -- Attributi

	state_chart: CONFIGURAZIONE
			-- rappresenta la SC durante la sua esecuzione

	eventi_esterni: ARRAY [STRING]
			-- memorizza gli eventi letti dal file



feature {NONE} -- Inizializzazione

	start (nomi_files: ARRAY [STRING])
			-- prepara la SC e avvia la sua esecuzione
			-- i parametri vanno scritti da Eiffel Studio con
			-- menu "Execution" -> "Execution Parameters" -> "Add"
			-- doppio click su spazio bianco accanto a "Arguments"
			-- scrivere i parametri ognuno tra doppi apici
		do
			print ("INIZIO!%N")
			print ("esegue la SC in " + nomi_files [1] + "%N")
			print ("con gli eventi in " + nomi_files [2] + "%N")
			create eventi_esterni.make_empty
			acquisisci_eventi (nomi_files [2])
			print ("acquisiti eventi %N")
			create state_chart.make(nomi_files [1])
			if verifica_eventi_esterni then
				print ("eventi verificati, si esegue la SC %N")
				-- TODO si puo' invocare evolvi_SC anche se ci sono eventi che la SC non conosce
				state_chart.evolvi_SC (eventi_esterni)
			else
				print (" nel file ci sono eventi che la SC non conosce %N")
			end
		end

feature



	acquisisci_eventi (nome_file_eventi: STRING)
			-- Legge gli eventi dal file passato come secondo argomento e li inserisce in `eventi_esterni'
			-- TODO non gestisce il caso in cui su una riga del file degli eventi ci sia più di un evento
		local
			file: PLAIN_TEXT_FILE
			i: INTEGER
		do
			create file.make_open_read (nome_file_eventi)
			from
				i := 1
			until
				file.off
			loop
				file.read_line
				eventi_esterni.force (file.last_string.twin, i)
				i := i + 1
			end
			file.close
		end

	verifica_eventi_esterni: BOOLEAN
			-- Verifica che tutti gli eventi nel file compaiano effettivamente tra gli eventi di qualche transizione
			-- Segnala l'eventuale presenza di eventi incompatibili
		local
			-- TODO eliminare v_new, sostituire evento_assente con Result, eliminare una tra i e j
			eventi_nella_SC: HASH_TABLE [BOOLEAN, STRING]
			v_new: ARRAY [STRING]
			i, j: INTEGER
			evento_assente: BOOLEAN
		do
			create eventi_nella_SC.make (0)
			-- inserisce tutti gli eventi definiti nella SC in eventi_nella_SC
			-- TODO cambiare l'iterazione completa da esplicita ad implicita con across
			from
				state_chart.stati.start
			until
				state_chart.stati.after
			loop
				if attached state_chart.stati.item_for_iteration.transizioni as tr then
					from
						j := 1
					until
						j = tr.count + 1
					loop
						if attached tr [j].evento as e then
							eventi_nella_SC.put (True, e)
						end
						j := j + 1
					end
				end
				state_chart.stati.forth
			end
			-- verifica che ogni evento esterno sia presente nella SC
			-- TODO cambiare l'iterazione completa da esplicita ad implicita con across
			from
				i := 1
			until
				i = eventi_esterni.count + 1
			loop
				if not eventi_nella_SC.has (eventi_esterni [i]) then
					print ("%N ATTENZIONE!! L'evento " + eventi_esterni [i] + " non viene utilizzato!")
					evento_assente := True
				end
				i := i + 1
			end
			Result := not evento_assente
		end

end
