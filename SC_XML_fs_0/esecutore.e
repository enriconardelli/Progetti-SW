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
	do

		print ("INIZIO!%N")
--			create s.make
--			print ("FINITO 1 !%N")
--			io.read_character
		create s_orig.make
		print ("FINE!%N")

		--| QUI FABIO E CRISTIANO DEVONO AGGIUNGERE

	end



feature  --attributi
--	conf: CONFIGURAZIONE

--	stati: HASH_TABLE[STATO,STRING]
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




-- Aggiungere 'feature' per tracciare quanto accade scrivendo su file model_out.txt:
--la SC costruita dal programma (cioè il file model.xml letto)
--la configurazione iniziale in termini di stato e nomi-valori delle condizioni
--l'evoluzione della SC in termini di sequenza di quintuple:
--stato, evento, condizione, azione, target
end


