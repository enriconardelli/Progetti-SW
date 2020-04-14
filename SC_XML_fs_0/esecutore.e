note
	description: "Classe radice del progetto"
	author: " Daniele Fakhoury & Eloisa Scarsella "
	date: "$Date$"
	revision: "  "

class
	ESECUTORE

create
	make, start

feature -- Attributi

	state_chart: CONFIGURAZIONE
			-- rappresenta la SC durante la sua esecuzione

	eventi_esterni: ARRAY [STRING]
			-- memorizza gli eventi letti dal file


feature {NONE} -- Creazione e avvio interattivo

	start (nomi_files: ARRAY [STRING])
			-- prepara la SC e avvia la sua esecuzione
		do
			make (nomi_files)
			print ("%N=========%N EVOLUZIONE INIZIO%N")
			state_chart.evolvi_SC (eventi_esterni)
			print ("%N EVOLUZIONE FINE!%N=========%N")
		end

feature -- Creazione per i test

	make (nomi_files: ARRAY [STRING])
			-- prepara la SC con i parametri passati come argomento
			-- in Eiffel Studio vanno invece scritti mediante il
			-- menu "Execution" -> "Execution Parameters" -> "Add"
			-- doppio click su spazio bianco accanto a "Arguments"
			-- scrivere i parametri ognuno tra doppi apici
		do
			print ("%N=========%N CREAZIONE INIZIO%N")
			print ("crea la SC in " + nomi_files [1] + "%N")
			print ("con gli eventi in " + nomi_files [2] + "%N")
			create eventi_esterni.make_empty
			acquisisci_eventi (nomi_files [2])
			print ("acquisiti eventi %N")
			create state_chart.make(nomi_files [1])
			if verifica_eventi_esterni then
				print ("tutti gli eventi sono conosciuti dalla SC %N")
			else
				print ("nel file ci sono eventi che la SC non conosce %N")
			end
			print ("%N CREAZIONE FINE%N=========%N")
		end


feature -- file eventi

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
			-- Agulini Claudia, Fiorini Federico - 2020/04/11
		local
			eventi_nella_SC: HASH_TABLE [BOOLEAN, STRING]
			j: INTEGER
		do
			create eventi_nella_SC.make (0)
			-- inserisce tutti gli eventi definiti nella SC in eventi_nella_SC
			across
				state_chart.stati as st
			loop
				if attached st.item.transizioni as tr then
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
			end
			-- verifica che ogni evento esterno sia presente nella SC
			Result := True
			across
				eventi_esterni as ee
			loop
				if not eventi_nella_SC.has (ee.item) then
					print ("%N ATTENZIONE!! L'evento " + ee.item + " non viene utilizzato!")
					Result := False
				end
			end
		end

end
