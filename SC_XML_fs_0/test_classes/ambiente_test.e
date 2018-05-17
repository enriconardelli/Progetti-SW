note
	description: "Summary description for {AMBIENTE_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AMBIENTE_TEST

inherit
	EQA_TEST_SET
		redefine
			on_prepare
		end

feature {NONE} -- Supporto
	a_path: PATH
	test_data_dir: STRING = "test_data"
	altro_configurazione_prova, configurazione_prova: CONFIGURAZIONE
	ambiente: AMBIENTE

feature -- Test routines

	on_prepare
		do
			create a_path.make_current
			test_data_dir.append_character(a_path.directory_separator)
			create configurazione_prova.make(test_data_dir + "esempio_per_esecutore_test.xml")
			create altro_configurazione_prova.make(test_data_dir + "eventi_per_esecutore_test.txt")
			create ambiente.make_empty
		end

feature -- Test routines

	test_verifica_eventi_esterni
		do
			assert("non viene rilevato evento esterno assente",ambiente.verifica_eventi_esterni(configurazione_prova)=True)
			assert("viene falsamente rilevato evento esterno assente",ambiente.verifica_eventi_esterni(altro_configurazione_prova)=True)
		end

end
