note
	description: "Test per le feature di tipo SPOSTAMENTO DEL CURSORE"
	author: "Gianluca Pastorini"
	date: "03/04/23"
	revision: "$Revision$"

class
	SPOSTAMENTO_DEL_CURSORE_TESTS

inherit

	STATIC_TESTS

feature --first
	-- Claudia Agulini, 2020/03/06

	a_value: INTEGER = 1

	t_first_one_element
			-- test su lista da un elemento solo
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.start
			if attached t.active_element as ae and attached t.first_element as fe then
				assert ("l'unico elemento della lista non è considerato come primo", ae.value = fe.value)
			end
			assert ("il primo elemento risulta vuoto", t.first_element /= void)
				-- la listta non è vuota quindi il primo elemento non deve essere associato a void
		end

	t_first_multiple_element
			-- test su lista con più di un elemento
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
			assert ("il primo elemento risulta vuoto", t.first_element /= void)
				-- la lista non è vuota quindi il primo elemento non deve essere associato a void
		end

	t_first_void
		local
			t: INT_LINKED_LIST
		do
			create t
			t.start
			assert ("il primo elemento non risulta vuoto", t.first_element = void)
				-- la lista è vuota quindi il primo elemento deve essere associato a void
		end

feature --last
	-- Arianna Calzuola, 2020/03/10

	t_last_one_element
			-- test su lista da un elemento solo
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.last
			if attached t.active_element as ae and attached t.last_element as fe then
				assert ("l'unico elemento della lista non è considerato come ultimo", ae.value = fe.value)
			end
			assert ("l'ultimo elemento risulta vuoto", t.last_element /= void)
				-- la listta non è vuota quindi l'ultimo elemento non deve essere associato a void
		end

	t_last_multiple_element
			-- test su lista con più di un elemento
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value - 3)
			t.append (a_value - 2)
			t.last
			if attached t.active_element as ae and attached t.last_element as fe then
				assert ("l'ultimo elemto della lista risulta sbagliato", ae.value = fe.value)
			end
			assert ("l'ultimo elemento risulta vuoto", t.last_element /= void)
				-- la lista non è vuota quindi l'ultimo elemento non deve essere associato a void
		end

	t_last_void
		local
			t: INT_LINKED_LIST
		do
			create t
			t.last
			assert ("l'ultimo elemento non risulta vuoto", t.last_element = void)
				-- la lista è vuota quindi l'ultimo elemento deve essere associato a void
		end

feature -- forth
	-- Alessandro Filippo 2020/03/08

	t_forth_to_void_one_element
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.start
				-- serve t.start perché append non sposta active element, quindi se non lo inzializzi sta su void
			t.forth
				-- active_element era anche il last_element quindi dopo di lui ci dovrebbe essere void
			assert ("il forth non ha portato active element a void", t.active_element = Void)
		end

	t_forth_to_void_multiple_element
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value - 2)
			t.start
				-- porto il cursore all'inizio
			t.forth
			t.forth
				-- ho spostato di due volte quindi dopo ci dovrebbe essere void
			assert ("il forth non ha portato active element a void", t.active_element = Void)
		end

	t_forth_to_not_void
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value + 4)
			t.start
				-- porto il cursore all'inzio
			t.forth
				-- porto il cursore al secondo elemento che quindi non dovrebbe essere né void né il primo
			assert ("il forth ha portato active element a void", t.active_element /= Void)
			assert ("il forth non ha spostato il cursore", t.active_element /= t.first_element)
		end

end
