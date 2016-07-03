note
	description : "root class for INT_LINKED_LIST"
	date        : "$Date$"
	revision    : "$Revision$"

class
	ROOT_FOR_TEST

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			tr, t: detachable INT_LINKED_LIST
			target: detachable INT_LINKABLE
		do
			create t
--			create {INT_LINKED_LIST} t
--			t := create{INT_LINKED_LIST}
			t.stampa
			print ("%N Inverto la lista: ")
			t.invert
			t.stampa

			print ("%N chiedo se 5 e' nella lista: ")
			if t.has (5) then
				print("%N ERRORE: la lista e' vuota ma 'has' ritorna vero ")
			end

--			print ("%N invoco insert -5 after 3 su lista vuota")
--			t.insert_after (-5, 3)
--			t.stampa

			print ("%N invoco insert -5 before 3 su lista vuota")
			t.insert_before (-5, 3)
			t.stampa

			print ("%N estendo in coda con 7777")
			t.append (7777)
			t.stampa

			print ("%N estendo in testa con 77")
			t.prepend (77)
			t.stampa

			print ("%N Inverto la lista: ")
			t.invert
			t.stampa

			print ("%N invoco insert 15 before 10 che non c'e'")
			t.insert_before (15, 10)
			t.stampa

			print ("%N invoco insert 25 before 15 che e' il primo")
			t.insert_before (25, 15)
			t.stampa

			print ("%N invoco insert 9 before 77 che sta alla fine")
			t.insert_before (9, 77)
			t.stampa

			print ("%N estendo in coda con 5555")
			t.append (5555)
			t.stampa

			print ("%N estendo in testa con 55")
			t.prepend (55)
			t.stampa

			print ("%N Inverto la lista: ")
			t.invert
			t.stampa

			print ("%N invoco insert 9 before 5555 che sta all'inizio")
			t.insert_before (9, 5555)
			t.stampa

			print ("%N estendo con -3 e con 1")
			t.append (-3)
			t.append (1)
			print ("%N Lista creata.")
			t.stampa

			print ("%N La lista contiene 55? ")
			print (t.has (55))
			print ("%N La lista contiene 6? ")
			print (t.has (6))
			print ("%N Cerco 4 nella lista ed il risultato e': ")
			target := t.get_element (4)
			if target = Void then
				print (False)
			else
				print (True)
			end
			print ("%N estendo con 4")
			t.append (4)
			t.stampa

			print ("%N Cerco 4 nella lista ed il risultato e': ")
			target := t.get_element (4)
			if target = Void then
				print (False)
			else
				print (True)
				print ("%N il valore nell'elemento ritrovato e': ")
				print (target.value)
			end

			print ("%N La somma dei valori positivi e': ")
			print (t.sum_of_positive)
			print ("%N Inserisco -6 dopo 77 ")
			t.insert_after (-6, 77)
			t.stampa

			print ("%N Inserisco -9 dopo 9")
			t.insert_after (-9, 9)
			t.stampa

			print ("%N La somma dei valori positivi e': ")
			print (t.sum_of_positive)
			print ("%N Inserisco 8 dopo 4 che sta alla fine")
			t.insert_after (8, 4)
			t.stampa

			print ("%N Inserisco 88 dopo 9 che sta all'inizio")
			t.insert_after (88, 9)
			t.stampa

			print ("%N La somma dei valori positivi e': ")
			print (t.sum_of_positive)
			print ("%N Inverto la lista: ")
			t.invert
			print ("%N Stampo la lista invertita: ")
			t.stampa
				--			t.store_by_name ("prova.txt")
				--			print ("%N Adesso stampo la lista s letta da file: ")
				--			if attached {INT_LINKED_LIST} tr.retrieve_by_name ("prova.txt") as ss then
				--				ss.stampa
				--			end
--			print ("%N Creo tr come twin di t: ")
--			tr := t.twin
--			tr.stampa
--			print ("%N Testo la VALUE equality ")
--			if t = tr then
--				print ("%N t uguale tr (perche tr creato per clonazione di t)")
--			else
--				print ("%N t DIVERSO tr (perche' il primo elemento di tr e' un nuovo oggetto)")
--			end
--			print ("%N Testo la OBJECT equality ")
--			if t ~ tr then
--				print ("%N t uguale tr (perche tr creato per clonazione di t)")
--			else
--				print ("%N t DIVERSO tr (perche' il primo elemento di tr e' un nuovo oggetto)")
--			end
		end

end
