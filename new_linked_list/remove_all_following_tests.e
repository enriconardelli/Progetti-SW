note
	description: "Summary description for {REMOVE_ALL_FOLLOWING_TESTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REMOVE_ALL_FOLLOWING_TESTS

inherit

	STATIC_TESTS

feature


	t_lista_senza_value (a_value: INTEGER)
		local
			t: INT_LINKED_LIST
			s: INTEGER
		do
			create t
			t.append (a_value + 1)
			t.append (a_value + 3)
			t.append (a_value + 2)
			s := how_many (t, a_value)
			t.remove_all_following (a_value, a_value + 3)
			assert ("Nella lista non c'è a_value", s = how_many (t, a_value))
		end

	t_lista (tar, val: INTEGER)
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append (tar + val + 1)
			t.append (val)
			t.append (tar)
			t.append (val)
			t.append (val + tar + 3)
			t.remove_all_following (val, tar)
			assert ("E' stata rimossa un'occorrenza di val", 1 = how_many (t, val))
		end

	t_remove_all_following
		do
		--	t_lista_senza_target (3, 2)
			t_lista_senza_value (6)
			t_lista (7, 5)
		end

end
