note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	DYNAMIC_TESTS

inherit
	EQA_TEST_SET

feature -- Test routines

	t_insert_before
			-- Verifica la corretta esecuzione degli inserimenti prima del target
	local
		lista_a , lista_b: MY_LINKED_LIST[INTEGER]
	do
		create lista_a
		create lista_b

		lista_a.insert_before (1,0)
		lista_b.insert_before (3,-5)
		-- stato liste:  a = [1], b = [3]

		assert ("insert_before fallisce su lista con zero elementi", lista_a.has(1) and lista_b.has(3))
		assert ("insert_before fallisce su lista con zero elementi", (not lista_a.has(0)) and (not lista_b.has(-5)))
		assert ("insert_before non aggiorna count su lista con zero elementi", (lista_a.count=1) and (lista_b.count=1))

		lista_a.insert_before (-2,1)
		lista_b.insert_before (9,-7)
		-- stato liste: a = [-2,1], b = [9,3]

		assert ("errore: insert_before modifica last_element", (attached lista_a.last_element as l_al implies l_al.value = 1) and (attached lista_b.last_element as l_bl implies l_bl.value = 3))
		assert ("errore: insert_before non aggiorna first_element quando il target è first_element", attached lista_a.first_element as l_af implies l_af.value = -2)

		lista_a.insert_before (3,1)
		lista_b.insert_before (-2,9)
		-- stato liste: a = [-2,3,1], b = [-2,9,3]

		assert ("errore: insert_before non lega il precedente del target all'elemento inserito", attached lista_a.get_element(-2) as l_ag implies (attached l_ag.next as l_agn implies l_agn.value = 3))
		-- il legame tra elemento inserito e target è verificato dall'ensure della feature
		assert ("errore: insert_before distrugge il legame tra target e successivo", attached lista_b.get_element(-2) as l_bg implies (attached l_bg.next as l_bgn implies (attached l_bgn.next as l_bgnn implies l_bgnn.value = 3)))

		lista_a.insert_before (7,0)
		assert ("errore: insert_before fallisce inserimento con target inesistente su lista non vuota", attached lista_a.first_element as l_af implies l_af.value = 7)
		assert ("errore: insert_before con target inesistente su lista non vuota non lega il primo elemento", attached lista_a.first_element as l_af implies (attached l_af.next as l_afn implies l_afn.value = -2))
	end


	t_insert_after
			-- Verifica la corretta esecuzione degli inserimenti dopo il target
	local
		lista_a , lista_b: MY_LINKED_LIST[INTEGER]
	do
		create lista_a
		create lista_b

		lista_a.insert_after (3,-2)
		lista_b.insert_after (0,7)
		-- stato liste:  a = [3], b = [0]

		assert ("insert_after fallisce su lista con zero elementi", lista_a.has(3) and lista_b.has(0))
		assert ("insert_after fallisce su lista con zero elementi", (not lista_a.has(-2)) and (not lista_b.has(7)))
		assert ("insert_after non aggiorna count su lista con zero elementi", (lista_a.count=1) and (lista_b.count=1))

		lista_a.insert_after (-1,3)
		lista_b.insert_after (2,-8)
		-- stato liste: a = [3,-1], b = [0,2]

		assert ("errore: insert_after modifica first_element", (attached lista_a.first_element as l_af implies l_af.value = 3) and (attached lista_b.first_element as l_bf implies l_bf.value = 0))
		assert ("errore: insert_after non aggiorna last_element quando il target è last_element", attached lista_a.last_element as l_al implies l_al.value = -1)

		lista_a.insert_after (5,3)
		lista_b.insert_after (8,2)
		-- stato liste: a = [3,5,-1], b = [0,2,8]

		assert ("errore: insert_after non lega il successivo del target all'elemento inserito", attached lista_a.get_element(5) as l_ag implies (attached l_ag.next as l_agn implies l_agn.value = -1))
		-- il legame tra target e elemento_inserito è verificato dall'ensure della feature
		assert ("errore: insert_after distrugge il legame tra target e precedente", attached lista_b.get_element(0) as l_bg implies (attached l_bg.next as l_bgn implies (attached l_bgn.next as l_bgnn implies l_bgnn.value = 8)))

		lista_a.insert_after (7,6)
		assert ("errore: insert_after fallisce inserimento con target inesistente su lista non vuota", attached lista_a.last_element as l_ag implies l_ag.value = 7)
		assert ("errore: insert_after con target inesistente su lista non vuota non lega il vecchio last_element", attached lista_a.get_element(-1) as l_ag implies (attached l_ag.next as l_agn implies l_agn.value = 7))
	end


	t_invert
			-- Verifica la corretta esecuzione dell'inversione
	local
		lista, lista_copy: MY_LINKED_LIST[INTEGER]
		x,y : MY_LINKABLE[INTEGER]
		c: INTEGER
	do
		create lista
		lista.append(1)
		lista.append(2)
		lista.append(3)
		lista.append(4)
		-- stato liste: lista = [1,2,3,4]

		lista_copy := lista.deep_twin
		-- stato liste: lista = [1,2,3,4],  lista_copy = [1,2,3,4]

		lista.invert
		-- stato liste: lista = [4,3,2,1],  lista_copy = [1,2,3,4]

		from
			c:=0
			x := lista.first_element
		until
			x = Void
		loop
			c:=c+1
			x := x.next
		end
		assert ("errore: invert non mantiene count", (lista.count = c) and (lista.count = lista_copy.count))
		assert ("errore: invert non aggiorna first_element e last_element", (attached lista.first_element as l_f implies l_f.value = 4) and (attached lista.last_element as l_l implies l_l.value = 1))
		assert ("errore: invert non inverte correttamente", (attached lista.first_element as l_f implies (attached l_f.next as l_fn implies l_fn.value = 3) and (attached lista.first_element as lf implies (attached lf.next as lfn implies (attached lfn.next as lfnn implies lfnn.value = 2)))))

		lista.invert
		-- stato liste: lista = [1,2,3,4],  lista_copy = [1,2,3,4]

		assert ("errore: invert due volte perde degli elementi", (lista.count = c) and (lista.count = lista_copy.count))

		from x := lista.first_element  y := lista_copy.first_element
		until (x = Void) or (y = Void)
		loop
			assert ("errore: invert due volte non restituisce la lista originaria", x.value = y.value)
			x:=x.next
			y:=y.next
		end

	end


end


