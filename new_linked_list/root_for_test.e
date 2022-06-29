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
			print ("t e' vuota, t contiene 3? ")
			print (t.has (3).out + r)
			t.append (3)
			print ("t contiene 3, t contiene 3? ")
			print (t.has (3).out + r)
			print ("t contiene 3, t contiene 4? ")
			print (t.has (4).out + r)
			t.append (7)
			print ("t contiene 3 e 7, t contiene 3? ")
			print (t.has (3).out + r)
			print ("t contiene 3 e 7, t contiene 4? ")
			print (t.has (4).out + r)
			print ("t contiene 3 e 7, t contiene 7? ")
			print (t.has (7).out + r)
		end

	test_has_CON_ACTIVE
	-- implementata la relativa feature di test
		do
			print (r + "test di has_CON_ACTIVE" + r)
			create t
			print ("t e' vuota, t contiene 3? ")
			print (t.has_CON_ACTIVE (3).out + r)
			t.append (3)
			print ("t contiene 3, t contiene 3? ")
			print (t.has_CON_ACTIVE (3).out + r)
			print ("t contiene 3, t contiene 4? ")
			print (t.has_CON_ACTIVE (4).out + r)
			t.append (7)
			print ("t contiene 3 e 7, t contiene 3? ")
			print (t.has_CON_ACTIVE (3).out + r)
			print ("t contiene 3 e 7, t contiene 4? ")
			print (t.has_CON_ACTIVE (4).out + r)
			print ("t contiene 3 e 7, t contiene 7? ")
			print (t.has_CON_ACTIVE (7).out + r)
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
			print (r) -- get_element è detachable e non si può invocare direttamente .out
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
			print (r)
		end

	test_insert_after
		do
			print (r + "test di insert_after" + r)
			create t
			print ("t vuota, inserisco 4 dopo 7")
			t.insert_after(4,7)
			print (r + "inserisco 5 dopo 7")
			t.insert_after(5,7)
			print (r + "inserisco -1 dopo 4")
			t.insert_after(-1,4)
			print (r)
			t.printout
		end

	test_insert_after_reusing
		do
			print (r + "test di insert_after_reusing" + r)
			create t
			print ("t vuota, inserisco 4 dopo 7")
			t.insert_after_using_get_element_append(4,7)
			print (r + "inserisco 5 dopo 7")
			t.insert_after_using_get_element_append(5,7)
			print (r + "inserisco -1 dopo 4")
			t.insert_after_using_get_element_append(-1,4)
			print (r)
			t.printout
		end

	test_insert_before
		do
			print (r + "test di insert_before" + r)
			create t
			print ("inseriment in lista vuota: 4 prima di 7")
			t.insert_before(4,7)
			-- [4]
			print (r + "inserimento quando target e' primo elemento: 5 prima di 4")
			t.insert_before(5,4)
			-- [5, 4]
			print (r + "inserimento con target esistente non primo elemento: -1 prima di 4")
			t.insert_before(-1,4)
			-- [5, -1, 4]
			print (r + "inserimento con target non esistente: -1 prima di 7")
			t.insert_before(-1,7)
			-- [-1, 5, -1, 4]
			print (r)
			t.printout
		end

	test_insert_before_with_2_cursors
		do
			print (r + "test di insert_before (versione con 2 cursori che scorrono la lista)" + r)
			create t
			print ("inseriment in lista vuota: 4 prima di 7")
			t.insert_before_with_2_cursors(4,7)
			-- [4]
			print (r + "inserimento quando target e' primo elemento: 5 prima di 4")
			t.insert_before_with_2_cursors(5,4)
			-- [5, 4]
			print (r + "inserimento con target esistente non primo elemento: -1 prima di 4")
			t.insert_before_with_2_cursors(-1,4)
			-- [5, -1, 4]
			print (r + "inserimento con target non esistente: -1 prima di 7")
			t.insert_before_with_2_cursors(-1,7)
			-- [-1, 5, -1, 4]
			print (r)
			t.printout
		end

	test_value_follows
			-- require has(target)
		do
			print (r + "test di value_follows" + r)
			create t
			print (t.value_follows (1,0).out + r)
			print ("t vuota, appendo 5")
			t.append(5)
			-- [5]
			print (r + "poi prependo 4")
			t.prepend(4)
			-- [4, 5]
			print (r + "poi appendo 7")
			t.append(7)
			-- [4, 5, 7]
			print (r + "t = ")
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
			print ("t vuota, appendo 5")
			t.append(5)
			-- [5]
			print (r + "poi prependo 4")
			t.prepend(4)
			-- [4, 5]
			print (r + "poi appendo 7")
			t.append(7)
			-- [4, 5, 7]
			print (r + "t = ")
			t.printout
			print ("4 precede 5 ")
			print (t.value_precedes (4,5).out + r)
			print ("4 precede 7? ")
			print (t.value_precedes (4,7).out + r)
			print ("5 precede 7? ")
			print (t.value_precedes (5,7).out + r)
			print ("5 precede 4 ")
			print (t.value_precedes (5,4).out + r)
			print ("7 precede 4? ")
			print (t.value_precedes (7,4).out + r)
			print ("7 precede 5? ")
			print (t.value_precedes (7,5).out + r)
		end

	test_value_precedes_using_start_forth
			-- require has(target)
		do
			print (r + "test di value_precedes_using_start_forth" + r)
			create t
			print ("t vuota, appendo 5")
			t.append(5)
			-- [5]
			print (r + "poi prependo 4")
			t.prepend(4)
			-- [4, 5]
			print (r + "poi appendo 7")
			t.append(7)
			-- [4, 5, 7]
			print (r + "t = ")
			t.printout
			print ("4 precede 5 ")
			print (t.value_precedes_using_start_forth (4,5).out + r)
			print ("4 precede 7? ")
			print (t.value_precedes_using_start_forth (4,7).out + r)
			print ("5 precede 7? ")
			print (t.value_precedes_using_start_forth (5,7).out + r)
			print ("5 precede 4 ")
			print (t.value_precedes_using_start_forth (5,4).out + r)
			print ("7 precede 4? ")
			print (t.value_precedes_using_start_forth (7,4).out + r)
			print ("7 precede 5? ")
			print (t.value_precedes_using_start_forth (7,5).out + r)
		end

	test_index_of
		do
			print (r + "test di index_of" + r)
			create t
			print ("t vuota, appendo 5")
			t.append(5)
			-- [5]
			print (r + "poi prependo 4")
			t.prepend(4)
			-- [4, 5]
			print (r + "poi appendo 7")
			t.append(7)
			-- [4, 5, 7]
			print (r + "t = ")
			t.printout
			print ("4 e' in posizione: ")
			print (t.index_of (4).out + r)
			print ("5 e' in posizione: ")
			print (t.index_of (5).out + r)
			print ("7 e' in posizione: ")
			print (t.index_of (7).out + r)
		end

feature -- Inizialization
	make
			-- Run application.
		do
				--| Add your code here
			print ("Hello Eiffel World!" + r)
			print ("Attempt to print VOID ->")
			print (Void)
			print ("<- End attempt to print VOID" + r)
			test_append
			test_prepend
			test_has
			test_has_CON_ACTIVE
			test_get_element
			test_insert_after
			test_insert_after_reusing
			test_insert_before
			test_insert_before_with_2_cursors
			test_value_follows
			test_value_precedes
			test_value_precedes_using_start_forth
			test_index_of
		end



end
