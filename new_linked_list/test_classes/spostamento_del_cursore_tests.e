note
	description: "Test per le feature di tipo Manipulation"
	author: "Gianluca Pastorini"
	date: "$03/04/23"
	revision: "$Revision$"

class
	SPOSTAMENTO_DE_CURSORE_TESTS

inherit

	STATIC_TESTS

feature --first
	-- Claudia Agulini, 2020/03/06

	t_first_one_element (a_value: INTEGER)
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.start
			if attached t.active_element as ae and attached t.first_element as fe then
				assert ("l'unico elemento della lista non è considerato come primo", ae.value = fe.value)
			end
			assert ("il primo elemento risulta vuoto", t.first_element = void)
		end

	t_first_multiple_element (a_value: INTEGER)
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value - 3)
			t.append (a_value - 2)
			t.start
			if attached t.active_element as ae and attached t.first_element as fe then
				assert ("il primo elemto della lista risulta sbagliato", ae.value = fe.value)
			end
			assert ("il primo elemento risulta vuoto", t.first_element = void)
		end

	t_first_void (a_value: INTEGER) -- inserisco comunque una variabile così il test lo esegue solo sotto, insieme agli altri
		local
			t: INT_LINKED_LIST
		do
			create t
			assert ("il primo elemento non risulta vuoto", t.first_element = void)
		end

		t_first
		do
			t_first_one_element (1)
			t_first_multiple_element (1)
			t_first_void (1)
		end

feature --last
	-- Arianna Calzuola, 2020/03/10

	t_last_one_element
		local
			t: INT_LINKED_LIST
		do
			create t
			t.last
			assert ("errore: la lista è vuota, ma l'elemento attivo non e' vuoto", t.active_element = void)
			t.append (3)
			t.last
			assert ("errore: la lista ha un unico elemento, ma l'elemento attivo non e' il primo", t.active_element = t.first_element)
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
			assert ("errore: il valore di active element non è il valore dell'ultimo elemento della lista", t.active_element = t.last_element)
		end

feature -- forth
	-- Alessandro Filippo 2020/03/08

	t_forth_to_void
		local
			t: INT_LINKED_LIST
		do
			create t
			assert ("la lista è vuota, active element è void", t.active_element = Void)
			t.append (3)
			if t.active_element /= Void then
				t.forth
			end
			assert ("l'active element è 3 ed è il last element , dopo forth è Void?", t.active_element = Void)
			t.append (4)
			t.start
			if t.active_element /= Void then
				t.forth
			end
			assert ("l'active element è 3 , dopo forth è 4", attached t.active_element as ta implies ta.value = 4)
		end

	t_forth_to_not_void
		local
			t: INT_LINKED_LIST
		do
			create t
			assert ("la lista è vuota, active element è void", t.active_element = Void)
			t.append (3)
			if t.active_element /= Void then
				t.forth
			end
			assert ("l'active element è 3 ed è il last element , dopo forth è Void?", t.active_element = Void)
			t.append (4)
			t.start
			if t.active_element /= Void then
				t.forth
			end
			assert ("l'active element è 3 , dopo forth è 4", attached t.active_element as ta implies ta.value = 4)
		end

end
