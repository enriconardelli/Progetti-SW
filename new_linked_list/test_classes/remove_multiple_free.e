note
	description: "Test per le feature di tipo remove_multiple_free."
	author: "Gianluca Pastorni"
	date: "07/04/23"
	revision: "$Revision$"

class
	REMOVE_MULTIPLE_FREE_TESTS

inherit

	STATIC_TESTS

feature -- t_remove_all
	-- Sara Forte, 2021/03/31

	a_value: INTEGER = 1

	t_remove_all_no_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 2)
			t.append (a_value + 2)
			t.remove_all (a_value)
			assert ("è stato rimosso qualche elemento nonostante la lista non abbia a_value", t.count = 2)
		end

	t_remove_all_single_value_start
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value + 2)
			t.append (a_value - 4)
			t.start
			t.remove_all (a_value)
			assert ("non è stato rimosso nessun elemento", t.count < 3)
			assert ("sono stati rimossi troppi elementi", t.count >= 2)
			assert ("non è stato aggiornato first_element", t.first_element /= Void and attached t.first_element as fe implies fe.value = a_value + 2)
			assert ("non è stato aggiornato active_element", t.active_element /= Void and attached t.active_element as ae implies ae.value = a_value + 2)
			assert ("index è stato modificato nonostante active sia ancora il primo elemento", t.index = 1)
		end

	t_remove_all_single_value_middle
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 2)
			t.append (a_value)
			t.append (a_value + 2)
			t.go_i_th (2)
			t.remove_all (a_value)
			assert ("non è stato rimosso nessun elemento", t.count < 3)
			assert ("sono stati rimossi troppi elementi", t.count >= 2)
			assert ("non è stato aggiornato active_element", t.active_element /= Void and attached t.active_element as ae implies ae.value = a_value + 2)
			assert ("index è stato modificato nonostante active sia ancora il secondo elemento", t.index = 2)
		end

	t_remove_all_single_value_last
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 2)
			t.append (a_value + 2)
			t.append (a_value)
			t.last
			t.remove_all (a_value)
			assert ("non è stato rimosso nessun elemento", t.count < 3)
			assert ("sono stati rimossi troppi elementi", t.count >= 2)
			assert ("non è stato aggiornato last_element", t.last_element /= Void and attached t.last_element as le implies le.value = a_value + 2)
			assert ("non è stato aggiornato active_element", t.active_element /= Void and attached t.active_element as ae implies ae.value = a_value + 2)
			assert ("index non è stato modificato correttamente", t.index = 2)
		end

	t_remove_all_multiple_value
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value - 2)
			t.append (a_value)
			t.append (a_value + 2)
			t.append (a_value)
			t.go_i_th (2)
			t.remove_all (a_value)
			assert ("non è stato rimosso nessun elemento", t.count < 4)
			assert ("sono stati rimossi troppi elementi", t.count >= 2)
			assert ("non è stato aggiornato last_element", t.last_element /= Void and attached t.last_element as le implies le.value = a_value + 2)
			assert ("non è stato aggiornato active_element", t.active_element /= Void and attached t.active_element as ae implies ae.value = a_value + 2)
			assert ("index è stato modificato nonostante active sia ancora il secondo elemento", t.index = 2)
		end

feature -- t_wipeout
	-- Claudia Agulini, 2020/03/08

	t_wipeout_unico
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (a_value)
			t.append (a_value + 3)
			t.append (a_value - 2)
			t.start
			t.wipeout
			assert ("errore: non ha eliminato first_element", t.first_element = Void)
			assert ("errore: non ha eliminato active_element", t.active_element = Void)
			assert ("errore: non ha eliminato last_element", t.last_element = Void)
			assert ("errore: non ha eliminato tutti gli elementi", t.count = 0)
			assert ("errore: non ha impostato index a 0", t.index = 0)
		end

end
