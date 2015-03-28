Le classi sono le seguenti


***
### STATO
#### attributi
- id: STRING  
- iniziale: BOOLEAN ???non serve???  
- finale: BOOLEAN  
- transizioni: ARRAY<TRANSIZIONE>  

#### routines
* *determinismo* (evento_corrente: STRING): BOOLEAN  
-- ritorna vero se con evento_corrente è attivabile nella configurazione corrente al più 1 transizione  
-- ritorna falso se con evento_corrente sono attivabili nella configurazione corrente almeno 2 transizioni  

* *target* (evento_corrente: STRING): STATO  
**require** *determinismo* (evento_corrente)  
-- ritorna Void se con evento_corrente nella configurazione corrente non è attivabile alcuna transizione  
-- ritorna lo stato a cui porta l'unica transizione attivabile nella configurazione corrente con evento_corrente

***
### TRANSIZIONE
#### attributi
- evento: STRING
- condizione: STRING
- azione: AZIONE
- target: STATO

***
### deferred AZIONE
#### attributi
- id: STRING

***
### ASSEGNAZIONE
_inherit_ AZIONE
#### attributi
- condizione: STRING
- valore: BOOLEAN

***
### FITTIZIA
_inherit_ AZIONE

***
### CONFIGURAZIONE
#### attributi
- stato_corrente: STATO
- condizioni: HASH_TABLE STRING,BOOLEAN  

#### routines
* *chiusura*  
-- assicura che stato_corrente sia uno stato stabile, eseguendo tutte le transizioni  