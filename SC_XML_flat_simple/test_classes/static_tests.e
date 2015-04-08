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
		redefine
			on_prepare
		end

feature -- access

	parser: XML_PARSER

	file_name: STRING

	tree: XML_CALLBACKS_TREE

feature -- preparazione

	on_prepare
		do
			file_name := "test.xml"
				--| Instantiate parser
			create {XML_STANDARD_PARSER} parser.make
				--| Build tree callbacks
			create tree.make_null
			parser.set_callbacks (tree)
				--| Parse the `file_name' content
			parser.parse_from_filename (file_name)
			if parser.error_occurred then
				print ("Parsing error!!! %N")
			else
				print ("Parsing OK. %N")
			end
--			if attached tree.document as doc then
--				print ("Struttura del file XML %N")
--				inspect_node (doc)
--			end
		end

feature -- supporto

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

	root_has_attribute_named (a_name: STRING): BOOLEAN
		local att: LIST [XML_ATTRIBUTE]
		do
			if attached tree.document.root_element as elt then
				att := elt.attributes
				from
					att.start
				until
					att.after
				loop
					if att.item_for_iteration.name ~ a_name then
						Result := true
					end
					att.forth
				end
			end
		end

feature -- Test routines

	t_root_level
		do
			if attached tree.document as doc then
				assert ("il livello della radice NON è 1", doc.level = 1)
			end
		end

	t_root_name
		do
			if attached tree.document.root_element as elt then
				assert ("il nome della radice NON è scxml", elt.name ~ "scxml")
			end
		end

	t_root_attributes_count
		do
			if attached tree.document.root_element as elt then
				assert ("la radice NON ha 3 attributi", elt.attributes.count = 3)
			end
		end

	t_root_children_count
		local
			k: INTEGER
		do
			if attached {XML_COMPOSITE} tree.document.root_element as comp then
				from
					k := 0
					comp.start
				until
					comp.after
				loop
					if attached {XML_ELEMENT} comp.item_for_iteration then
						k := k + 1
					end
					comp.forth
				end
				assert ("la radice NON ha 5 figli", k = 5)
			end
		end

	t_root_attributes
		do
			assert ("la radice NON ha attributo 'xmlns' ", root_has_attribute_named ("xmlns"))
			assert ("la radice NON ha attributo 'version' ", root_has_attribute_named ("version"))
			assert ("la radice NON ha attributo 'initial' ", root_has_attribute_named ("initial"))
		end

	t_root_datamodel_child
		local
			trovato: BOOLEAN
		do
			if attached {XML_COMPOSITE} tree.document.root_element as comp then
				from
					trovato := false
					comp.start
				until
					trovato or else comp.after
				loop
					if attached {XML_ELEMENT} comp.item_for_iteration as item then
						if item.name ~ "datamodel" then
							trovato := true
						end
					end
					comp.forth
				end
				assert ("la radice NON ha il figlio 'datamodel' ", trovato = true)
			end
		end

end
