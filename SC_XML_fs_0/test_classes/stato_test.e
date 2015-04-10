note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	STATO_TEST

inherit

	EQA_TEST_SET
		redefine
			on_prepare
		end

feature {NONE} -- Supporto

	stato_prova: detachable STATO

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
				--			assert ("not_implemented", False)
		end

feature -- Test routines

	t_stato_make_with_id
		do
			create stato_prova.make_with_id ("stato_prova")
			if attached stato_prova as sp then
				assert ("id NON è 'stato_prova'", sp.id ~ "stato_prova")
				assert ("final NON è 'false'", not sp.finale)
			end
		end

	t_stato_set_final
		do
			create stato_prova.make_with_id ("stato_prova")
			if attached stato_prova as sp then
				sp.set_final
				assert ("final NON è 'true'", sp.finale)
			end
		end

end
