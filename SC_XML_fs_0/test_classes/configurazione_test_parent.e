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

	t_xor_base
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "eventi_xor_1.txt"
			ambiente_prova.acquisisci_eventi (nomi_files_prova [2])
			configurazione_prova.evolvi_SC (ambiente_prova.eventi_esterni)
			if attached configurazione_prova as cp then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (A1b)", cp.stato_corrente.id.is_equal ("A1b"))
				if attached cp.stato_corrente.stato_genitore as sp then
					assert ("ERRORE il sistema non ha istanziato correttamente gli stati (A-A1)", sp.id.is_equal ("A1"))
				end
			end
		end

	t_impostazione_default
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "eventi_xor_1.txt"
			ambiente_prova.acquisisci_eventi (nomi_files_prova [2])
			configurazione_prova.evolvi_SC (ambiente_prova.eventi_esterni)
			if attached configurazione_prova as cp then
				if attached cp.stati.item ("A") as st then
					if attached st.stato_default as df then
						assert ("ERRORE il sistema non ha impostato correttamente il default di A", df.id.is_equal ("A1"))
					end
				end
			end
			if attached configurazione_prova as cp then
				if attached cp.stati.item ("A1") as st then
					if attached st.stato_default as df then
						assert ("ERRORE il sistema non ha impostato correttamente il default di A1", df.id.is_equal ("A1b"))
					end
				end
			end
		end

		t_xor_eventi_semplici
		do
			nomi_files_prova [2] := nomi_files_prova [2] + "eventi_xor_2.txt"
			ambiente_prova.acquisisci_eventi (nomi_files_prova [2])
			configurazione_prova.evolvi_SC (ambiente_prova.eventi_esterni)
			if attached configurazione_prova as cp then
				assert ("ERRORE il sistema non ha terminato nello stato corretto (B1)", cp.stato_corrente.id.is_equal ("B1"))
			end
		end

end
