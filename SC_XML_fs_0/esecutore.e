note
	description: "Summary description for {ESECUTORE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ESECUTORE

create
	start

feature {NONE} -- Initialization

	start
	-- Run application.
	local
	--	s: SIMPLE
		s_orig: SIMPLE_MODIFIED
		albero: XML_CALLBACKS_NULL_FILTER_DOCUMENT
	do

		print ("INIZIO!%N")
--			create s.make
--			print ("FINITO 1 !%N")
--			io.read_character
		create s_orig.make
		print ("FINE!%N")
		albero:=s_orig.tree
--		crea_stati(albero)


	end



feature  --attributi
--	conf: CONFIGURAZIONE

	stati: detachable HASH_TABLE[STATO,STRING]
	-- serve durante l'istanziazione iniziale di stati, transizione e configurazione
	-- una volta che è terminata non serve più

--	eventi: HASH_TABLE[STATO,STRING]
	-- serve durante la lettura degli eventi dal file



feature -- cose che si possono fare


	ottieni_evento: STRING --qui ho commentato tutto se no non compilava
--  local
--    evento_letto: STRING
	do
		Result := ""
--  FROM
--    evento_letto := leggi_prossimo_evento (file_eventi)
--  UNTIL
--    evento_letto IN eventi
--  LOOP
--    messaggio_di_errore(evento_letto non è un evento legale)
--    evento_letto := leggi_prossimo_evento (file_eventi)
--  END
--  IF evento_letto IN eventi THEN
--    Result := evento_letto
    end

    evolvi_SC
    do
--  FROM
--  UNTIL
--    conf.stato_corrente.finale
--  LOOP
--    conf.chiusura
--  IF evento_corrente /= "" THEN
--    IF NOT conf.stato_corrente.determinismo(evento_corrente) THEN
--      messaggio_di_errore
--    ELSE
--      conf.stato_corrente := conf.stato_corrente.target(evento_corrente)
    end

--	crea_stati(albero: XML_CALLBACKS_NULL_FILTER_DOCUMENT)
--		--questa feature dovra creare l'hashtable con gli stati istanziati e le transizioni,
--		--anche garantendo che le transizioni hanno target leciti
----		local
----			temp_stato:STATO
----			temp_node:XML_NODE
----			i:INTEGER
----			first:XML_NODE
----			j:INTEGER
--		do
--			first:=albero.document.internal_nodes[0]
--			if attached {XML_ELEMENT} first as f then
--				from
--					i:=0
--				until
--					i=f.internal_nodes.count
--				loop
--					if attached {XML_ELEMENT} f.internal_nodes[i] as k then
--						if k.name~"state" then
--							if attached {XML_ATTRIBUTE} k.internal_nodes[0] as l then
--								create temp_stato.make_with_id(l.value)
--								stati.extend(temp_stato, temp_stato.id)
--							end
--						end
--					end
--					i:=i+1
--				-- qui ci andrebbe un else che stoppa il programma e stampa a video "documento non conforme all'scxml"	
--				end
--			end
----		-- fino a qui crea solo gli stati, senza feature, adesso li riempio e controllo se i target sono validi
--			if attached {XML_ELEMENT} first as f then
--				from
--					i:=0
--				until
--					i=f.internal_node.count
--				loop
--					if attached {XML_ELEMENT} f.internal_nodes[i] as k1 then
--						if k1.name~"state" then
--							if attached {XML_ATTRIBUTE} k1.internal_nodes[0] as mk then
--								stato_temp:=stati[mk.value]
--							end
--							from
--								j:=0
--							until
--								j=k1.internal_nodes.count
--							loop
--								if attached {XML_ELEMENT} k.internal_nodes[j] as u then
--									if u.name~"transition" then
--										create trans
--										from
--											y:=0
--										until
--											y=u.internal_nodes.count
--										loop
--											if attached {XML_ATTRIBUTE} u.internal_nodes[y] as crio then
--												if crio.name~"event" then
--													trans.set_event(crio.value)
--												elseif crio.name~"condizione" then
--													trans.set_condition(crio.value)
--												elseif crio.name~"target" then
--													if stati.has(crio.name) then
--														trans.set_target(stati[crio.value])
--													else
--														print("qui c'è un target che non esiste negli stati")
--														-- CHE FAMO QUINDI?
--													end
--												end
--											end
--											y:=y+1
--										end
--										stato_temp.add_transition(trans)
--									end
----								-- else if se vuoi vedere se è finale o è iniziale lo stato
--								end
--								j:=j+1
--							end
--						end
--						i:=i+1
--					end
--				end
--			end
--		end




-- Aggiungere 'feature' per tracciare quanto accade scrivendo su file model_out.txt:
--la SC costruita dal programma (cioè il file model.xml letto)
--la configurazione iniziale in termini di stato e nomi-valori delle condizioni
--l'evoluzione della SC in termini di sequenza di quintuple:
--stato, evento, condizione, azione, target
end


