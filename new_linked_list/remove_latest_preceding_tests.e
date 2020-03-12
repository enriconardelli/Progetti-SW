note
	description: "Summary description for {REMOVE_LATEST_PRECEDING_TESTS}."
	author: "Federico Fiorini"
	date: "$Date$"
	revision: "$Revision$"

class
	REMOVE_LATEST_PRECEDING_TESTS

inherit
	STATIC_TESTS


feature

	t_empty_list(a_value, target:INTEGER)

		local
			t: INT_LINKED_LIST
		do
			create t
			t.remove_latest_preceding (a_value, target)
			assert("Errore: cambiato numero di elementi di una lista vuota", t.count=0)
		end

	t_only_one_element(element, a_value, target:INTEGER)
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (element)
			t.remove_latest_preceding (a_value, target)
			assert("Errore: cambiato numero di elementi di una lista con un solo", t.count=1)
			assert("Errore: tolto un elemento, ma la lista aveva solo quello", not(t.count=0))
		end


	how_many (t: INT_LINKED_LIST; a_value: INTEGER): INTEGER
			--ci dice quante occorrenze di value ci sono nella lista
		local
			current_element: INT_LINKABLE
		do
			if t.count = 0 then
				Result := 0
			else
				from
					current_element := t.first_element
				until
					current_element = Void
				loop
					if current_element.value = a_value then
						Result := Result + 1
					end
					current_element := current_element.next
				end
			end
		end

	t_no_value(a_value:INTEGER)
		local
			t:INT_LINKED_LIST
			s:INTEGER
		do
			create t
			t.append (a_value+1)
			t.append (a_value+2)
			t.append (a_value+3)
			s:=how_many(t,a_value)
			t.remove_latest_preceding(a_value,a_value)
			assert("errore: la lista non conteneva a_value, ma è stato rimosso qualche elemento", s=how_many(t,a_value))
		end
	t_no_target(a_value, target:INTEGER)
		local
			t:INT_LINKED_LIST
			s:INTEGER
		do
			create t
			t.append (a_value)
			t.append (target+1)
			t.append (target+2)
			t.append (target+3)
			s:=how_many(t,a_value)
			t.remove_latest_preceding (a_value, target)
			assert("errore: la lista conteneva a_value ma non target, il numero degli a_value è cambiato", s=how_many(t,a_value))
		end

	t_single_value_first(a_value:INTEGER)
		local
			t: INT_LINKED_LIST
			s: INTEGER
		do
			create t
			t.append (a_value)
			t.append (a_value+1)
			t.append (a_value+2)
			t.append (a_value-1)
			t.append (a_value)
			s:=how_many(t,a_value)
			t.remove_latest_preceding(a_value,a_value-1)
			assert("errore: gli elementi non sono stati rimossi correttamente",s=how_many(t,a_value)+1)
			assert("errore: il primo elemento è ancora a_value", attached t.first_element as fe implies fe.value/=a_value)
			assert("errore: è stato rimosso un elemento dopo target", attached t.last_element as le implies le.value = a_value)
		end

	t_single_value_middle(a_value:INTEGER)
		local
			t: INT_LINKED_LIST
			s: INTEGER
		do
			create t
			t.append (a_value+2)
			t.append (a_value)
			t.append (a_value+1)
			t.append (a_value-1)
			t.append (a_value)
			s:=how_many(t,a_value)
			t.remove_latest_preceding(a_value,a_value-1)
			assert("errore: gli elementi non sono stati rimossi correttamente",s=how_many(t,a_value)+1)
			assert("errore: è stato rimosso un elemento dopo target", attached t.last_element as le implies le.value = a_value)
		end

	t_multiple_value(a_value:INTEGER)
		local
			t: INT_LINKED_LIST
			s: INTEGER
		do
			create t
			t.append (a_value)
			t.append (a_value+2)
			t.append (a_value)
			t.append (a_value+1)
			t.append (a_value-1)
			t.append (a_value)
			t.append (a_value-1)
			t.append (a_value)
			s:=how_many(t,a_value)
			t.remove_latest_preceding(a_value,a_value-1)
			assert("errore: gli elementi non sono stati rimossi correttamente",s=how_many(t,a_value)+1)
			assert("errore: è stato rimosso un elemento dopo target", attached t.last_element as le implies le.value = a_value)
			t.remove_latest_preceding(a_value,a_value-1)
			assert("errore: gli elementi non sono stati rimossi correttamente",s=how_many(t,a_value)+2)
			assert("errore: il primo elemento è ancora a_value", attached t.first_element as fe implies fe.value/=a_value)
			assert("errore: è stato rimosso un elemento dopo target", attached t.last_element as le implies le.value = a_value)
			t.remove_latest_preceding(a_value,a_value-1)
			assert("errore: è stato rimosso qualche a_value, ma non dovrebbero essercene più",s=how_many(t,a_value)+2)
			assert("errore: il primo elemento è ancora a_value", attached t.first_element as fe implies fe.value/=a_value)
			assert("errore: è stato rimosso un elemento dopo target", attached t.last_element as le implies le.value = a_value)
		end



	t_remove_latest_preceding
		local
			t: INT_LINKED_LIST
		do
			create t
			t_empty_list(1,1)
			t_only_one_element(1,1,1)
			t_only_one_element(2,1,1)
		    t_no_value(1)
		    t_no_value(2)
			t_no_target(0,1)
			t_no_target(1,1)
			t_single_value_first (1)
			t_single_value_middle (1)
			t_multiple_value(3)


		end





end
