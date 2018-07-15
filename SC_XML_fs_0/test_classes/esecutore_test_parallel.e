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

end
