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
				assert ("t contiene 1,3,5, active è 1?", ae.value = fe.value)
			end
		end

	t_last
			-- Arianna Calzuola, 2020/03/10
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

	t_forth
			-- Alessandro Filippo 2020/03/08
		local
			t: INT_LINKED_LIST
		do
			create t
			assert ("la lista è vuota, active element è void", t.active_element = Void)
			t.append (3)
			if t.active_element /= Void then t.forth end
			assert ("l'active element è 3 ed è il last element , dopo forth è Void?", t.active_element = Void)
			t.append (4)
			t.start
			if t.active_element /= Void then t.forth end
			assert ("l'active element è 3 , dopo forth è 4", attached t.active_element as ta implies ta.value = 4)
		end
feature -- Ricerca

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

feature -- Inserimento singolo libero

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

feature -- Inserimento singolo vincolato

-- TODO: trasformare con gli agenti i test che verificano le diverse implementazioni di una stessa feature per evitare di replicarli

	t_insert_after
			-- Alessandro Filippo, 2020/03/06
			-- riscritto EN, 2021/08/18
		local
			t: INT_LINKED_LIST
		do
			create t
				-- []
			t.insert_after (3, 5)
			assert ("errore: lista è vuota, ma insert_after (3,5) NON inserisce 3", t.has (3))
			assert ("errore: lista è vuota, ma insert_after (3,5) NON assegna first_element a 3", attached t.first_element as fe implies fe.value = 3)
			assert ("errore: lista è vuota, ma insert_after (3,5) NON assegna last_element a 3", attached t.last_element as le implies le.value = 3)
			t.wipeout
			t.append (6)
				-- [6]
			t.insert_after (3,5)
			assert ("errore: lista contiene solo 6, ma insert_after (3,5) NON inserisce 3", t.has (3))
			assert ("errore: lista contiene solo 6, ma insert_after (3,5) NON inserisce 3 dopo di 6", t.value_after (3,6))
			assert ("errore: lista contiene solo 6, ma insert_after (3,5) NON assegna last_element a 3", attached t.last_element as le implies le.value = 3)
			t.wipeout
			t.append (4); t.append (6)
				-- [4, 6]
			t.insert_after (3,5)
			assert ("errore: lista vale [4, 6], ma insert_after (3,5) NON inserisce 3", t.has(3))
			assert ("errore: lista vale [4, 6], ma insert_after (3,5) NON inserisce 3 dopo di 6 che era l'ultimo' elemento", t.value_after (3,6))
			assert ("errore: lista vale [4,6], ma insert_after (3,5) NON assegna last_element a 3", attached t.last_element as le implies le.value = 3)
			t.wipeout
			t.append (5)
				-- [5]
			t.insert_after (3,5)
			assert ("errore: lista contiene solo 5, ma insert_after (3,5) NON inserisce 3", t.has (3))
			assert ("errore: lista contiene solo 5, ma insert_after (3,5) NON inserisce 3 dopo di 5", t.value_after (3,5))
			assert ("errore: lista contiene solo 5, ma insert_after (3,5) NON assegna last_element a 3", attached t.last_element as le implies le.value = 3)
			t.wipeout
			t.append (6); t.append (5)
				-- [6, 5]
			t.insert_after (3,6)
			assert ("errore: lista vale [6, 5], ma insert_after (3,6) NON inserisce 3", t.has(3))
			assert ("errore: lista vale [6, 5], ma insert_after (3,6) NON inserisce 3 dopo di 6", t.value_after (3,6))
			assert ("errore: lista vale [6, 5], ma insert_after (3,6) NON inserisce 3 prima di 5 che seguiva 6", t.value_before (3,5))
		end

	t_insert_after_reusing
			-- Federico Fiorini, 2020/03/06
			-- riscritto EN, 2021/08/18
		local
			t: INT_LINKED_LIST
		do
			create t
				-- []
			t.insert_after_reusing (3, 5)
			assert ("errore: lista è vuota, ma insert_after_reusing (3,5) NON inserisce 3", t.has (3))
			assert ("errore: lista è vuota, ma insert_after_reusing (3,5) NON assegna first_element a 3", attached t.first_element as fe implies fe.value = 3)
			assert ("errore: lista è vuota, ma insert_after_reusing (3,5) NON assegna last_element a 3", attached t.last_element as le implies le.value = 3)
			t.wipeout
			t.append (6)
				-- [6]
			t.insert_after_reusing (3,5)
			assert ("errore: lista contiene solo 6, ma insert_after_reusing (3,5) NON inserisce 3", t.has (3))
			assert ("errore: lista contiene solo 6, ma insert_after_reusing (3,5) NON inserisce 3 dopo di 6", t.value_after (3,6))
			assert ("errore: lista contiene solo 6, ma insert_after_reusing (3,5) NON assegna last_element a 3", attached t.last_element as le implies le.value = 3)
			t.wipeout
			t.append (4); t.append (6)
				-- [4, 6]
			t.insert_after_reusing (3,5)
			assert ("errore: lista vale [4, 6], ma insert_after_reusing (3,5) NON inserisce 3", t.has(3))
			assert ("errore: lista vale [4, 6], ma insert_after_reusing (3,5) NON inserisce 3 dopo di 6 che era l'ultimo' elemento", t.value_after (3,6))
			assert ("errore: lista vale [4,6], ma insert_after_reusing (3,5) NON assegna last_element a 3", attached t.last_element as le implies le.value = 3)
			t.wipeout
			t.append (5)
				-- [5]
			t.insert_after_reusing (3,5)
			assert ("errore: lista contiene solo 5, ma insert_after_reusing (3,5) NON inserisce 3", t.has (3))
			assert ("errore: lista contiene solo 5, ma insert_after_reusing (3,5) NON inserisce 3 dopo di 5", t.value_after (3,5))
			assert ("errore: lista contiene solo 5, ma insert_after_reusing (3,5) NON assegna last_element a 3", attached t.last_element as le implies le.value = 3)
			t.wipeout
			t.append (6); t.append (5)
				-- [6, 5]
			t.insert_after_reusing (3,6)
			assert ("errore: lista vale [6, 5], ma insert_after_reusing (3,6) NON inserisce 3", t.has(3))
			assert ("errore: lista vale [6, 5], ma insert_after_reusing (3,6) NON inserisce 3 dopo di 6", t.value_after (3,6))
			assert ("errore: lista vale [6, 5], ma insert_after_reusing (3,6) NON inserisce 3 prima di 5 che seguiva 6", t.value_before (3,5))
		end

	t_insert_before
			-- Maria Ludovica Sarandrea, 2021/03/26
			-- EN, 2021/08/18
		local
			t: INT_LINKED_LIST
		do
			create t
				-- []
			t.insert_before (3, 5)
			assert ("errore: lista è vuota, ma insert_before (3,5) NON inserisce 3", t.has (3))
			assert ("errore: lista è vuota, ma insert_before (3,5) NON assegna first_element a 3", attached t.first_element as fe implies fe.value = 3)
			assert ("errore: lista è vuota, ma insert_before (3,5) NON assegna larst_element a 3", attached t.last_element as le implies le.value = 3)
			t.wipeout
			t.append (6)
				-- [6]
			t.insert_before (3,5)
			assert ("errore: lista contiene solo 6, ma insert_before (3,5) NON inserisce 3", t.has (3))
			assert ("errore: lista contiene solo 6, ma insert_before (3,5) NON inserisce 3 prima di 6", t.value_before (3,6))
			assert ("errore: lista contiene solo 6, ma insert_before (3,5) NON assegna first_element a 3", attached t.first_element as fe implies fe.value = 3)
			t.wipeout
			t.append (4); t.append (6)
				-- [4, 6]
			t.insert_before (3,5)
			assert ("errore: lista vale [4, 6], ma insert_before (3,5) NON inserisce 3", t.has(3))
			assert ("errore: lista vale [4, 6], ma insert_before (3,5) NON inserisce 3 prima di 4 che era il primo elemento", t.value_before (3,4))
			assert ("errore: lista vale [4,6], ma insert_before (3,5) NON assegna first_element a 3", attached t.first_element as fe implies fe.value = 3)
			t.wipeout
			t.append (5)
				-- [5]
			t.insert_before (3,5)
			assert ("errore: lista contiene solo 5, ma insert_before (3,5) NON inserisce 3", t.has (3))
			assert ("errore: lista contiene solo 5, ma insert_before (3,5) NON inserisce 3 prima di 5", t.value_before (3,5))
			assert ("errore: lista contiene solo 5, ma insert_before (3,5) NON assegna first_element a 3", attached t.first_element as fe implies fe.value = 3)
			t.wipeout
			t.append (6); t.append (5)
				-- [6, 5]
			t.insert_before (3,5)
			assert ("errore: lista vale [6, 5], ma insert_before (3,5) NON inserisce 3", t.has(3))
			assert ("errore: lista vale [6, 5], ma insert_before (3,5) NON inserisce 3 prima di 5", t.value_before (3,5))
			assert ("errore: lista vale [6, 5], ma insert_before (3,5) NON inserisce 3 dopo di 6 che precedeva 5", t.value_after (3,6))
		end

	t_insert_before_reusing
			-- EN, 2021/08/18
		local
			t: INT_LINKED_LIST
		do
			create t
				-- []
			t.insert_before_reusing (3, 5)
			assert ("errore: lista è vuota, ma insert_before_reusing (3,5) NON inserisce 3", t.has (3))
			assert ("errore: lista è vuota, ma insert_before_reusing (3,5) NON assegna first_element a 3", attached t.first_element as fe implies fe.value = 3)
			assert ("errore: lista è vuota, ma insert_before_reusing (3,5) NON assegna larst_element a 3", attached t.last_element as le implies le.value = 3)
			t.wipeout
			t.append (6)
				-- [6]
			t.insert_before_reusing (3,5)
			assert ("errore: lista contiene solo 6, ma insert_before_reusing (3,5) NON inserisce 3", t.has (3))
			assert ("errore: lista contiene solo 6, ma insert_before_reusing (3,5) NON inserisce 3 prima di 6", t.value_before (3,6))
			assert ("errore: lista contiene solo 6, ma insert_before_reusing (3,5) NON assegna first_element a 3", attached t.first_element as fe implies fe.value = 3)
			t.wipeout
			t.append (4); t.append (6)
				-- [4, 6]
			t.insert_before_reusing (3,5)
			assert ("errore: lista vale [4, 6], ma insert_before_reusing (3,5) NON inserisce 3", t.has(3))
			assert ("errore: lista vale [4, 6], ma insert_before_reusing (3,5) NON inserisce 3 prima di 4 che era il primo elemento", t.value_before (3,4))
			assert ("errore: lista vale [4,6], ma insert_before_reusing (3,5) NON assegna first_element a 3", attached t.first_element as fe implies fe.value = 3)
			t.wipeout
			t.append (5)
				-- [5]
			t.insert_before_reusing (3,5)
			assert ("errore: lista contiene solo 5, ma insert_before_reusing (3,5) NON inserisce 3", t.has (3))
			assert ("errore: lista contiene solo 5, ma insert_before_reusing (3,5) NON inserisce 3 prima di 5", t.value_before (3,5))
			assert ("errore: lista contiene solo 5, ma insert_before_reusing (3,5) NON assegna first_element a 3", attached t.first_element as fe implies fe.value = 3)
			t.wipeout
			t.append (6); t.append (5)
				-- [6, 5]
			t.insert_before_reusing (3,5)
			assert ("errore: lista vale [6, 5], ma insert_before_reusing (3,5) NON inserisce 3", t.has(3))
			assert ("errore: lista vale [6, 5], ma insert_before_reusing (3,5) NON inserisce 3 prima di 5", t.value_before (3,5))
			assert ("errore: lista vale [6, 5], ma insert_before_reusing (3,5) NON inserisce 3 dopo di 6 che precedeva 5", t.value_after (3,6))
		end

	t_insert_before_with_2_cursors
			-- EN, 2021/08/18
		local
			t: INT_LINKED_LIST
		do
			create t
				-- []
			t.insert_before_with_2_cursors (3, 5)
			assert ("errore: lista è vuota, ma insert_before_with_2_cursors (3,5) NON inserisce 3", t.has (3))
			assert ("errore: lista è vuota, ma insert_before_with_2_cursors (3,5) NON assegna first_element a 3", attached t.first_element as fe implies fe.value = 3)
			assert ("errore: lista è vuota, ma insert_before_with_2_cursors (3,5) NON assegna larst_element a 3", attached t.last_element as le implies le.value = 3)
			t.wipeout
			t.append (6)
				-- [6]
			t.insert_before_with_2_cursors (3,5)
			assert ("errore: lista contiene solo 6, ma insert_before_with_2_cursors (3,5) NON inserisce 3", t.has (3))
			assert ("errore: lista contiene solo 6, ma insert_before_with_2_cursors (3,5) NON inserisce 3 prima di 6", t.value_before (3,6))
			assert ("errore: lista contiene solo 6, ma insert_before_with_2_cursors (3,5) NON assegna first_element a 3", attached t.first_element as fe implies fe.value = 3)
			t.wipeout
			t.append (4); t.append (6)
				-- [4, 6]
			t.insert_before_with_2_cursors (3,5)
			assert ("errore: lista vale [4, 6], ma insert_before_with_2_cursors (3,5) NON inserisce 3", t.has(3))
			assert ("errore: lista vale [4, 6], ma insert_before_with_2_cursors (3,5) NON inserisce 3 prima di 4 che era il primo elemento", t.value_before (3,4))
			assert ("errore: lista vale [4,6], ma insert_before_with_2_cursors (3,5) NON assegna first_element a 3", attached t.first_element as fe implies fe.value = 3)
			t.wipeout
			t.append (5)
				-- [5]
			t.insert_before_with_2_cursors (3,5)
			assert ("errore: lista contiene solo 5, ma insert_before_with_2_cursors (3,5) NON inserisce 3", t.has (3))
			assert ("errore: lista contiene solo 5, ma insert_before_with_2_cursors (3,5) NON inserisce 3 prima di 5", t.value_before (3,5))
			assert ("errore: lista contiene solo 5, ma insert_before_with_2_cursors (3,5) NON assegna first_element a 3", attached t.first_element as fe implies fe.value = 3)
			t.wipeout
			t.append (6); t.append (5)
				-- [6, 5]
			t.insert_before_with_2_cursors (3,5)
			assert ("errore: lista vale [6, 5], ma insert_before_with_2_cursors (3,5) NON inserisce 3", t.has(3))
			assert ("errore: lista vale [6, 5], ma insert_before_with_2_cursors (3,5) NON inserisce 3 prima di 5", t.value_before (3,5))
			assert ("errore: lista vale [6, 5], ma insert_before_with_2_cursors (3,5) NON inserisce 3 dopo di 6 che precedeva 5", t.value_after (3,6))
		end

feature --Status

	t_value_follows
			--Maria Ludovica Sarandrea, 2021/03/26
		local
				t: INT_LINKED_LIST
		do
			create t
			if t.has(5) then
				assert("t è vuota, ma t trova 3 dopo 5", not t.value_follows (3, 5))
			end
			t.append (6)
			if t.has(5) then
				assert("t contiene solo 6, ma t trova 3 dopo 5", not t.value_follows (3, 5))
			end
			t.wipeout
			t.append (5)
			assert("t contiene solo 5, ma t trova 3 dopo 5", not t.value_follows (3, 5))
			t.wipeout
			t.append (5);t.append (3)
			assert("t vale [5,3], ma t non trova 3 dopo 5", t.value_follows (3, 5))
			t.wipeout
			t.append (5);t.append (4)
			assert("t vale [5,4], ma t trova 3 dopo 5", not t.value_follows (3, 5))
			t.wipeout
			t.append (6);t.append (4)
			if t.has(5) then
				assert("t vale [6,4], ma t trova 3 dopo 5", not t.value_follows (3, 5))
			end
			t.wipeout
			t.append (3);t.append (5);t.append (6)
			assert("t vale [3,5,6], ma t trova 3 dopo 5", not t.value_follows (3, 5))
			t.wipeout
			t.append (5);t.append (6);t.append (3)
			assert("t vale [5,6,3], ma t non trova 3 dopo 5", t.value_follows (3, 5))
		end

	t_value_after
			-- Enrico Nardelli, 2021/03/23
		local
			t: INT_LINKED_LIST
		do
			create t
			if t.has(5) then
				assert ("t e' vuota, ma t contiene 3 subito dopo 5", not t.value_after (3, 5))
			end
			t.append (5)
			assert ("t contiene solo 5, ma contiene 3 subito dopo 5", not t.value_after (3, 5))
			t.wipeout
			t.append (4)
			if t.has(5) then
				assert ("t contiene solo 4, ma contiene 3 subito dopo 5", not t.value_after (3, 5))
			end
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
			if t.has(5) then
				assert ("t vale [3, 4]', ma contiene 3 subito dopo 5", not t.value_after (3, 5))
			end
			t.wipeout
			t.append (5) ; t.append (4) ; t.append (3)
			assert ("t vale [5, 4, 3]', ma contiene 3 subito dopo 5", not t.value_after (3, 5))
			t.wipeout
			t.append (4) ; t.append (5) ; t.append (3)
			assert ("t vale [4, 5, 3]', ma non trova 3 subito dopo 5", t.value_after (3, 5))
		end

	t_value_precedes
			--Maria Ludovica Sarandrea, 2021/04/03
		local
			t: INT_LINKED_LIST
		do
			create t
			if t.has(5) then
				assert("t è vuota, ma t contiene 3 prima di 5", not t.value_precedes (3, 5))
			end
			t.append (5)
			assert("t contiene solo 5, ma t contiene 3 prima di 5", not t.value_precedes (3, 5))
			t.wipeout
			t.append (6)
			if t.has(5) then
				assert("t contiene solo 6, ma t contiene 3 prima di 5", not t.value_precedes (3, 5))
			end
			t.wipeout
			t.append (5); t.append (3)
			assert("t vale [5,3], ma t contiene 3 prima di 5", not t.value_precedes (3, 5))
			t.wipeout
			t.append (3); t.append (5)
			assert("t vale [3,5], ma t non contiene 3 prima di 5", t.value_precedes (3, 5))
			t.wipeout
			t.append (6); t.append (5)
			assert("t vale [6,5], ma t contiene 3 prima di 5", not t.value_precedes (3, 5))
			t.wipeout
			t.append (3); t.append (6)
			if t.has(5) then
				assert("t vale [3,6], ma t contiene 3 prima di 5", not t.value_precedes (3, 5))
			end
			t.wipeout
			t.append (3); t.append (5); t.append (6)
			assert("t vale [3,5,6], ma t non contiene 3 prima di 5", t.value_precedes (3, 5))
			t.wipeout
			t.append (4); t.append (5); t.append (6)
			assert("t vale [4,5,6], ma t contiene 3 prima di 5", not t.value_precedes (3, 5))
		end

	t_value_before
		--Sara Forte 2021/03/31
		local
			t: INT_LINKED_LIST
		do
			create t
			-- []
			if t.has(3) then
				assert("errore: la lista è vuota ma è stato trovato 5 subito prima di 3", not t.value_before(5,3))
			end

			t.append (3)
			-- [3]
			assert("errore: è stato trovato 5 subito prima di 3, ma la lista contiene solo 3", not t.value_before (5, 3))
			t.wipeout

			t.append (5)
			-- [5]
			if t.has(3) then
				assert("errore: è stato trovato 5 subito prima di 3, ma la lista contiene solo 5", not t.value_before (5, 3))
			end
			t.wipeout

			t.append (5); t.append (3);
			-- [5,3]
			assert("errore non è stato trovato 5 subito prima di 3", t.value_before (5, 3))
			t.wipeout

			t.append (2); t.append (3);
			-- [2,3]
			assert("errore: è stato trovato 5 subito prima di 3, ma 5 non era nella lista", not t.value_before (5, 3))

			t.append (5)
			-- [2,3,5]
			assert("errore: è stato trovato 5 subito prima di 3, ma era dopo", not t.value_before (5, 3))
			t.wipeout

			t.append (3);t.append (5)
			-- [3,5]
			assert("errore: è stato trovato 5 subito prima di 3, ma era dopo", not t.value_before (5, 3))

			t.append (2); t.append (3);
			-- [3,5,2,3]
			assert("errore: è stato trovato 5 subito prima di 3, ma c'è un altro valore in mezzo", not t.value_before (5, 3))
			t.wipeout

			t.append (2) ; t.append (5) ; t.append (3);
			-- [2,5,3]
			assert("errore non è stato trovato 5 subito prima di 3", t.value_before (5, 3))

		end

	t_index_of
			-- EN 2021/07/29
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (3)
			t.printout
			-- [3]
			assert("errore: la lista NON contiene 3 in prima posizione", t.index_of(3) = 1)
			t.prepend (5)
			t.printout
			-- [5,3]
			assert("errore: la lista NON contiene 5 in prima posizione", t.index_of(5) = 1)
			assert("errore: la lista NON contiene 3 in seconda posizione", t.index_of(3) = 2)
			t.append (6)
			t.printout
			-- [5,3,6]
			assert("errore: la lista NON contiene 5 in prima posizione", t.index_of(5) = 1)
			assert("errore: la lista NON contiene 3 in seconda posizione", t.index_of(3) = 2)
			assert("errore: la lista NON contiene 6 in terza posizione", t.index_of(6) = 3)
			t.prepend (4)
			t.printout
			-- [4,5,3,6]
			assert("errore: la lista NON contiene 4 in prima posizione", t.index_of(4) = 1)
			assert("errore: la lista NON contiene 5 in seconda posizione", t.index_of(5) = 2)
			assert("errore: la lista NON contiene 3 in terza posizione", t.index_of(3) = 3)
			assert("errore: la lista NON contiene 6 in quarta posizione", t.index_of(6) = 4)
		end


feature -- Insertion multiple targeted

	 t_insert_multiple_after
	 		-- Sara Forte, 2021/03/30
	 		-- EN, 2021/08/18
		local
			t: INT_LINKED_LIST
		do
			create t
				-- []
			t.insert_multiple_after (3, 5)
			assert ("errore: lista vuota ma insert_multiple_after (3,5) NON inserisce 3", t.has(3))
			assert ("errore: lista vuota ma insert_multiple_after (3,5) NON assegna first_element a 3", attached t.first_element as fe implies fe.value = 3)
			assert ("errore: lista vuota ma insert_multiple_after (3,5) NON assegna last_element a 3", attached t.last_element as le implies le.value = 3)
			t.wipeout
			t.append (6)
				-- [6]
			t.insert_multiple_after (3, 5)
			assert ("errore: lista contiene solo 6, ma insert_multiple_after (3,5) NON inserisce 3", t.has (3))
			assert ("errore: lista contiene solo 6, ma insert_multiple_after (3,5) NON inserisce 3 dopo di 6", t.value_after (3,6))
			assert ("errore: lista contiene solo 6, ma insert_multiple_after (3,5) NON assegna last_element a 3", attached t.last_element as le implies le.value = 3)
			t.wipeout
			t.append (4); t.append (6)
				-- [4, 6]
			t.insert_multiple_after (3, 5)
			assert ("errore: lista vale [4, 6], ma insert_multiple_after (3,5) NON inserisce 3", t.has(3))
			assert ("errore: lista vale [4, 6], ma insert_multiple_after (3,5) NON inserisce 3 dopo di 6 che era l'ultimo' elemento", t.value_after (3,6))
			assert ("errore: lista vale [4, 6], ma insert_multiple_after (3,5) NON assegna last_element a 3", attached t.last_element as le implies le.value = 3)
			t.wipeout
			t.append (2) ; t.append (5) ;	t.append (1) ; t.append (5)
				-- [2, 5, 1, 5]
			t.insert_multiple_after (3, 5)
				-- [2, 5, 3, 1, 5, 3]
			assert ("errore: il target esiste due volte, ma insert_multiple_after (3,5) NON inserisce 3", t.has (3))
			assert ("errore: il target esiste due volte, ma insert_multiple_after (3,5) NON inserisce 3 due volte", how_many (t, 3) = 2)
			assert ("errore: il target esiste due volte, ma dopo insert_multiple_after (3,5) la lista NON contiene esattamente due elementi in più", t.count = 6)
			assert ("errore: il target esiste due volte, ma insert_multiple_after (3,5) NON inserisce 3 dopo la sua prima occorrenza", (attached t.get_element (5) as el and then attached el.next as eln) implies eln.value = 3)
			assert ("errore: il target era l'ultimo, ma insert_multiple_after (3,5) NON assegna last_element a 3", attached t.last_element as le implies le.value = 3)
		end

	 t_insert_multiple_after_reusing
	 		-- Sara Forte, 2021/03/30
	 		-- EN, 2021/08/18
		local
			t: INT_LINKED_LIST
		do
			create t
			t.insert_multiple_after_reusing (3, 5)
			assert ("errore: lista vuota ma insert_multiple_after_reusing (3,5) NON inserisce 3", t.has(3))
			assert ("errore: lista vuota ma insert_multiple_after_reusing (3,5) NON assegna first_element a 3", attached t.first_element as fe implies fe.value = 3)
			assert ("errore: lista vuota ma insert_multiple_after_reusing (3,5) NON assegna last_element a 3", attached t.last_element as le implies le.value = 3)
			t.wipeout
			t.append (6)
				-- [6]
			t.insert_multiple_after_reusing (3, 5)
			assert ("errore: lista contiene solo 6, ma insert_multiple_after_reusing (3,5) NON inserisce 3", t.has (3))
			assert ("errore: lista contiene solo 6, ma insert_multiple_after_reusing (3,5) NON inserisce 3 dopo di 6", t.value_after (3,6))
			assert ("errore: lista contiene solo 6, ma insert_multiple_after_reusing (3,5) NON assegna last_element a 3", attached t.last_element as le implies le.value = 3)
			t.wipeout
			t.append (4); t.append (6)
				-- [4, 6]
			t.insert_multiple_after_reusing (3, 5)
			assert ("errore: lista vale [4, 6], ma insert_multiple_after_reusing (3,5) NON inserisce 3", t.has(3))
			assert ("errore: lista vale [4, 6], ma insert_multiple_after_reusing (3,5) NON inserisce 3 dopo di 6 che era l'ultimo' elemento", t.value_after (3,6))
			assert ("errore: lista vale [4, 6], ma insert_multiple_after_reusing (3,5) NON assegna last_element a 3", attached t.last_element as le implies le.value = 3)
			t.wipeout
			t.append (2) ; t.append (5) ;	t.append (1) ; t.append (5)
				-- [2, 5, 1, 5]
			t.insert_multiple_after_reusing (3, 5)
				-- [2, 5, 3, 1, 5, 3]
			assert ("errore: il target esiste due volte, ma insert_multiple_after_reusing (3,5) NON inserisce 3", t.has (3))
			assert ("errore: il target esiste due volte, ma insert_multiple_after_reusing (3,5) NON inserisce 3 due volte", how_many (t, 3) = 2)
			assert ("errore: il target esiste due volte, ma dopo insert_multiple_after_reusing (3,5) la lista NON contiene esattamente due elementi in più", t.count = 6)
			assert ("errore: il target esiste due volte, ma insert_multiple_after_reusing (3,5) NON inserisce 3 dopo la sua prima occorrenza", (attached t.get_element (5) as el and then attached el.next as eln) implies eln.value = 3)
			assert ("errore: il target era l'ultimo, ma insert_multiple_after_reusing (3,5) NON assegna last_element a 3", attached t.last_element as le implies le.value = 3)
		end

	t_insert_multiple_before
			-- Riccardo Malandruccolo, 2020/03/07
		local
			t: INT_LINKED_LIST
		do
			create t
			t.insert_multiple_before (3, 10)
				-- [3]
			assert ("errore: su lista vuota non aggiunge il valore", how_many(t, 3) = 1)
			assert ("errore: su lista vuota l'elemento aggiunto non è first_element", attached t.first_element as fe implies fe.value = 3)
			assert ("errore: su lista vuota l'elemento aggiunto non è last_element", attached t.last_element as le implies le.value = 3)
			assert ("errore: su lista vuota l'elemento aggiunto è diventato active_element", t.active_element = Void)
			t.append (2)
			t.append (1)
			t.append (3)
				-- [3,2,1,3]

			t.insert_multiple_before (5, 3)
				-- [5,3,2,1,5,3]
			assert ("errore: non aggiunge il valore due volte", how_many (t, 5) = 2)
			assert ("errore: se inserisce il valore all'inizio, il first_element non cambia", attached t.first_element as fe implies fe.value = 5)
			assert ("errore: non aggiunge il valore prima del target", attached t.get_element (5) as el and then attached el.next as eln implies eln.value = 3)
			assert ("errore: non aggiunge il valore più volte", t.count = 6)
			t.insert_multiple_before (4, 7)
				-- [4,5,3,2,1,5,3]
			assert ("errore: il valore non viene aggiunto una volta se non trovo il target", how_many(t, 4) = 1)
			assert ("errore: il valore non viene aggiunto una volta se non trovo il target", t.count = 7)
			assert ("errore: il valore non viene aggiunto all'inizio se non trovo il target", attached t.first_element as fe implies fe.value = 4)
		end

	t_insert_multiple_before_without_prepend
			-- Riccardo Malandruccolo, 2020/03/07
		local
			t: INT_LINKED_LIST
		do
			create t
			t.insert_multiple_before_without_prepend (3, 10)
				-- [3]
			assert ("errore: su lista vuota non aggiunge il valore", how_many(t, 3) = 1)
			assert ("errore: su lista vuota l'elemento aggiunto non è first_element", attached t.first_element as fe implies fe.value = 3)
			assert ("errore: su lista vuota l'elemento aggiunto non è last_element", attached t.last_element as le implies le.value = 3)
			assert ("errore: su lista vuota l'elemento aggiunto è diventato active_element", t.active_element = Void)
			t.append (2)
			t.append (1)
			t.append (3)
				-- [3,2,1,3]

			t.insert_multiple_before_without_prepend (5, 3)
				-- [5,3,2,1,5,3]
			assert ("errore: non aggiunge il valore due volte", how_many (t, 5) = 2)
			assert ("errore: se inserisce il valore all'inizio, il first_element non cambia", attached t.first_element as fe implies fe.value = 5)
			assert ("errore: non aggiunge il valore prima del target", attached t.get_element (5) as el and then attached el.next as eln implies eln.value = 3)
			assert ("errore: non aggiunge il valore più volte", t.count = 6)
			t.insert_multiple_before_without_prepend (4, 7)
				-- [4,5,3,2,1,5,3]
			assert ("errore: il valore non viene aggiunto una volta se non trovo il target", how_many(t, 4) = 1)
			assert ("errore: il valore non viene aggiunto una volta se non trovo il target", t.count = 7)
			assert ("errore: il valore non viene aggiunto all'inizio se non trovo il target", attached t.first_element as fe implies fe.value = 4)
		end

feature -- Removal single free

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
			assert ("errore: non è stato modificato l'active_element correttamente", attached t.active_element as ae implies ae.value = 2)
			assert ("errore: non è stato modificato il first_element correttamente", attached t.first_element as fe implies fe.value = 2)
			t.forth
				-- t.active_element = 3
			t.remove_active
				-- [2]
				-- t.active_element = 2
			assert ("errore: non ha eliminato l'active_element", not t.has (3))
			assert ("errore: non è stato modificato l'active_element correttamente", attached t.active_element as ae implies ae.value = 2)
			assert ("errore: non è stato modificato il last_element correttamente", attached t.last_element as le implies le.value = 2)
			t.remove_active
				-- []
				-- t.active_element = Void
			assert ("errore: non ha eliminato l'active_element", not t.has (2))
			assert ("errore: non è stato modificato l'active_element correttamente", t.active_element = Void)
			assert ("errore: non è stato modificato il last_element correttamente", t.last_element = Void)

		end

	t_remove_earliest
		--Maria Ludovica Sarandrea, 2021/04/03
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (3)
			-- t = [3]
			t.remove_earliest (3)
			assert("Non è stata rimossa l'unica occorrenza di 3", not t.has (3))
			t.wipeout
			t.append (3)
			t.last
			-- t = [3]
			t.remove_earliest (3)
			assert("Non è stata rimossa l'unica occorrenza di 3", not t.has (3))
			assert("La lista è vuota, ma l'active element non è vuoto", t.active_element = Void)
			t.wipeout
			t.append (5)
			-- t = [5]
			t.remove_earliest (3)
			assert("t non conteneva 3, ma è stato rimosso un elemento", t.has(5))
			t.wipeout

			t.append (3); t.append (5)
			-- t = [3,5]
			t.remove_earliest (3)
			assert("t conteneva 3, ma 3 non è stato rimosso", not t.has (3))
			t.wipeout
			t.append (3); t.append (5); t.start
			-- t = [3,5]
			t.remove_earliest (3)
			assert("t conteneva 3, ma 3 non è stato rimosso", not t.has (3))
			assert("L'active element non è stato posizionato correttamente", attached t.active_element as ae implies ae.value = 5)
			t.wipeout

			t.append (5); t.append (3)
			-- t = [5,3]
			t.remove_earliest (3)
			assert("t conteneva 3, ma 3 non è stato rimosso", not t.has (3))
			t.wipeout
			t.append (5); t.append (3); t.last
			-- t = [5,3]
			t.remove_earliest (3)
			assert("t conteneva 3, ma 3 non è stato rimosso", not t.has (3))
			assert("L'active element non è stato posizionato correttamente", attached t.active_element as ae implies ae.value = 5)
			t.wipeout

			t.append (2); t.append (3); t.append (5)
			-- t = [2,3,5]
			t.remove_earliest (3)
			assert("t conteneva 3, ma 3 non è stato rimosso", not t.has (3))
			t.wipeout
			t.append (2); t.append (3); t.append (5); t.start; t.forth
			-- t = [2,3,5]
			t.remove_earliest (3)
			assert("t conteneva 3, ma 3 non è stato rimosso", not t.has (3))
			assert("L'active element non è stato posizionato correttamente", attached t.active_element as ta implies ta.value = 5)
			t.wipeout

			t.append (1); t.append (3); t.append (5); t.append (3); t.append (4)
			-- t = [1,3,5,3,4]
			t.remove_earliest (3)
			assert("t conteneva due occorrenze di 3, ed è stato rimosso più di un elemento", not (t.count < 4))
			assert("t conteneva due occorrenze di 3, ma 3 non è stato rimosso", not (t.count > 4))
			assert("t conteneva due occorrenze di 3 e non è stata rimossa la prima", t.value_after (5, 1))
			t.wipeout
			t.append (1); t.append (3); t.append (5); t.append (3); t.append (4); t.start; t.forth
			-- t = [1,3,5,3,4]
			t.remove_earliest (3)
			assert("t conteneva due occorrenze di 3, ed è stato rimosso più di un elemento", not (t.count < 4))
			assert("t conteneva due occorrenze di 3, ma 3 non è stato rimosso", not (t.count > 4))
			assert("L'active element non è stato posizionato correttamente", attached t.active_element as ta implies ta.value = 5)
			assert("t conteneva due occorrenze di 3 e non è stata rimossa la prima", t.value_after (5, 1))

		end

		t_remove_latest
			-- Sara Forte, 2021/03/28
			local
				t: INT_LINKED_LIST
			do
				create t
				t.append (2)
				-- [2]
				t.remove_latest (2)
				assert("errore: non è stato rimossa l'unica occorrenza di 2", not t.has (2))
				t.wipeout
				t.append (2); t.start
				-- [2]
				t.remove_latest (2)
				assert("errore: non è stato rimossa l'unica occorrenza di 2", not t.has (2))
				assert("errore: la lista è vuota, ma l'active element non è vuoto" , t.active_element = Void)
				t.wipeout

				t.append (1)
				-- [1]
				t.remove_latest (2)
				assert("errore: la lista non conteneva l'elemento 2, ma è stato rimosso un elemento", t.has (1))
				t.wipeout

				t.append (1) ; t.append (2)
				-- [1,2]
				t.remove_latest (2)
				assert("errore: non è stato rimossa l'unica occorrenza di 2", not t.has (2))
				t.wipeout
				t.append (1) ; t.append (2); t.last
				-- [1,2]
				t.remove_latest (2)
				assert("errore: non è stato rimossa l'unica occorrenza di 2", not t.has (2))
				assert("errore: non è posizionato correttamente l'active element", attached t.active_element as ta implies ta.value = 1)
				t.wipeout

				t.append (2) ; t.append (1)
				-- [2,1]
				t.remove_latest (2)
				assert("errore: non è stato rimossa l'unica occorrenza di 2", not t.has (2))
				t.wipeout
				t.append (2) ; t.append (1); t.start
				-- [2,1]
				t.remove_latest (2)
				assert("errore: non è stato rimossa l'unica occorrenza di 2", not t.has (2))
				assert("errore: non è posizionato correttamente l'active element", attached t.active_element as ta implies ta.value = 1)
				t.wipeout

				t.append (2) ; t.append (3); t.append (2); t.append (1)
				-- [2,3,2,1]
				t.remove_latest (2)
				assert("errore: non è stato rimosso alcun elemento ", not (t.count > 3))
				assert("errore: sono stati rimossi più di un elemento ", not (t.count < 3))
				assert("errore: non è stata rimossa l'ultima occorrenza dell'elemento 2", attached t.last_element as le implies le.value = 1)
				assert("errore: è stata rimossa la prima occorrenza dell'elemento 2", attached t.first_element as fe implies fe.value = 2)
				t.wipeout
				t.append (2) ; t.append (3); t.append (2); t.append (1); t.start; t.forth; t.forth
				-- [2,3,2,1]
				t.remove_latest (2)
				assert("errore: non è stato rimosso alcun elemento ", not (t.count > 3))
				assert("errore: sono stati rimossi più di un elemento ", not (t.count < 3))
				assert("errore: non è stata rimossa l'ultima occorrenza dell'elemento 2", attached t.last_element as le implies le.value = 1)
				assert("errore: è stata rimossa la prima occorrenza dell'elemento 2", attached t.first_element as fe implies fe.value = 2)
				assert("errore: non è posizionato correttamente l'active element", attached t.active_element as ta implies ta.value = 1)
			end



feature -- Removal multiple free

	t_remove_all
		-- Sara Forte, 2021/03/31
		local
				t: INT_LINKED_LIST
			do
				create t
				t.append (3)
				t.remove_all (3)
				assert("errore, non è stato rimosso 3", not t.has (3))

				t.append (3) ; t.append (1) ; t.append (2) ; t.append (3) ; t.append (1) ; t.append (3)
				t.remove_all (3)
				assert("errore, non è stato rimosso 3", not t.has (3))
				assert("errore, oltre ai valori 3 sono stati rimossi altri elementi", not (t.count < 3))
				t.wipeout

				t.append (1) ; t.append (2)
				t.remove_all (3)
				assert("errore: 3 non era presente, ma è stato rimosso un elemento", not (t.count < 2))

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

feature --Other

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
			assert ("errore: il numero di elementi della lista è cambiato", t.count = 3)
			t.start
				--t.active_element.value = 3
			if attached t.active_element as ae then
				assert ("invertita la lista [1,2,3], inizializzato active_element come primo elemento, active_element è 3?", ae.value = 3)
			end
			t.forth
				--t.active_element.value = 2
			if attached t.active_element as ae then
				assert ("avanzato active element, active_element è 2?", ae.value = 2)
			end
			t.forth
				--t.active_element.value = 1
			if attached t.active_element as ae then
				assert ("avanzato active element, active_element è 1?", ae.value = 1)
			end
		end

feature -- Manipulation

	--to do: t_head_list

feature -- Computation

	t_sum_of_positive
			--Giulia Iezzi 2020/03/08
		local
			t: INT_LINKED_LIST
		do
			create t
			assert ("la lista è vuota, fa zero?", t.sum_of_positive = 0)
			t.append (1)
			t.append (2)
			t.append (-1)
			assert ("la lista contiene 1 ,2 e -1, fa 3?", t.sum_of_positive = 3)
		end

		--to do: t_higest

feature -- Convenience

	 t_count_of
	 		-- EN, 2021/08/18
		local
			t: INT_LINKED_LIST
		do
			create t
				-- []
			assert ("errore: su lista vuota il risultato non è zero", t.count_of(3) = 0)
			t.append (2) ; t.append (4) ;	t.append (1)
				-- [2, 4, 1]
			assert ("errore: la lista non contiene un'occorrenza di 3 ma il conteggio non è zero", t.count_of(3) = 0)
			assert ("errore: la lista contiene un'occorrenza di 2 ma il conteggio non è uno", t.count_of(2) = 1)
			assert ("errore: la lista contiene un'occorrenza di 4 ma il conteggio non è uno", t.count_of(4) = 1)
			assert ("errore: la lista contiene un'occorrenza di 1 ma il conteggio non è uno", t.count_of(1) = 1)
			t.wipeout
			t.append (2) ; t.append (5) ;	t.append (1) ; t.append (5)
				-- [2, 5, 1, 5]
			t.insert_multiple_after_reusing (3, 5)
				-- [2, 5, 3, 1, 5, 3]
			assert ("errore: la lista non contiene un'occorrenza di 4 ma il conteggio non è zero", t.count_of(4) = 0)
			assert ("errore: la lista contiene un'occorrenza di 2 ma il conteggio non è uno", t.count_of(2) = 1)
			assert ("errore: la lista contiene un'occorrenza di 1 ma il conteggio non è uno", t.count_of(1) = 1)
			assert ("errore: la lista contiene due occorrenze di 5 ma il conteggio non è due", t.count_of(5) = 2)
			assert ("errore: la lista contiene due occorrenze di 3 ma il conteggio non è due", t.count_of(3) = 2)
		end

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
	--to do: t_printout		


feature -- Controllo lista

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
			assert("la lista non è vuota", t_vuota.count = 0)
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
			assert("il first_element non è impostato correttamente", attached t_due.first_element as fe and then fe.value = a_value)
			assert("il last_element non è impostato correttamente", attached t_due.last_element as le and then le.value = 2*a_value)
		end


end
