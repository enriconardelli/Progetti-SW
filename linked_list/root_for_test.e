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
			print ("%N Creo la lista: ")
			create t
--			create {INT_LINKED_LIST} t
--			t := create{INT_LINKED_LIST}
			print ("%N -- RISULTATO: "); t.stampa; print("%N")
			print ("%N Inverto la lista: ")
			t.invert
			print ("%N -- RISULTATO: "); t.stampa; print("%N")

			print ("%N chiedo se 5 e' nella lista: ")
			if t.has (5) then
				print("%N ERRORE: la lista e' vuota ma 'has' ritorna vero %N")
			else
				print("%N OK: la lista e' vuota e 'has' ritorna falso %N")
			end

			print("%N invoco insert_multiple 5 before 8 su lista vuota:")
			t.insert_multiple_before (5, 8)
			print ("%N -- RISULTATO: "); t.stampa; print("%N")

			print("%N=== sulla lista: "); t.stampa
			print("%N invoco remove_first 5:")
			t.remove_first (5)
			print ("%N -- RISULTATO: "); t.stampa; print("%N")
			print("%N invoco insert_multiple 5 before 5")
			t.insert_multiple_before (5, 5)
			print ("%N -- RISULTATO: "); t.stampa; print("%N")

			print("%N=== sulla lista: "); t.stampa
			print("%N invoco active_element")
			print ("%N -- active_element = "); print(t.active_element.value)
			print("%N invoco insert_multiple 5 before 5")
			t.insert_multiple_before (5, 5)
			print ("%N -- RISULTATO: "); t.stampa; print("%N")

			print("%N=== sulla lista: "); t.stampa
			print("%N invoco insert_multiple 8 before 5:")
			t.insert_multiple_before (8, 5)
			print ("%N -- RISULTATO: "); t.stampa; print("%N")

			print("%N=== sulla lista: "); t.stampa
			print("%N invoco active_element")
			print ("%N -- active_element = "); print(t.active_element.value)
			print("%N invoco remove_first 8:")
			t.remove_first (8)
			print ("%N -- RISULTATO: "); t.stampa; print("%N")

			print("%N=== sulla lista: "); t.stampa
			print("%N invoco active_element")
			print ("%N -- active_element = "); print(t.active_element.value)
			print("%N invoco remove_first 8:")
			t.remove_first (8)
			print ("%N -- RISULTATO: "); t.stampa; print("%N")
			print("%N invoco active_element")
			print ("%N -- active_element = "); print(t.active_element.value)

			print("%N=== sulla lista: "); t.stampa
			print("%N invoco insert_multiple 8 before 8:")
			t.insert_multiple_before (8, 8)
			print ("%N -- RISULTATO: "); t.stampa; print("%N")

			print("%N=== sulla lista: "); t.stampa
			print("%N invoco first")
			t.start
			print("%N invoco active_element")
			print ("%N -- active_element = "); print(t.active_element.value)

			print("%N=== sulla lista: "); t.stampa
			print("%N invoco insert_multiple 15 before 8:")
			t.insert_multiple_before (15, 8)
			print ("%N -- RISULTATO: "); t.stampa; print("%N")

			print("%N=== sulla lista: "); t.stampa
			print("%N invoco last")
			t.last
			print("%N invoco active_element")
			print ("%N -- active_element = "); print(t.active_element.value)
			print("%N invoco removo_active")
			t.remove_active
			print("%N invoco active_element")
			print ("%N -- active_element = "); print(t.active_element.value)

			print("%N=== sulla lista: "); t.stampa
			print("%N invoco insert_multiple 3 before 5:")
			t.insert_multiple_before (3, 5)
			print ("%N -- RISULTATO: "); t.stampa; print("%N")

			print("%N=== sulla lista: "); t.stampa
			print("%N invoco active_element")
			print ("%N -- active_element = "); print(t.active_element.value)

			print("%N=== sulla lista: "); t.stampa
			print ("%N Inverto la lista: ")
			t.invert
			print ("%N -- RISULTATO: "); t.stampa; print("%N")

			print("%N=== sulla lista: "); t.stampa
			print("%N invoco removo_active")
			t.remove_active
			print("%N invoco active_element")
			print ("%N -- active_element = "); print(t.active_element.value)
			print("%N invoco removo_active")
			t.remove_active
			print("%N invoco active_element")
			print ("%N -- active_element = "); print(t.active_element.value)

			print("%N=== sulla lista: "); t.stampa
			print("%N invoco insert_multiple 7 before 9:")
			t.insert_multiple_before (7, 9)
			print ("%N -- RISULTATO: "); t.stampa; print("%N")

			print("%N=== sulla lista: "); t.stampa
			print("%N invoco active_element")
			print ("%N -- active_element = "); print(t.active_element.value)

			print("%N=== sulla lista: "); t.stampa
			print("%N invoco remove_active")
			t.remove_active
			print ("%N -- RISULTATO: "); t.stampa; print("%N")

			print("%N=== sulla lista: "); t.stampa
			print("%N invoco active_element")
			print ("%N -- active_element = "); print(t.active_element.value)

			print("%N=== sulla lista: "); t.stampa
			print("%N invoco forth")
			t.forth
			print ("%N -- active_element = "); print(t.active_element.value)

			print("%N=== sulla lista: "); t.stampa
			print("%N invoco remove_active")
			t.remove_active
			print ("%N -- RISULTATO: "); t.stampa; print("%N")

			print("%N=== sulla lista: "); t.stampa
			print("%N invoco active_element")
			print ("%N -- active_element = "); print(t.active_element.value)

			print("%N=== sulla lista: "); t.stampa
			print("%N cancello la lista")
			t.wipeout
			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N invoco get_element 3 su lista vuota: ")
--			target := t.get_element (3)
--			if target = Void then
--				print (False)
--			else
--				print (True)
--				print ("%N ERRORE ! ")
--			end
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N Chiedo se 15 segue -5 nella lista vuota: ")
--			if t.value_follows (15, -5) then
--				print (True)
--				print ("%N ERRORE ! ")
--			else
--				print (False)
--			end
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

----			per testare sia questo che il successivo devo implementare REMOVE
----			print ("%N invoco insert -5 after 3 su lista vuota")
----			t.insert_after (-5, 3)
----			t.stampa

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N invoco insert -5 before 3 su lista vuota")
--			t.insert_before (-5, 3)
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N invoco get_element 3: ")
--			target := t.get_element (3)
--			if target = Void then
--				print (False)
--			else
--				print (True)
--				print ("%N ERRORE ! ")
--			end
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N Chiedo se 15 segue -5: ")
--			if t.value_follows (15, -5) then
--				print (True)
--				print ("%N ERRORE ! ")
--			else
--				print (False)
--			end
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N Chiedo se 15 segue 456: ")
--			if t.value_follows (15, 456) then
--				print (True)
--				print ("%N ERRORE ! ")
--			else
--				print (False)
--			end
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N estendo in coda con 7777")
--			t.append (7777)
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N invoco get_element 3: ")
--			target := t.get_element (3)
--			if target = Void then
--				print (False)
--			else
--				print (True)
--				print ("%N ERRORE ! ")
--			end
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N estendo in testa con 77")
--			t.prepend (77)
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N Inverto la lista: ")
--			t.invert
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N invoco insert 15 before 10")
--			t.insert_before (15, 10)
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N invoco insert 25 before 15")
--			t.insert_before (25, 15)
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N invoco insert 9 before 77")
--			t.insert_before (9, 77)
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N estendo in coda con 5555")
--			t.append (5555)
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print ("%N estendo in testa con 55")
--			t.prepend (55)
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N Inverto la lista: ")
--			t.invert
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N invoco insert 9 before 5555")
--			t.insert_before (9, 5555)
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N estendo con -3 e con 1")
--			t.append (-3)
--			t.append (1)
--			print ("%N Lista creata.")
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N La lista contiene 55? ")
--			print (t.has (55))
--			print ("%N La lista contiene 6? ")
--			print (t.has (6))
--			print ("%N Cerco 4 nella lista ed il risultato e': ")
--			target := t.get_element (4)
--			if target = Void then
--				print (False)
--			else
--				print (True)
--			end
--			print ("%N estendo con 4")
--			t.append (4)
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N Cerco 4 nella lista ed il risultato e': ")
--			target := t.get_element (4)
--			if target = Void then
--				print (False)
--			else
--				print (True)
--				print ("%N il valore nell'elemento ritrovato e': ")
--				print (target.value)
--			end

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N La somma dei valori positivi e': ")
--			print (t.sum_of_positive)
--			print ("%N Inserisco -6 dopo 77 ")
--			t.insert_after (-6, 77)
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N Inserisco -9 dopo 9")
--			t.insert_after (-9, 9)
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N La somma dei valori positivi e': ")
--			print (t.sum_of_positive)
--			print ("%N Inserisco 8 dopo 4")
--			t.insert_after (8, 4)
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N Inserisco 88 dopo 9")
--			t.insert_after (88, 9)
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N Chiedo se 15 segue 55 nella lista ed il risultato e': ")
--			if t.value_follows (15, 55) then
--				print (True)
--			else
--				print (False)
--			end
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N Chiedo se 15 segue 66 nella lista ed il risultato e': ")
--			if t.value_follows (15, 66) then
--				print (True)
--			else
--				print (False)
--			end
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N Chiedo se 55 segue 15 nella lista ed il risultato e': ")
--			if t.value_follows (55, 15) then
--				print (True)
--			else
--				print (False)
--			end
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

--			print("%N=== sulla lista: "); t.stampa
--			print ("%N La somma dei valori positivi e': ")
--			print (t.sum_of_positive)
--			print ("%N Inverto la lista: ")
--			t.invert
--			print ("%N Stampo la lista invertita: ")
--			print ("%N -- RISULTATO: "); t.stampa; print("%N")

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
