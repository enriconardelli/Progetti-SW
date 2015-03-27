
class
	QUATERNA

inherit
	ARGUMENTS

create
	crea_quaterna

feature -- accesso

	evento: STRING

	condizione: STRING

	azione: STRING

	target: STRING


feature -- creazione

	crea_quaterna
		do
			imposta_evento("")
			imposta_azione("")
			imposta_target("")
			imposta_condizione("")
		end


feature -- modifica

	imposta_evento(s: STRING)
		-- assegna alla feature evento il valore s
		require
			s /= Void
		do
			evento := s
		ensure
			evento = s
		end

	imposta_condizione(s: STRING)
		-- assegna alla feature condizione il valore s
		require
			s /= Void
		do
			condizione := s
		ensure
			condizione = s
		end

	imposta_azione(s: STRING)
		-- assegna alla feature azione il valore s
		require
			s /= Void
		do
			azione := s
		ensure
			azione = s
		end

	imposta_target(s: STRING)
		-- assegna alla feature target il valore s
		require
			s /= Void
		do
			target := s
		ensure
			target = s
		end


feature -- confronto

	uguale(c: QUATERNA): BOOLEAN
		-- Restituisce true se Current e `c' hanno tutti gli attributi uguali
		do
			if evento = c.evento and condizione = c.condizione and azione = c.azione and target = c.target then
				Result := true
			else
				Result := false
			end
		end
end
