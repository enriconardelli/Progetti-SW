note
	description: "Summary description for {CONFIGURAZIONE_TEST_PARENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONFIGURAZIONE_TEST_PARENT

inherit
	CONFIGURAZIONE_TEST
		redefine on_prepare end

feature -- Test routines

	on_prepare
		do
		    precursor
			nomi_files_prova[1] := test_data_dir + "esempio_xor.xml"
			nomi_files_prova[2] := test_data_dir
			create configurazione_prova.make(nomi_files_prova[1])
		end

feature -- Test

	t_xor
			-- Il processo dovrebbe arrestarsi nello stato "running"
		do
			nomi_files_prova[2] := nomi_files_prova[2] + "eventi_xor.txt"
			ambiente_prova.acquisisci_eventi (nomi_files_prova [2])
			configurazione_prova.evolvi_SC (ambiente_prova.eventi_esterni)
			if attached configurazione_prova as cp then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (B1)", cp.stato_corrente.id.is_equal("B1") )
				if attached cp.stato_corrente.stato_genitore as sp then
					assert ("ERRORE il sistema non ha istanziato correttamente gli stati (B-B1)", sp.id.is_equal("B") )
				end
			end
		end

end
