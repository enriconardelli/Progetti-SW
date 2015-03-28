I tag ammessi sono:
- scxml
  - datamodel
    - data
- state
  - transition
- final

In datamodel si rappresentano le condizioni (che sono booleane nella versione 0) ed i loro valori iniziali.  
Gli attributi ammessi sono (+ obbligatorio):
- scxml
  - +xmlns
  - +version
  - initial (se assente il primo elemento state presente nel file è lo stato iniziale)
- data
  - +id
  - +expr
- state
  - +id
- transition
  - event
  - condition
  - target
- final
  - +id