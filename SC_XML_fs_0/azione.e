note
	description: "Summary description for {AZIONE}."
	author: "Gabriele Cacchioni & Davide Canalis & Daniele Fakhoury & Eloisa Scarsella"
	date: "9-04-2015"
	revision: "0"

deferred class
	AZIONE

feature --generica

	action (condizioni: HASH_TABLE [BOOLEAN, STRING])
		deferred
		end

end
