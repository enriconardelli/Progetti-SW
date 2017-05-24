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

	eventi: ARRAY [STRING]
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
			print ("con gli eventi in" + nomi_files [2] + "%N")
			crea_albero (nomi_files [1])
			create eventi.make_empty
			eventi := acquisisci_eventi (nomi_files [2])
			print ("acquisiti eventi %N")
			create state_chart.make (albero)
			if verifica_eventi.count /= 0 then
				print (" nel file ci sono eventi che la SC non conosce %N")
			else
				print ("eventi verificati, si esegue la SC %N")
				state_chart.evolvi_SC (eventi)
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

	acquisisci_eventi (nome_file_eventi: STRING): ARRAY [STRING]
			-- Legge gli eventi dal file 'eventi.txt' e li inserisce in `eventi'

		local
			file: PLAIN_TEXT_FILE
			v_eventi: ARRAY [STRING]
			i: INTEGER
		do
			create v_eventi.make_empty
			create file.make_open_read (nome_file_eventi)
			from
				i := 1
			until
				file.off
			loop
				file.read_line
				v_eventi.force (file.last_string.twin, i)
				i := i + 1
			end
			file.close
			Result := v_eventi
		end

	verifica_eventi: ARRAY [STRING]
			-- Verifica che tutti gli eventi nel file compaiano effettivamente tra gli eventi di qualche transizione
			-- Segnala l'eventuale presenza di eventi incompatibili
		local
			v_new, v_old: ARRAY [STRING]
			h_stati: HASH_TABLE [STATO, STRING]
			i, j, k: INTEGER
			flag, flag_1: BOOLEAN
		do
			create v_new.make_empty
			h_stati := state_chart.stati
			v_old := eventi
			k := 1
			from
				i := 1
			until
				i = eventi.count + 1
			loop
				flag := False
				from
					h_stati.start
				until
					h_stati.after OR flag
				loop
					flag_1 := False
					if attached h_stati.item_for_iteration.get_events as tp then
						from
							j := 1
						until
							j = tp.count + 1 or flag_1
						loop
							if tp [j] ~ v_old [i] then
								v_new.force (v_old [i].twin, k)
								k := k + 1
								flag_1 := True
								flag := True
							else
								j := j + 1
							end
						end
					end
					h_stati.forth
				end
				if NOT flag then
					print ("%N ATTENZIONE!! L'evento " + v_old [i] + " non viene utilizzato!")
				end
				i := i + 1
			end
			Result := v_new
		end

		--			ottieni_evento: STRING --serve a verificare che tutti gli eventi nel file eventi.txt compaiano effettivamente
		--								   --tra gli eventi di qualche transizione
		--					  local
		--					    evento_letto: STRING
		--				do
		--					Result := ""
		--						  FROM
		--						    evento_letto := leggi_prossimo_evento
		--						  UNTIL
		--						    count_evento_corrente>eventi.count
		--						  LOOP
		--						    messaggio_di_errore(evento_letto non è un evento legale)
		--						    evento_letto := leggi_prossimo_evento
		--						  END
		--						  IF evento_letto IN eventi THEN
		--						    Result := evento_letto
		--				end

end
