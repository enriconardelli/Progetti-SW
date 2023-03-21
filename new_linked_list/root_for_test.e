note
	description: "root class for NEW_LINKED_LIST"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT_FOR_TEST

inherit
	ARGUMENTS_32

create
	make

feature -- infrastructure
	t: INT_LINKED_LIST
	r: STRING = "%N"

feature -- single feature test

	test_has
	-- implementata la relativa feature di test
		do
			print (r + "test di has" + r)
			create t
--			print ("t e' vuota, t contiene 3? ")
--			print (t.has (3).out + r)
			t.append (3)
			-- [3]
			t.printout
			print ("t contiene 3? ")
			print (t.has (3).out + r)
			print ("t contiene 4? ")
			print (t.has (4).out + r)
			t.append (7)
			-- [3, 7]
			t.printout
			print ("t contiene 3? ")
			print (t.has (3).out + r)
			print ("t contiene 4? ")
			print (t.has (4).out + r)
			print ("t contiene 7? ")
			print (t.has (7).out + r)
		end

	test_has_CON_active
	-- implementata la relativa feature di test
		do
			print (r + "test di has_CON_active" + r)
			create t
			print ("t e' vuota, t contiene 3? ")
			print (t.has_CON_active (3).out + r)
			t.append (3)
			-- [3]
			t.printout
			print ("t contiene 3? ")
			print (t.has_CON_active (3).out + r)
			print ("t contiene 4? ")
			print (t.has_CON_active (4).out + r)
			t.append (7)
			-- [3, 7]
			t.printout
			print ("t contiene 3? ")
			print (t.has_CON_active (3).out + r)
			print ("t contiene 4? ")
			print (t.has_CON_active (4).out + r)
			print ("t contiene 7? ")
			print (t.has_CON_active (7).out + r)
		end

	test_append
	-- implementata la relativa feature di test
		do
			print (r + "test di append" + r)
			create t
			t.append (0)
			t.append (-4)
			print ("stampo la lista" + r)
			t.printout
			print (r)
		end

	test_prepend
	-- implementata la relativa feature di test
		do
			print (r + "test di prepend" + r)
			create t
			t.prepend (0)
			t.prepend (-4)
			print ("stampo la lista" + r)
			t.printout
			print (r)
		end

	test_get_element
		do
			print (r + "test di get_element" + r)
			create t
			print ("t e' vuota, t restituisce 3?" + r)
			print (t.get_element (3))
			print (r) -- get_element è detachable e non si può invocare direttamente .out che consentirebbe concatenzazione con `r'
			t.append (3)
			print ("t contiene 3, t restituisce 3?" + r)
			print (t.get_element (3))
			print (r)
			print ("t contiene 3, t restituisce 4?" + r)
			print (t.get_element (4))
			print (r)
			t.append (7)
			print ("t contiene 3 e 7, t restituisce 3?" + r)
			print (t.get_element (3))
			print (r)
			print ("t contiene 3 e 7, t restituisce 4?" + r)
			print (t.get_element (4))
			print (r)
			print ("t contiene 3 e 7, t restituisce 7?" + r)
			print (t.get_element (7))
		end

	test_insert_after
		do
			print (r + "test di insert_after" + r)
			create t
			print ("t vuota, inserisco 4 dopo 7" + r)
			t.insert_after(4,7)
			print ("inserisco 5 dopo 7" + r)
			t.insert_after(5,7)
			print ("inserisco -1 dopo 4" + r)
			t.insert_after(-1,4)
			t.printout
		end

	test_insert_after_CON_get_element_append
		do
			print (r + "test di insert_after_CON_get_element_append" + r)
			create t
			print ("t vuota, inserisco 4 dopo 7" + r)
			t.insert_after_CON_get_element_append(4,7)
			print ("inserisco 5 dopo 7" + r)
			t.insert_after_CON_get_element_append(5,7)
			print ("inserisco -1 dopo 4" + r)
			t.insert_after_CON_get_element_append(-1,4)
			t.printout
		end

	test_insert_before
		do
			print (r + "test di insert_before" + r)
			create t
			print ("inseriment in lista vuota: 4 prima di 7" + r)
			t.insert_before(4,7)
			-- [4]
			print ("inserimento quando target e' primo elemento: 5 prima di 4" + r)
			t.insert_before(5,4)
			-- [5, 4]
			print ("inserimento con target esistente non primo elemento: -1 prima di 4" + r)
			t.insert_before(-1,4)
			-- [5, -1, 4]
			print ("inserimento con target non esistente: -1 prima di 7" + r)
			t.insert_before(-1,7)
			-- [-1, 5, -1, 4]
			t.printout
		end

	test_insert_before_CON_2_CURSORI
		do
			print (r + "test di insert_before (versione con 2 cursori che scorrono la lista)" + r)
			create t
			print ("inseriment in lista vuota: 4 prima di 7" + r)
			t.insert_before_CON_2_CURSORI(4,7)
			-- [4]
			print ("inserimento quando target e' primo elemento: 5 prima di 4" + r)
			t.insert_before_CON_2_CURSORI(5,4)
			-- [5, 4]
			print ("inserimento con target esistente non primo elemento: -1 prima di 4" + r)
			t.insert_before_CON_2_CURSORI(-1,4)
			-- [5, -1, 4]
			print ("inserimento con target non esistente: -1 prima di 7" + r)
			t.insert_before_CON_2_CURSORI(-1,7)
			-- [-1, 5, -1, 4]
			t.printout
		end

	test_value_follows
			-- require has(target)
		do
			print (r + "test di value_follows" + r)
			create t
			print ("t vuota, appendo 5" + r)
			t.append(5)
			-- [5]
			print ("poi prependo 4" + r)
			t.prepend(4)
			-- [4, 5]
			print ("poi appendo 7" + r)
			t.append(7)
			-- [4, 5, 7]
			t.printout
			print ("5 segue 4? ")
			print (t.value_follows (5,4).out + r)
			print ("7 segue 4? ")
			print (t.value_follows (7,4).out + r)
			print ("7 segue 5? ")
			print (t.value_follows (7,5).out + r)
			print ("4 segue 5? ")
			print (t.value_follows (4,5).out + r)
			print ("4 segue 7? ")
			print (t.value_follows (4,7).out + r)
			print ("5 segue 7? ")
			print (t.value_follows (5,7).out + r)
		end

	test_value_precedes
			-- require has(target)
		do
			print (r + "test di value_precedes" + r)
			create t
			print ("t vuota, appendo 5" + r)
			t.append(5)
			-- [5]
			print ("poi prependo 4" + r)
			t.prepend(4)
			-- [4, 5]
			print ("poi appendo 7" + r)
			t.append(7)
			-- [4, 5, 7]
			t.printout
			print ("3 precede 4? ")
			print (t.value_precedes (3,4).out + r)
			print ("3 precede 7? ")
			print (t.value_precedes (3,7).out + r)
			print ("4 precede 5? ")
			print (t.value_precedes (4,5).out + r)
			print ("4 precede 7? ")
			print (t.value_precedes (4,7).out + r)
			print ("5 precede 7? ")
			print (t.value_precedes (5,7).out + r)
			print ("appendo 4" + r)
			t.append(4)
			-- [4, 5, 7, 4]
			t.printout
			print ("5 precede 4? ")
			print (t.value_precedes (5,4).out + r)
			print ("7 precede 4? ")
			print (t.value_precedes (7,4).out + r)
			print ("7 precede 5? ")
			print (t.value_precedes (7,5).out + r)
		end

	test_value_precedes_CON_start_forth
			-- require has(target)
		do
			print (r + "test di value_precedes_CON_start_forth" + r)
			create t
			print ("t vuota, appendo 5" + r)
			t.append(5)
			-- [5]
			print ("poi prependo 4" + r)
			t.prepend(4)
			-- [4, 5]
			print ("poi appendo 7" + r)
			t.append(7)
			-- [4, 5, 7]
			t.printout
			print ("3 precede 4? ")
			print (t.value_precedes_CON_start_forth (3,4).out + r)
			print ("3 precede 7? ")
			print (t.value_precedes_CON_start_forth (3,7).out + r)
			print ("4 precede 5? ")
			print (t.value_precedes_CON_start_forth (4,5).out + r)
			print ("4 precede 7? ")
			print (t.value_precedes_CON_start_forth (4,7).out + r)
			print ("5 precede 7? ")
			print (t.value_precedes_CON_start_forth (5,7).out + r)
			t.append(4)
			-- [4, 5, 7, 4]
			t.printout
			print ("5 precede 4? ")
			print (t.value_precedes_CON_start_forth (5,4).out + r)
			print ("7 precede 4? ")
			print (t.value_precedes_CON_start_forth (7,4).out + r)
			print ("7 precede 5? ")
			print (t.value_precedes_CON_start_forth (7,5).out + r)
		end

	test_value_precedes_SENZA_has
		do
			print (r + "test di value_precedes_SENZA_has" + r)
			create t
			print ("t vuota, appendo 5" + r)
			t.append(5)
			-- [5]
			print ("poi prependo 4" + r)
			t.prepend(4)
			-- [4, 5]
			print ("poi appendo 7" + r)
			t.append(7)
			-- [4, 5, 7]
			t.printout
			print ("3 precede 4? ")
			print (t.value_precedes_SENZA_has (3,4).out + r)
			print ("3 precede 7? ")
			print (t.value_precedes_SENZA_has (3,7).out + r)
			print ("3 precede 10? ")
			print (t.value_precedes_SENZA_has (3,10).out + r)
			print ("4 precede 5? ")
			print (t.value_precedes_SENZA_has (4,5).out + r)
			print ("4 precede 7? ")
			print (t.value_precedes_SENZA_has (4,7).out + r)
			print ("5 precede 7? ")
			print (t.value_precedes_SENZA_has (5,7).out + r)
			t.append(4)
			-- [4, 5, 7, 4]
			t.printout
			print ("5 precede 4? ")
			print (t.value_precedes_SENZA_has (5,4).out + r)
			print ("7 precede 4? ")
			print (t.value_precedes_SENZA_has (7,4).out + r)
			print ("7 precede 5? ")
			print (t.value_precedes_SENZA_has (7,5).out + r)
		end

	test_index_earliest_of
		do
			print (r + "test di index_earliest_of" + r)
			create t
			print ("t vuota" + r)
			print ("3 e' in posizione: ")
			print (t.index_earliest_of (3).out + r)
			print ("t vuota, appendo 5" + r)
			t.append(5)
			-- [5]
			print ("poi prependo 4" + r)
			t.prepend(4)
			-- [4, 5]
			print ("poi appendo 7" + r)
			t.append(7)
			-- [4, 5, 7]
			t.printout
			print ("3 e' in posizione: ")
			print (t.index_earliest_of (3).out + r)
			print ("4 e' in posizione: ")
			print (t.index_earliest_of (4).out + r)
			print ("5 e' in posizione: ")
			print (t.index_earliest_of (5).out + r)
			print ("7 e' in posizione: ")
			print (t.index_earliest_of (7).out + r)
		end

feature -- Inizialization
	make
			-- Run application.
		do
				--| Add your code here
			print ("Hello Eiffel World!" + r)
--			print ("Attempt to print VOID ->")
--			print (Void)
--			print ("<- End attempt to print VOID" + r)
--			test_append
--			test_prepend
--			test_has
--			test_has_CON_active
--			test_get_element
--			test_insert_after
--			test_insert_after_CON_get_element_append
--			test_insert_before
--			test_insert_before_CON_2_CURSORI
--			test_value_follows
--			test_value_precedes
--			test_value_precedes_CON_start_forth
--			test_value_precedes_SENZA_has
			test_index_earliest_of
		end



end
