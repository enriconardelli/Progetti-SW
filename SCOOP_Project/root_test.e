note
	description: "SCOOP_Test_Project application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT_TEST

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Test della Print con oggetto in ambiente con librerya SCOOP e Void-Safe
			local
				test: detachable TEST_OBJECT[INTEGER]
		do
			create test.make (5)
			if attached test as t then print (t.value) end
		end

end
