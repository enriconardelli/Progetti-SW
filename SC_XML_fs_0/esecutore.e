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

	eventi: AMBIENTE
			-- memorizza gli eventi letti dal file
			-- l'array rappresenta gli istanti mentre ogni hash_table l'insieme degli eventi che occorrono nell'istante specifico

feature {NONE} -- Inizializzazione

	start (nomi_files: ARRAY [STRING])
			-- prepara la SC e avvia la sua esecuzione
			-- i parametri vanno scritti da Eiffel Studio con
			-- menu "Execution" -> "Execution Parameters" -> "Add"
			-- doppio click su spazio bianco accanto a "Arguments"
			-- scrivere i parametri ognuno tra doppi apici
		do
			print ("INIZIO!%N")
			print ("crea la SC in " + nomi_files [1] + "%N")
			create state_chart.make (nomi_files [1])
			print ("e la esegue con gli eventi in " + nomi_files [2] + "%N")
			create eventi.make_empty
			eventi.acquisisci_eventi (nomi_files [2])
			print ("acquisiti eventi %N")
			if not eventi.verifica_eventi_esterni(state_chart) then
				print ("WARNING nel file ci sono eventi che la SC non conosce %N")
			end
			print ("eventi verificati, si esegue la SC %N")
			state_chart.evolvi_SC (eventi.eventi_esterni)
		end

end
