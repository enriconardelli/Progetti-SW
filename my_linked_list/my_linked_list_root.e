note
	description: "MY_LINKED_LIST application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	MY_LINKED_LIST_ROOT

inherit

	ARGUMENTS

create
	make

feature

	make

			-- Run application.
		local
			t: detachable MY_LINKED_LIST [INTEGER]
			target: detachable MY_LINKABLE [INTEGER]
		do
			create t
			t.stampa
			print ("%N chiedo se 5 e' nella lista: ")
			if t.has (5) then
				print ("%N ERRORE: la lista e' vuota ma 'has' ritorna vero ")
			elseif not t.has (5) then
				print ("has ritorna falso correttamente")
			end
			print ("%N invoco insert -5 before 3 su lista vuota")
			t.insert_before (-5, 3)
			t.stampa
			print ("%N estendo con 7")
			t.append (7)
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
			print ("%N invoco insert 9 before -5 che sta alla fine")
			t.insert_before (9, -5)
			t.stampa
			print ("%N estendo con 5")
			t.append (5)
			t.stampa
			print ("%N Inverto la lista: ")
			t.invert
			t.stampa
			print ("%N invoco insert 9 before 15")
			t.insert_before (9, 5)
			t.stampa
			print ("%N estendo con 9 e con -1")
			t.append (9)
			t.append (-1)
			print ("%N Lista creata.")
			t.stampa
			print ("%N La lista contiene 5? ")
			print (t.has (5))
			print ("%N La lista contiene 6? ")
			print (t.has (6))
			print ("%N Cerco 4 nella lista ed il risultato e': ")
			target := t.get_element (4)
			if target = Void then
				print (False)
			else
				print (True)
			end
			print ("%N estendo con 4 n")
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
			print ("%N Inserisco 9 dopo -1 ")
			t.insert_after (9, -1)
			t.stampa
			print ("%N Inserisco 5 dopo 9")
			t.insert_after (5, 9)
			t.stampa
			t.invert
			print ("%N Stampo la lista invertita: ")
			t.stampa
			print ("%N inserisco 1 dopo di ogni 9 ")
			t.insert_multiple_after (1, 9)
			t.stampa
			print ("%N inserisco -1 prima di ogni 1 ")
			t.insert_multiple_before (-1, 1)
			t.stampa
			print ("%N rimuovo 15 dalla lista che si trova in mezzo")
			t.remove (15)
			t.stampa
			print ("%N rimuovo 4 dalla lista che si trova all'inizio")
			t.remove (4)
			t.stampa
			print ("%N rimuovo -1 dalla lista che si trova in mezzo ed ha altri valori uguali che lo seguono")
			t.remove (-1)
			t.stampa
			print ("%N estendo con 88")
			t.append (88)
			t.stampa
			print ("%N rimuovo 88 dalla lista che si trova alla fine")
			t.remove (88)
			t.stampa
			print ("%N pulisco la lista ")
			t.wipeout
			t.stampa
		end

end
