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
			print("ciao")
			print (r + "test di has" + r)
			create t
			print ("t e' vuota, t contiene 3? ")
			print (t.has (3))
			print (r)
			t.append (3)
			print ("t contiene 3, t contiene 3? ")
			print (t.has (3))
			print (r)
			print ("t contiene 3, t contiene 4? ")
			print (t.has (4))
			print (r)
			t.append (7)
			print ("t contiene 3 e 7, t contiene 3? ")
			print (t.has (3))
			print (r)
			print ("t contiene 3 e 7, t contiene 4? ")
			print (t.has (4))
			print (r)
			print ("t contiene 3 e 7, t contiene 7? ")
			print (t.has (7))
			print (r)
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

	test_get_element
		do
			print (r + "test di get_element" + r)
			create t
			print ("t e' vuota, t restituisce 3?" + r)
			print (t.get_element (3))
			print (r)
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
			print (r)
			print ("inserisco 5 dopo 7")
			t.insert_after(5,7)
			print (r)
			print ("inserisco -1 dopo 4")
			t.insert_after(-1,4)
			print (r)
			t.printout
		end

	test_insert_after_reusing
		do
			print (r + "test di insert_after_reusing" + r)
			create t
			print ("t vuota, inserisco 4 dopo 7")
			t.insert_after_reusing(4,7)
			print (r)
			print ("inserisco 5 dopo 7")
			t.insert_after_reusing(5,7)
			print (r)
			print ("inserisco -1 dopo 4")
			t.insert_after_reusing(-1,4)
			print (r)
			t.printout
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
			test_has
			test_get_element
			test_insert_after
			test_insert_after_reusing
		end



end
