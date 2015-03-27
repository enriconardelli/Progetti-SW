note
	description : "sc_xml_flat_simple application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	ROOT

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization
	--prova
	make
			-- Run application.
		local
			s: SIMPLE
			s_orig: SIMPLE_MODIFIED
		do
			--| Add your code here
			print ("INIZIO!%N")
--			create s.make
--			print ("FINITO 1 !%N")
--			io.read_character
			create s_orig.make
			print ("FINE!%N")

		end
--prova fabio
end
