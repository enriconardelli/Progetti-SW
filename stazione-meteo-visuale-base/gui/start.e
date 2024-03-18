note
	description: "Entry point of the sample introducing the notion of event type and illustrating the Eiffel Event library."
	date: "$Date: 2003/01/31"
	revision: "$Revision: 1.0"
	author: "Volkan Arslan"
	institute: "Chair of Software Engineering, ETH Zurich, Switzerland"

class
	START

create
	make

feature -- Initialization

	make
			-- Create and launch the application.
		local
			application: EV_APPLICATION
			main_window: MAIN_WINDOW
		do
			create application
			default_create

			create main_window
			main_window.show
			application.launch
		end

end -- class START
