note
	description: "Summary description for {ESECUTORE_TEST_PARALLEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ESECUTORE_TEST_PARALLEL

inherit
	ESECUTORE_TEST

feature -- Test

	t_base_parallelo
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_base_parallelo.xml"
			nomi_files_prova [2] := test_data_dir + "eventi_base_parallelo.txt"
			create esecutore.start (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A - TRE )", esecutore.stato_corrente.count = 2 and has_state(esecutore.stato_corrente,"C") and has_state(esecutore.stato_corrente,"TRE") )
		end

	t_condizioni_parallelo
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_parallelo_condizioni.xml"
			nomi_files_prova [2] := test_data_dir + "eventi_parallelo_condizioni.txt"
			create esecutore.start (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( C - DUE )", esecutore.stato_corrente.count = 2 and has_state(esecutore.stato_corrente,"DUE") and has_state(esecutore.stato_corrente,"C") )
	 		assert ("ERRORE il sistema non impostato correttamente le condizioni", esecutore.state_chart.condizioni.item ("alfa"))
		end

	t_entrata
	-- La transizione ha come target lo stato AND
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_entrata.xml"
			nomi_files_prova [2] := test_data_dir + "eventi_entrata.txt"
			create esecutore.start (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A2A1 - A2B1 )", esecutore.stato_corrente.count = 2 and has_state(esecutore.stato_corrente,"A2A1") and has_state(esecutore.stato_corrente,"A2B1") )
		end

	t_entrata_2
	-- La transizione ha come target uno stato nello stato AND
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_entrata_2.xml"
			nomi_files_prova [2] := test_data_dir + "eventi_entrata_2.txt"
			create esecutore.start (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A2A2 - A2B1 )", esecutore.stato_corrente.count = 2 and has_state(esecutore.stato_corrente,"A2A2") and has_state(esecutore.stato_corrente,"A2B1") )
		end

	t_uscita
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_uscita.xml"
			nomi_files_prova [2] := test_data_dir + "eventi_uscita.txt"
			create esecutore.start (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A2B1 )", esecutore.stato_corrente.count = 1 and has_state(esecutore.stato_corrente,"A2A2") )
		end

	t_esempio_complesso
		local
			esecutore: ESECUTORE
		do
			nomi_files_prova [1] := test_data_dir + "esempio_complesso.xml"
			nomi_files_prova [2] := test_data_dir + "eventi_complesso.txt"
			create esecutore.start (nomi_files_prova)
			assert ("ERRORE il sistema non ha terminato negli stati corretti ( A11 )", esecutore.stato_corrente.count = 1 and has_state(esecutore.stato_corrente,"A11") )
		end
end
