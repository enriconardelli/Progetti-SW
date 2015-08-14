CONTROLLO DELLA SINTASSI SCxml

I controlli non vengono eseguiti su tutti gli elementi del file xml, ma solo su quegli elementi che seguono le specifiche sottostanti. Questo vuol dire che se esiste un figlio di <scxml> chiamato "Anghelli",
i nostri controlli ignoreranno lui e tutti i suoi discendenti, anche se questi fossero degli state delle transizioni ecc... Questo perche altrimenti non sarebbe possibile espandere il programma, e soprattutto 
perche altrimenti dovremmo controllare anche molti costrutti dell'scxml che chiaramente esulano dagli scopi del corso (controllo della correttezza sintattica di una chiamata al database di un server!).
Se un file scxml passa i nostri controlli noi assicuriamo le seguenti cose
1) <?xml>
	ATTRIBUTI
		C'è versione="1.0"


2) <scxml>

	ATTRIBUTI
		C'è xmlns="http://www.w3.org/2005/07/scxml".
		C'è version="1.0".
		C'è initial, ed è uguale ad uno degli stati.
	
	

	FIGLI
		C'è almeno uno tra state parallel e final.
		C'è al massimo un datamodel.


3) <data> (controlliamo solo i data figli di datamodel, a sua volta figlio di scxml)
	ATTRIBUTI
		C'è l'id ed è unico (tra i data ovviamente)
		C'è al massimo uno solo tra src e expr


4) <state> (controlliamo solo quelli che sono figli di state parallel o scxml)

	ATTRIBUTI
		C'è l'id ed è unico
		Se c'è initial, allora è un suo figlio diretto.


5) <parallel> (controlliamo solo quelli che sono figli di state parallel o scxml)
	
	ATTRIBUTI
		C'è l'id ed è unico


6) <final> (controlliamo solo quelli che sono figli di state parallel o scxml)
	
	ATTRIBUTI
		C'è l'id ed è unico


7) <transition> (controlliamo solo quelli che sono figli di state o parallel)

	ATTRIBUTI
		C'è almeno uno tra evento condizione e target
		Se c'è il target, allora è uno stato valido (cioè esiste), se non c'è si intende che è una transizione interna		


8) <assign>	(controlliamo solo quelli che sono figli di transition, onentry o onexit)	
	
	ATTRIBUTI
		ATTENZIONE:  a differenza di quanto scritto sul manuale scxml, l'attributo "location" è stato sostituito con "name".
		C'è name ed è valido, cioè esiste un data che ha come id quel name.
		












			