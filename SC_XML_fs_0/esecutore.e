note
	description: "Classe radice del progetto"
	author: " Daniele Fakhoury & Eloisa Scarsella "
	date: "$Date$"
	revision: "  "

class
	ESECUTORE

create
	start

feature --Attributi
	--	conf: CONFIGURAZIONE

	state_chart: CONFIGURAZIONE

	eventi: ARRAY [STRING]
			-- serve durante la lettura degli eventi dal file

	albero: XML_CALLBACKS_NULL_FILTER_DOCUMENT

feature {NONE} -- Inizializzazione

	start
			-- prepara la SC e avvia la sua esecuzione
		do
			print ("INIZIO!%N")
			crea_albero
			create eventi.make_empty
			eventi := acquisisci_eventi
			print ("acquisiti eventi %N")
			create state_chart.make (albero)
			state_chart.evolvi_SC(eventi)
		end

feature

	crea_albero
		local
			parser: XML_PARSER
			un_file: STRING
		do
				--| Instantiate parser
			create {XML_STANDARD_PARSER} parser.make
				--| Build tree callbacks
			create albero.make_null
			parser.set_callbacks (albero)
			un_file := "esempio.xml"
				--| Parse the `file_name' content
			parser.parse_from_filename (un_file)
			if parser.error_occurred then
				print ("Parsing error!!! %N")
			else
				print ("Parsing OK. %N")
			end
		end

	acquisisci_eventi: ARRAY [STRING]
			-- Legge gli eventi dal file 'eventi.txt' e li inserisce in un vettore

		local
			file: PLAIN_TEXT_FILE
			v_eventi: ARRAY [STRING]
			i: INTEGER
		do
			create v_eventi.make_empty
			create file.make_open_read ("eventi.txt")
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
			--Serve a verificare che tutti gli eventi nel file eventi.txt compaiano effettivamente tra gli eventi di qualche transizione
			--Comunica a video se ci sono eventi incompatibili
		local
			v_new, v_old: ARRAY [STRING]
			h_stati: HASH_TABLE [STATO, STRING]
			i, j, k: INTEGER
			flag, flag_1: BOOLEAN
		do
			create v_new.make_empty
			h_stati := current.state_chart.stati
			v_old := current.eventi
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
					print ("%N SANTIDDIO!! L'evento " + v_old [i] + " non viene utilizzato!")
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
