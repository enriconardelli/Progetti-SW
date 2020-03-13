note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	REMOVE_EARLIEST_FOLLOWING_TESTS

inherit
	STATIC_TESTS

feature -- Test routines
-- Arianna Calzuola 2020/03/12

	how_many_following_a_value_after_target(t: INT_LINKED_LIST; a_value, target: INTEGER): INTEGER
	-- return how many times `a_value' occurs in `t' following target
	local
	current_element: INT_LINKABLE
	target_found: BOOLEAN
	do
		if t.count < 2 then
			Result := 0
			else
				from current_element := t.first_element
				until current_element = Void
				loop
					if attached current_element then
						if current_element.value = target then
							target_found := true
						end
						if current_element.value = a_value and target_found then
								Result := Result + 1
						end
					end
				current_element := current_element.next
			end
		end
	end

		t_a_value_before_target (a_value, target: INTEGER)
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append(a_value)
			t.append(target)
			t.remove_earliest_following(a_value, target)
			assert("rimosso elemento ma a_value era prima di target", t.has (a_value))
		end

		t_two_elements (a_value, target: INTEGER)
		local
			t: INT_LINKED_LIST
		do
			create t
			t.append(target)
			t.append(a_value)
			t.remove_earliest_following(a_value, target)
			assert("non ha rimosso a_value", not t.has (a_value))
			assert("non ha modificato last_element", attached t.last_element as le and then le.value=target)
		end

		t_a_value_equal_target (a_value: INTEGER)
		local
			t: INT_LINKED_LIST
			count: INTEGER

		do
			create t
			t.append(a_value)
			t.append (3*a_value)
			t.append(a_value)
			count := t.count
			t.remove_earliest_following(a_value, a_value)
			assert("ha eliminato sia il target che a_value", t.count = count - 1 )
			assert("non ha eliminato a_value giusto", attached t.first_element as fe and then fe.value=a_value)
		end

		t_two_a_value (a_value, target: INTEGER)
		local
			t: INT_LINKED_LIST
			old_count, new_count : INTEGER
		do
			create t
			t.append(target)
			t.append (4*a_value)
			t.append(a_value)
			t.append(2*a_value)
			t.append(3*a_value)
			t.append(a_value)
			old_count := how_many_following_a_value_after_target(t, a_value, target)
			t.remove_earliest_following(a_value, target)
			new_count := how_many_following_a_value_after_target(t, a_value, target)
			assert("ha tolto tutti gli a_value", old_count - new_count = 1 )
			assert("ha tolto a_value giusto", attached t.last_element as le implies le.value = a_value)
		end

		remove_earliest_following_tests
		do
			t_a_value_before_target (2, 7)
			t_two_elements (2, 7)
			t_two_a_value (2, 7)
			t_a_value_equal_target (2)
		end

end

