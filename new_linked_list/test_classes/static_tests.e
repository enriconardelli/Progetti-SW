note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	STATIC_TESTS

inherit

	EQA_TEST_SET

feature -- Spostamento del cursore

	t_first
			-- Claudia Agulini, 2020/03/06
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (1)
			t.append (3)
			t.append (5)
			t.start
			if attached t.active_element as ae and attached t.first_element as fe then
				assert ("t contiene 1,3,5, active � 1?", ae.value = fe.value)
			end
		end

	t_last
			-- Arianna Calzuola, 2020/03/10
		local
			t: INT_LINKED_LIST
		do
			create t
			t.last
			assert ("errore: la lista � vuota, ma l'elemento attivo non e' vuoto", t.active_element = void)
			t.append (3)
			t.last
			assert ("errore: la lista ha un unico elemento, ma l'elemento attivo non e' il primo", t.active_element /= t.first_element)
			assert ("errore: la lista ha un unico elemento, ma l'elemento attivo non e' l'ultimo", t.active_element = t.last_element)
			if attached t.active_element as ae then
				assert ("errore: la lista ha un unico elemento, ma l'elemento attivo non e' quello inserito", ae.value = 3)
			end
			t.append (2)
			t.append (7)
				--[3, 2, 7]
			t.last
			if attached t.active_element as ae then
				assert ("errore: active element non sta puntando all'ultimo elemento della lista", ae.value = 7)
			end
			assert ("errore: il valore di active element non � il valore dell'ultimo elemento della lista", t.active_element = t.last_element)
		end

	t_forth
			-- Alessandro Filippo 2020/03/08
		local
			t: INT_LINKED_LIST
		do
			create t
			assert ("la lista � vuota, active element � void", t.active_element = Void)
			t.append (3)
			t.forth
			assert ("l'active element � 3 ed � il last element , dopo forth � Void?", t.active_element = Void)
			t.append (4)
			t.start
			t.forth
			assert ("l'active element � 3 , dopo forth � 4", attached t.active_element as ta implies ta.value = 4)
		end

feature -- Remove single targeted: classi di test separate

feature -- da continuare

	t_value_after
			-- Enrico Nardelli, 2021/03/23
		local
			t: INT_LINKED_LIST
		do
			create t
			assert ("t e' vuota, ma t contiene 3 subito dopo 5", not t.value_after (3, 5))
			t.append (5)
			assert ("t contiene solo 5, ma contiene 3 subito dopo 5", not t.value_after (3, 5))
			t.wipeout
			t.append (4)
			assert ("t contiene solo 4, ma contiene 3 subito dopo 5", not t.value_after (3, 5))
			t.wipeout
			t.append (5) ; t.append (3)
			assert ("t vale [5, 3]', ma non trova 3 subito dopo 5", t.value_after (3, 5))
			t.wipeout
			t.append (5) ; t.append (4)
			assert ("t vale [5, 4]', ma contiene 3 subito dopo 5", not t.value_after (3, 5))
			t.wipeout
			t.append (3) ; t.append (5)
			assert ("t vale [3, 5]', ma contiene 3 subito dopo 5", not t.value_after (3, 5))
			t.wipeout
			t.append (3) ; t.append (4)
			assert ("t vale [3, 4]', ma contiene 3 subito dopo 5", not t.value_after (3, 5))
			t.wipeout
			t.append (5) ; t.append (4) ; t.append (3)
			assert ("t vale [5, 4, 3]', ma contiene 3 subito dopo 5", not t.value_after (3, 5))
			t.wipeout
			t.append (4) ; t.append (5) ; t.append (3)
			assert ("t vale [4, 5, 3]', ma non trova 3 subito dopo 5", t.value_after (3, 5))
		end

	t_has
			-- Enrico Nardelli, 2020/03/06
		local
			t: INT_LINKED_LIST
		do
			create t
			assert ("t e' vuota, t contiene 3?", not t.has (3))
			t.append (3)
			assert ("t contiene 3, t contiene 3?", t.has (3))
			assert ("t contiene 3, t contiene 4?", not t.has (4))
			t.append (7)
			assert ("t contiene 3 e 7, t contiene 3? ", t.has (3))
			assert ("t contiene 3 e 7, t contiene 4? ", not t.has (4))
			assert ("t contiene 3 e 7, t contiene 7? ", t.has (7))
		end

	t_append
			-- Enrico Nardelli, 2020/03/06
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (3)
			assert ("ERRORE: ho fatto append di 3, ma t non contiene 3", t.has (3))
			assert ("ERRORE: ho fatto append solo di 3, ma t contiene 4", not t.has (4))
		end

	t_prepend
			-- Enrico Nardelli, 2021/03/02
		local
			t: INT_LINKED_LIST
		do
			create t
			t.prepend (3)
			assert ("ERRORE: ho fatto prepend di 3, ma t non contiene 3?", t.has (3))
			assert ("ERRORE: ho fatto prepend solo di 3, ma t contiene 4", not t.has (4))
		end

	t_insert_after
			-- Alessandro Filippo, 2020/03/06
		local
			t: INT_LINKED_LIST
		do
			create t
			t.insert_after (5, 6)
			assert ("t � vuota, t ha inserito 5 dopo 6 anche se non c'�?", t.has (5))
			t.append (-4)
			t.insert_after (7, -4)
			assert ("t contiene -4, ho inserito 7 dopo 4?", t.has (7))
		end

	t_get_element
			-- Riccardo Malandruccolo, 2020/03/06
		local
			t: INT_LINKED_LIST
		do
			create t
			assert ("errore: restituisce elemento che non esiste", t.get_element (3) = void)
			t.append (3)
			assert ("errore: non restituisce elemento che esiste", t.get_element (3) /= void)
			assert ("errore: non restituisce il valore corretto", attached t.get_element (3) as el implies el.value = 3)
			assert ("errore: restituisce elementi che non esistono", t.get_element (4) = void)
			t.append (7)
			assert ("errore: non restituisce elemento che esiste", t.get_element (3) /= void)
			assert ("errore: restituisce elemento che non esiste", t.get_element (4) = void)
			assert ("errore: non restituisce elemento che esiste", t.get_element (7) /= void)
			assert ("errore: restituisce valore sbagliato di elemento che esiste", attached t.get_element (3) as el implies el.value = 3)
			assert ("errore: restituisce valore sbagliato di elemento che esiste", attached t.get_element (7) as el implies el.value = 7)
		end

	t_insert_after_reusing
			-- Federico Fiorini, 2020/03/06
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (5)
			t.append (7)
			t.append (2)
			t.insert_after_reusing (1, 0)
			assert ("t contiene 4 elementi?", t.count = 4)
			if attached t.last_element as le then
				assert ("t non contiene il valore 0, il valore 1 � stato inserito alla fine della lista?", le.value = 1)
			end
		end

	t_insert_multiple_before
			-- Riccardo Malandruccolo, 2020/03/07
		local
			t: INT_LINKED_LIST
		do
			create t
			t.insert_multiple_before (3, 10)
				-- [3]
			assert ("errore: su lista vuota non aggiunge il valore", t.has (3))
			assert ("errore: su lista vuota l'elemento aggiunto non � first_element", attached t.first_element as fe implies fe.value = 3)
			assert ("errore: su lista vuota l'elemento aggiunto non � last_element", attached t.last_element as le implies le.value = 3)
			assert ("errore: su lista vuota l'elemento aggiunto non � active_element", attached t.active_element as ae implies ae.value = 3)
			t.append (2)
			t.append (1)
			t.append (3)
				-- [3,2,1,3]

			t.insert_multiple_before (5, 3)
				-- [5,3,2,1,5,3]
			assert ("errore: non aggiunge il valore", t.has (5))
			assert ("errore: se inserisce il valore all'inizio, il first_element non cambia", attached t.first_element as fe implies fe.value = 5)
			assert ("errore: non aggiunge il valore prima del target", attached t.get_element (5) as el and then attached el.next as eln implies eln.value = 3)
			assert ("errore: non aggiunge il valore pi� volte", t.count = 6)
			t.insert_multiple_before (4, 7)
				-- [4,5,3,2,1,5,3]
			assert ("errore: il valore non viene aggiunto se non trovo il target", t.has (4))
			assert ("errore: il valore non viene aggiunto una volta se non trovo il target", t.count = 7)
			assert ("errore: il valore non viene aggiunto all'inizio se non trovo il target", attached t.first_element as fe implies fe.value = 4)
		end

	t_remove_active
			-- Riccardo Malandruccolo, 2020/03/07
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (1)
			t.append (2)
			t.append (3)
				-- [1,2,3]
				-- t.active_element = 1
			t.start
			t.remove_active
				-- [2,3]
				-- t.active_element = 2
			assert ("errore: non ha eliminato l'active_element", not t.has (1))
			assert ("errore: non ha eliminato esattamente un elemento", t.count = 2)
			assert ("errore: non � stato modificato l'active_element correttamente", attached t.active_element as ae implies ae.value = 2)
			assert ("errore: non � stato modificato il first_element correttamente", attached t.first_element as fe implies fe.value = 2)
			t.forth
				-- t.active_element = 3
			t.remove_active
				-- [2]
				-- t.active_element = 2
			assert ("errore: non ha eliminato l'active_element", not t.has (3))
			assert ("errore: non � stato modificato l'active_element correttamente", attached t.active_element as ae implies ae.value = 2)
			assert ("errore: non � stato modificato il last_element correttamente", attached t.last_element as le implies le.value = 2)
			t.remove_active
				-- []
				-- t.active_element = Void
			assert ("errore: non ha eliminato l'active_element", not t.has (2))
			assert ("errore: non � stato modificato l'active_element correttamente", t.active_element = Void)
			assert ("errore: non � stato modificato il last_element correttamente", t.last_element = Void)

		end

	t_invert
			-- Federico Fiorini, 2020/03/08
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (1)
			t.append (2)
			t.append (3)
				-- [1,2,3]
			t.invert
				-- [3,2,1]
			assert ("errore: il numero di elementi della lista � cambiato", t.count = 3)
			t.start
				--t.active_element.value = 3
			if attached t.active_element as ae then
				assert ("invertita la lista [1,2,3], inizializzato active_element come primo elemento, active_element � 3?", ae.value = 3)
			end
			t.forth
				--t.active_element.value = 2
			if attached t.active_element as ae then
				assert ("avanzato active element, active_element � 2?", ae.value = 2)
			end
			t.forth
				--t.active_element.value = 1
			if attached t.active_element as ae then
				assert ("avanzato active element, active_element � 1?", ae.value = 1)
			end
		end

	t_sum_of_positive
			--Giulia Iezzi 2020/03/08
		local
			t: INT_LINKED_LIST
		do
			create t
			assert ("la lista � vuota, fa zero?", t.sum_of_positive = 0)
			t.append (1)
			t.append (2)
			t.append (-1)
			assert ("la lista contiene 1 ,2 e -1, fa 3?", t.sum_of_positive = 3)
		end

	t_wipeout
			-- Claudia Agulini, 2020/03/08
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (1)
			t.append (3)
			t.append (5)
				-- [1, 3, 5]
				-- t.count = 3
			t.wipeout
			assert ("errore: non ha eliminato first_element", t.first_element = Void)
			assert ("errore: non ha eliminato active_element", t.active_element = Void)
			assert ("errore: non ha eliminato last_element", t.last_element = Void)
			assert ("errore: non ha eliminato tutti gli elementi", t.count = 0)
		end

	t_lista_vuota
		-- Calzuola e Malandruccolo 2020/03/21
		local
			t_vuota: INT_LINKED_LIST
			a_value: INTEGER
		do
			create t_vuota
			a_value := 1
			assert("has trova il valore su lista vuota", not t_vuota.has(a_value))
			assert("get_element restituisce un elemento su lista vuota", t_vuota.get_element (a_value) = void)
			assert("la lista non � vuota", t_vuota.count = 0)
		end

	t_lista_un_elemento
		-- Calzuola e Malandruccolo 2020/03/21
		local
			t_one_element: INT_LINKED_LIST
			a_value: INTEGER
			a_different: INTEGER
		do
			a_value:= 7
			a_different:= 9
			create t_one_element
			t_one_element.append (a_value)
			assert("non ho aggiunto il valore corretto", t_one_element.has(a_value) and not t_one_element.has(a_different))
			assert("non ho una lista con un elemento", t_one_element.count = 1)
			assert("first_element diverso da last_element", t_one_element.first_element = t_one_element.last_element)
			assert("first_element diverso da a_value", attached t_one_element.first_element as fe and then fe.value = a_value)
			assert("last_element diverso da a_value", attached t_one_element.last_element as le and then le.value = a_value)
			assert("restituisce un void ma dovrebbe restituire a_value", t_one_element.get_element(a_value) /= void)
			assert("non restituisce a_value", attached t_one_element.get_element(a_value) as ge and then ge.value = a_value)
			assert("ho un valore che non dovrei avere", t_one_element.get_element(a_different) = void)
		end

	t_lista_due_elementi
		-- Calzuola e Malandruccolo 2020/03/21
		local
			t_due: INT_LINKED_LIST
			a_value : INTEGER
		do
			create t_due
			a_value := 1
			t_due.append(a_value)
			t_due.append (2*a_value)
			assert("has non trova il valore", t_due.has (a_value))
			assert("get_element non trova l'elemento", t_due.get_element (a_value) /= void)
			assert("la lista non ha due elementi", t_due.count = 2)
			assert("il first_element non � impostato correttamente", attached t_due.first_element as fe and then fe.value = a_value)
			assert("il last_element non � impostato correttamente", attached t_due.last_element as le and then le.value = 2*a_value)
		end

feature -- Convenienza

	how_many (t: INT_LINKED_LIST; a_value: INTEGER): INTEGER
		-- return how many times `a_value' occurs in `t'
	local
		current_element: INT_LINKABLE
	do
		if t.count=0 then
			Result := 0
		else
			from current_element := t.first_element
			until current_element = Void
			loop
				if current_element.value = a_value then
					Result := Result + 1
				end
				current_element := current_element.next
			end
		end
	end



end
