note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "A&R"
	date: "$13/04$"
	revision: "$0$"


class
	EVENTO_TEST

inherit
	EQA_TEST_SET

feature -- Test routines

	test_lettura_eventi
			-- leggiamo da file
		local
			contenuto :ARRAY[STRING]

		do
			-- CHIARAMENTE non funziona perché acquisisci_... è una feature della cklass eesecutore, come facciamo a testarla?
			contenuto:=acquisisci_eventi("eventi.txt")
			assert("ERRORE DI LETTURA DA FILE",contenuto[1]=25)
		end

end


