note
	description: "Summary description for {EVENTI_ESTERNI}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AMBIENTE

feature

	eventi_esterni: detachable ARRAY [LINKED_SET [STRING]]
			-- memorizza gli eventi letti dal file
			-- l'array rappresenta gli istanti mentre ogni hash_table l'insieme degli eventi che occorrono nell'istante specifico

	acquisisci_eventi (nome_file_eventi: STRING)
			-- Legge gli eventi dal file passato come secondo argomento e li inserisce in `eventi_esterni'

		local
			file: PLAIN_TEXT_FILE
			i: INTEGER
			events_read: LIST [STRING]
			istante: LINKED_SET [STRING]
		do
			create file.make_open_read (nome_file_eventi)
			from
				i := 1
			until
				file.off
			loop
				file.read_line
				events_read := file.last_string.twin.split (' ')
				create istante.make
				istante.compare_objects
				across
					events_read as er
				loop
					istante.force (er.item)
				end
				if attached eventi_esterni as ee then
					ee.force (istante, i)
				end
				i := i + 1
			end
			file.close
		end

end
