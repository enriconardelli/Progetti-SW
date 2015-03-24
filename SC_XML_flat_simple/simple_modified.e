note
	description: "[
		Simple application to demonstrate the XML parser
		and build a tree representation using the XML_CALLBACKS_TREE
		then inspect the document in the code.
	]"

class
	SIMPLE_MODIFIED

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		local
			parser: XML_PARSER
			file_name: STRING
			tree: XML_CALLBACKS_TREE
			p: XML_PRETTY_PRINT_FILTER
			f: XML_FORMATTER
			s: STRING
			pp: XML_NODE_PRINTER
		do
			file_name := "test.xml"

				--| Instantiate parser
			create {XML_STANDARD_PARSER} parser.make

				--| Build tree callbacks
			create tree.make_null
			parser.set_callbacks (tree)

				--
				-- CHANGE: Creation instruction uses call to improper feature.
				-- create p.set_next (tree)
				--
			create p.make_with_next (tree)
			p.set_output_standard
			parser.set_callbacks (p)

				--| Parse the `file_name' content
			parser.parse_from_filename (file_name)
			if parser.error_occurred then
				display_parsing_error (parser)
			else
				print ("Parsing succeed. %N")

					--| Get the tree document
				if attached tree.document as doc then
					create f.make
					create s.make (1000)
						--
						-- CHANGE: Unknown class name: XML_STRING_OUTPUT_STREAM
						-- f.set_output (create {XML_STRING_OUTPUT_STREAM}.make (s))
						--
					f.set_output (create {XML_UTF8_STRING_OUTPUT_STREAM}.make (s))
					if attached (create {RAW_FILE}.make ("test_out.xml")) as the_file then
						the_file.create_read_write
						f.set_output (create {XML_FILE_OUTPUT_STREAM}.make (the_file))
						f.process_document (doc)
						f.last_output.flush
						the_file.put_string ("%N---%N")
						the_file.flush
						create pp.make
						pp.set_output (create {XML_FILE_OUTPUT_STREAM}.make (the_file))
						pp.process_document (doc)
						the_file.close
					end
					inspect_node (doc)
				end
			end
		end

feature {NONE} -- Implementation

	display_parsing_error (parser: XML_PARSER)
			-- Display parsing error
		require
			error_occurred: parser.error_occurred
		do
			print ("Error occurred during XML parsing %N")
			if attached parser.error_message as m then
				print ("Error: " + m + "%N")
			end
			if attached parser.error_position as p then
				print ("Position: " + p.out + "%N")
			end
		end

	inspect_node (a_node: XML_NODE)
			-- Inspect `a_node' to display only element and attribute nodes
		local
			n: INTEGER
			offset: STRING
		do
			create offset.make_filled (' ', a_node.level * 2)
			if attached {XML_ELEMENT} a_node as elt then
				print (offset + elt.name)
				print (" (" + elt.attributes.count.out + " attributes)")
				print ("%N")
			elseif attached {XML_ATTRIBUTE} a_node as att then
				print (offset + "# " + att.name)
				print ("%N")
			else
					-- fill if you want to process the character data or comments ...
			end
			if attached {XML_COMPOSITE} a_node as l_composite then
				n := l_composite.count
				from
					l_composite.start
				until
					l_composite.after
				loop
					inspect_node (l_composite.item_for_iteration)
					l_composite.forth
				end
			end
		end

end
