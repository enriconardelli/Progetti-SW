L'obiettivo è realizzare un'applicazione Eiffel che legge la specifica di una Statecharts ed esegue gli eventi passati ad essa.  
Nella versione 0 di tale applicazione modelliamo StateCharts che sono semplicemente automi a stati finiti (FSA) cioè senza gerarchia e senza parallelismo.  
Non rappresentiamo né la storia, né i connettori.  

La SC viene rappresentata da un file XML (_model.xml_) scritto secondo il formato di SCXML.  
Eventi, condizioni e azioni sono semplici stringhe alfanumeriche, senza alcun operatore logico di combinazione o modifica.  
Le condizioni rappresentano valori booleani.  
Le azioni sono atomiche (si stampa la stringa) oppure assegnazione a condizioni di vero/falso. 
Non consideriamo alcun evento, condizione, azione, né predefiniti né derivati.

Gli eventi che vengono letti dalla SC per determinare la sua evoluzione sono rappresentati in un file testuale _eventi.txt_, uno per riga.

[Formato del file che rappresenta la SC](Formato-del-file-che-rappresenta-la-SC)

[Specifica delle classi](Specifica-delle-classi)

[Descrizione della classe radice dell'applicazione](La-classe-radice-dell%27applicazione)