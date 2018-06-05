note
	description: "Summary description for {CONFIGURAZIONE_TEST_AZIONI}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONFIGURAZIONE_TEST_AZIONI

inherit
	CONFIGURAZIONE_TEST
		redefine on_prepare end

feature -- Test routines

	on_prepare
		do
		    precursor
			nomi_files_prova[1] := test_data_dir + "esempio_xor_azioni.xml"
			nomi_files_prova[2] := test_data_dir
			create configurazione_prova.make(nomi_files_prova[1])
		end

feature -- Test

	t_xor_azioni
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "eventi_xor_2.txt"
			ambiente_prova.acquisisci_eventi (nomi_files_prova [2])
			configurazione_prova.evolvi_SC (ambiente_prova.eventi_esterni)
			if attached configurazione_prova as cp then
				assert ("ERRORE il sistema non ha eseguito l'azione on_entryB", cp.condizioni.item ("on_entryB") )
				assert ("ERRORE il sistema non ha eseguito l'azione on_entryB1", cp.condizioni.item ("on_entryB1") )
				assert ("ERRORE il sistema non ha eseguito l'azione on_exitA", cp.condizioni.item ("on_exitA") )
				assert ("ERRORE il sistema non ha eseguito l'azione on_exitA1", cp.condizioni.item ("on_exitA1") )
				assert ("ERRORE il sistema non ha eseguito l'azione on_exitA1b", cp.condizioni.item ("on_exitA1b") )
			end
		end

end
