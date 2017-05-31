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

	albero: XML_CALLBACKS_NULL_FILTER_DOCUMENT
			-- rappresenta sotto forma di un albero la SC letta dal file

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
			crea_albero (nomi_files [1])
			create eventi_esterni.make_empty
			acquisisci_eventi (nomi_files [2])
			print ("acquisiti eventi %N")
			create state_chart.make (albero)
			if verifica_eventi_esterni then
				print ("eventi verificati, si esegue la SC %N")
				state_chart.evolvi_SC (eventi_esterni)
			else
				print (" nel file ci sono eventi che la SC non conosce %N")
			end
		end

feature

	crea_albero (nome_file_SC: STRING)
			-- crea e inizializza `albero'
		local
			parser: XML_PARSER
		do
				--| Instantiate parser
			create {XML_STANDARD_PARSER} parser.make
				--| Build tree callbacks
			create albero.make_null
			parser.set_callbacks (albero)
				--| Parse the `file_name' content
			parser.parse_from_filename (nome_file_SC)
			if parser.error_occurred then
				print ("Parsing error!!! %N")
			else
				print ("Parsing OK. %N")
			end
		end

	acquisisci_eventi (nome_file_eventi: STRING)
			-- Legge gli eventi dal file passato come secondo argomento e li inserisce in `eventi_esterni'

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
			eventi_nella_SC: HASH_TABLE [BOOLEAN, STRING]
			v_new: ARRAY [STRING]
			i, j: INTEGER
			evento_assente: BOOLEAN
		do
			create eventi_nella_SC.make (0)
			-- inserisce tutti gli eventi definiti nella SC in eventi_nella_SC
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
