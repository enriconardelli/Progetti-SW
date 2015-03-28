### ESECUTORE
La classe radice (ESECUTORE) dell'applicazione ha la struttura descritta nel seguito.

#### attributi
conf: CONFIGURAZIONE

stati: HASH_TABLE\<STRING,STATO\>  
-- serve durante l'istanziazione iniziale di stati, transizione e configurazione  
-- una volta che è terminata non serve più  

eventi: HASH_TABLE\<STRING,EVENTO\>  
-- serve durante la lettura degli eventi dal file  

#### routines
La feature di creazione (_start_) di ESECUTORE
- legge file SCXML facendone il parsing e creando l'albero che rappresenta la struttura XML
- visita l'albero XML istanziando stati, transizione e configurazione e segnalando i seguenti errori:
  - transizioni il cui target non è l'id di alcuno state
  - transizioni la cui condizione non è l'id di alcun data
  - azioni di assegnazione la cui condizione non è l'id di alcun data
- eventuali ulteriori verifiche statiche (da decidere quali saranno)
- esegue l'evoluzione della SC letta sulla base degli eventi nel file _eventi.txt_

La feature _ottieni_evento_ serve per filtrare eventuali eventi ignoti

	ottieni_evento: STRING
	  local
	    evento_letto: STRING
	  Result := ""
	  FROM
	    evento_letto := leggi_prossimo_evento (file_eventi)
	  UNTIL
	    evento_letto IN eventi
	  LOOP
	    messaggio_di_errore(evento_letto non è un evento legale)
	    evento_letto := leggi_prossimo_evento (file_eventi)
	  END
	  IF evento_letto IN eventi THEN
	    Result := evento_letto

**NB** _va fatta la gestione della fine del file durante la lettura_

La feature _evolvi_SC_ serve per far percorrere alla SC la sequenza di stati determinata dagli eventi nel file _eventi.txt_

	evolvi_SC
	  FROM
	  UNTIL
	    conf.stato_corrente.finale
	  LOOP
	    conf.chiusura
	  IF evento_corrente /= "" THEN
	    IF NOT conf.stato_corrente.determinismo(evento_corrente) THEN
	      messaggio_di_errore
	    ELSE
	      conf.stato_corrente := conf.stato_corrente.target(evento_corrente)

Aggiungere feature per tracciare quanto accade scrivendo su file _model_out.txt_:
- la SC costruita dal programma (cioè il file _model.xml_ letto)
- la configurazione iniziale in termini di stato e nomi-valori delle condizioni
- l'evoluzione della SC in termini di sequenza di quintuple:
  -  stato, evento, condizione, azione, target
