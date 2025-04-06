note
	description: "Test per le feature di tipo SPOSTAMENTO DEL CURSORE"
	author: "Gianluca Pastorini"
	date: "03/04/23"
	revision: "$Revision$"

class
	SPOSTAMENTO_DEL_CURSORE_TESTS2

inherit

	EQA_TEST_SET
		redefine
			on_prepare
		end

feature -- creazione istanza di List_Builder

	on_prepare
		do
			create a_list_builder.default_creation
		end

feature -- parametri

	a_list_builder: LIST_BUILDER

	feature -- parametri

	a_value: INTEGER = 1

	other_element_1: INTEGER = 5

	other_element_2: INTEGER = 7

feature --start

	t_first_one_element
			-- test su lista da un elemento solo
		do
			(a_list_builder.list_V).start
			if attached (a_list_builder.list_V).active_element as ae and attached (a_list_builder.list_V).first_element as fe then
				assert ("l'unico elemento della lista non è considerato come primo", ae.value = fe.value)
			end
			assert ("il primo elemento risulta vuoto", (a_list_builder.list_V).first_element /= Void)
				-- la listta non è vuota quindi il primo elemento non deve essere associato a void
			assert ("l'indice non è stato spostato ad 1", (a_list_builder.list_V).index = 1)
		end

	t_first_multiple_element
			-- test su lista con più di un elemento
		do
			if attached (a_list_builder.list_Ve1e2).active_element as ae and attached (a_list_builder.list_Ve1e2).first_element as fe then
				assert ("il primo elemto della lista risulta sbagliato", ae.value = fe.value)
			end
			assert ("il primo elemento risulta vuoto", (a_list_builder.list_Ve1e2).first_element /= Void)
				-- la lista non è vuota quindi il primo elemento non deve essere associato a void
			assert ("l'indice non è stato spostato ad 1", (a_list_builder.list_Ve1e2).index = 1)
		end

	t_first_void
		do
			(a_list_builder.list_empty).start
			assert ("il primo elemento non risulta vuoto", (a_list_builder.list_empty).first_element = Void)
				-- la lista è vuota quindi il primo elemento deve essere associato a void
			assert ("l'indice non è 0 nonostante la lista sia vuota", (a_list_builder.list_empty).index = 0)
		end

feature --last
	t_last_one_element
			-- test su lista da un elemento solo
		do
			(a_list_builder.list_V).last
			if attached (a_list_builder.list_V).active_element as ae and attached (a_list_builder.list_V).last_element as fe then
				assert ("l'unico elemento della lista non è considerato come ultimo", ae.value = fe.value)
			end
			assert ("l'ultimo elemento risulta vuoto", (a_list_builder.list_V).last_element /= void)
				-- la listta non è vuota quindi l'ultimo elemento non deve essere associato a void
			assert ("l'indice non è stato spostato ad count", (a_list_builder.list_V).index = (a_list_builder.list_V).count)
		end

	t_last_multiple_element
			-- test su lista con più di un elemento
		do

			(a_list_builder.list_Ve1e2).last
			if attached (a_list_builder.list_Ve1e2).active_element as ae and attached (a_list_builder.list_Ve1e2).last_element as fe then
				assert ("l'ultimo elemto della lista risulta sbagliato", ae.value = fe.value)

			end
			assert ("l'ultimo elemento risulta vuoto", (a_list_builder.list_Ve1e2).last_element /= Void)
				-- la lista non è vuota quindi l'ultimo elemento non deve essere associato a void
			assert ("l'indice non è stato spostato ad count", (a_list_builder.list_Ve1e2).index = (a_list_builder.list_Ve1e2).count)
		(a_list_builder.list_Ve1e2).start
		end

	t_last_void
		do
			(a_list_builder.list_empty).last
			assert ("l'ultimo elemento non risulta vuoto", (a_list_builder.list_empty).last_element = Void)
				-- la lista è vuota quindi l'ultimo elemento deve essere associato a void
			assert ("l'indice non è 0 nonostante la lista sia vuota", (a_list_builder.list_empty).index = 0)
		(a_list_builder.list_empty).start
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
			assert ("l'indice non è 0 nonostante active sia Void", t.index = 0)
		end

	t_forth_to_void_multiple_element
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (other_element_1)
			t.start
				-- porto il cursore all'inizio
			t.forth
			t.forth
				-- ho spostato di due volte quindi dopo ci dovrebbe essere void
			assert ("il forth non ha portato active element a Void", t.active_element = Void)
			assert ("l'indice non è 0 nonostante active sia Void", t.index = 0)
		end

	t_forth_to_not_void
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (other_element_1)
			t.start
				-- porto il cursore all'inzio
			t.forth
				-- porto il cursore al secondo elemento che quindi non dovrebbe essere né void né il primo
			assert ("il forth ha portato active element a void", t.active_element /= Void)
			assert ("il forth non ha spostato il cursore", t.active_element /= t.first_element)
			assert ("il forth non ha portato active a last element", t.active_element = t.last_element)
			assert ("l'indice non è count nonostante active sia last element", t.index = t.count)
		end

feature -- go_i_th

	t_go_i_th_zero
		do

			(a_list_builder.list_Ve1e2).go_i_th (0)
			assert ("active non è stato spostato a Void", (a_list_builder.list_Ve1e2).active_element = Void)
			assert ("index non è stato messo ad 0", (a_list_builder.list_Ve1e2).index = 0)
		end

	t_go_i_th_first

		do

			(a_list_builder.list_Ve1e2).go_i_th (1)
			assert ("active non è stato spostato a first", (a_list_builder.list_Ve1e2).active_element = (a_list_builder.list_Ve1e2).first_element)
			assert ("index non è stato messo ad 1", (a_list_builder.list_Ve1e2).index = 1)
		(a_list_builder.list_Ve1e2).go_i_th (0)
		end

	t_go_i_th_last

		do
			(a_list_builder.list_Ve1e2).go_i_th ((a_list_builder.list_Ve1e2).count)
			assert ("active non è stato spostato all'ultimo elemento", (a_list_builder.list_Ve1e2).active_element = (a_list_builder.list_Ve1e2).last_element)
			assert ("index non è stato messo a 3", (a_list_builder.list_Ve1e2).index = (a_list_builder.list_Ve1e2).count)
		end

	t_go_i_th_middle

		do

			(a_list_builder.list_Ve1e2).go_i_th (2)
			assert ("active non è stato spostato al secondo elemento", (a_list_builder.list_Ve1e2).active_element = (a_list_builder.list_Ve1e2).get_element (other_element_1))
			assert ("index non è stato messo ad 2", (a_list_builder.list_Ve1e2).index = 2)
		(a_list_builder.list_Ve1e2).go_i_th (0)
		end

end
