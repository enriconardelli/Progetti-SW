note
	description: "Representation of a GUI window subscribed to the publisher (class SENSOR)."
--	note: "Subscribed class"
	see_also: "Class SENSOR: the publisher"
	date: "$Date: 2003/01/31"
	revision: "$Revision: 1.0"
	author: "Volkan Arslan"
	institute: "Chair of Software Engineering, ETH Zurich, Switzerland"

class
	APPLICATION_WINDOW

inherit
	EV_TITLED_WINDOW
		redefine
			initialize,
			is_in_default_state
		end

create
	default_create

feature {NONE}-- Initialization

	initialize
			-- Build the interface of this window.
		do
			Precursor {EV_TITLED_WINDOW}
			set_size (Window_width, Window_height)
			build_widgets
			disable_user_resize
		ensure then
			window_size_set: width = Window_width and height = Window_height
		end

feature -- Display update

	display_temperature (a_temperature: INTEGER)
			-- Update the text of `temperature_value_label' with `a_temperature'.
		do
			if a_temperature /= 0  then
				temperature_value_label.set_text (a_temperature.out)
			else
				temperature_value_label.set_text (Dash)
			end
		ensure
			no_temperature_displayed: a_temperature = 0 implies temperature_value_label.text.is_equal (Dash)
			temperature_displayed: a_temperature /= 0 implies temperature_value_label.text.is_equal (a_temperature.out)
		end

	display_humidity (a_humidity: INTEGER)
			-- Update the text of `humidity_value_label' with `a_humidity'.
		do
			if a_humidity /= 0 then
				humidity_value_label.set_text (a_humidity.out)
			else
				humidity_value_label.set_text ("-")
			end
		ensure
			no_humidity_displayed: a_humidity = 0 implies humidity_value_label.text.is_equal (Dash)
			humidity_displayed: a_humidity /= 0 implies humidity_value_label.text.is_equal (a_humidity.out)
		end

	display_pressure (a_pressure: INTEGER)
			-- Update the text of `pressure_value_label' with `a_pressure'.	
		do
			if a_pressure /= 0 then
				pressure_value_label.set_text (a_pressure.out)
			else
				pressure_value_label.set_text ("-")
			end
		ensure
			no_pressure_displayed: a_pressure = 0 implies pressure_value_label.text.is_equal (Dash)
			pressure_displayed: a_pressure /= 0 implies pressure_value_label.text.is_equal (a_pressure.out)
		end

	reset_widget
			-- Delete text of all widgets.
		do
			temperature_value_label.set_text ("-")
			humidity_value_label.set_text ("-")
			pressure_value_label.set_text ("-")
		ensure
			labels_resetted: temperature_value_label.text.is_equal (Dash) and humidity_value_label.text.is_equal (Dash) and pressure_value_label.text.is_equal (Dash)
		end

feature {NONE} -- Implementation GUI

	build_widgets
			-- Build GUI elements.
		do
			create enclosing_box
			extend (enclosing_box)
			build_temperature_widgets
			build_humidity_widgets
			build_pressure_widgets
		end

	build_temperature_widgets
			-- Build the widgets for temperature
		require
			enclosing_box_not_void: enclosing_box /= Void
		do
			create temperature_label
			temperature_label.set_text ("Temperature:")
			temperature_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 0, 0))
			temperature_label.set_font (internal_font)

			enclosing_box.extend (temperature_label)
			enclosing_box.set_item_x_position (temperature_label, 10)
			enclosing_box.set_item_y_position (temperature_label, 20)

			create temperature_value_label
			temperature_value_label.set_text ("-")
			temperature_value_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 0, 0))
			temperature_value_label.set_font (internal_font)

			enclosing_box.extend (temperature_value_label)
			enclosing_box.set_item_x_position (temperature_value_label, 250)
			enclosing_box.set_item_y_position (temperature_value_label, 20)
		end

	build_humidity_widgets
			-- Build the widgets for humidity
		require
			enclosing_box_not_void: enclosing_box /= Void
		do
			create humidity_label
			humidity_label.set_text ("Humidity:")
			humidity_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 255))
			humidity_label.set_font (internal_font)

			enclosing_box.extend (humidity_label)
			enclosing_box.set_item_x_position (humidity_label, 10)
			enclosing_box.set_item_y_position (humidity_label, 100)

			create humidity_value_label
			humidity_value_label.set_text ("-")
			humidity_value_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 255))
			humidity_value_label.set_font (internal_font)

			enclosing_box.extend (humidity_value_label)
			enclosing_box.set_item_x_position (humidity_value_label, 250)
			enclosing_box.set_item_y_position (humidity_value_label, 100)
		end

	build_pressure_widgets
			-- Build the widgets for pressure
		require
			enclosing_box_not_void: enclosing_box /= Void
		do
			create pressure_label
			pressure_label.set_text ("Pressure")
			pressure_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 255, 0))
			pressure_label.set_font (internal_font)

			enclosing_box.extend (pressure_label)
			enclosing_box.set_item_x_position (pressure_label, 10)
			enclosing_box.set_item_y_position (pressure_label, 180)

			create pressure_value_label
			pressure_value_label.set_text ("-")
			pressure_value_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 255, 0))
			pressure_value_label.set_font (internal_font)

			enclosing_box.extend (pressure_value_label)
			enclosing_box.set_item_x_position (pressure_value_label, 250)
			enclosing_box.set_item_y_position (pressure_value_label, 180)
		end

feature {NONE} -- Contract checking

	is_in_default_state: BOOLEAN
		do
			Result := True
		end

feature {NONE} -- Implementation widgets

	enclosing_box: EV_FIXED
			-- Invisible Primitives Container

	temperature_label: EV_LABEL
			-- Temperature label

	humidity_label: EV_LABEL
			-- Humidity label

	pressure_label: EV_LABEL
			-- Pressure label

	temperature_value_label: EV_LABEL
			-- Temperature value label

	humidity_value_label: EV_LABEL
			-- Humidity value label

	pressure_value_label: EV_LABEL
			-- Pressure value label	

feature {NONE} -- Implementation Constants	

	Window_width: INTEGER = 400

	Window_height: INTEGER = 300

	Font_size_height: INTEGER = 26

	Dash: STRING = "-"

	internal_font: EV_FONT
			-- Internal font used by various widgets
		once
			create Result.make_with_values ({EV_FONT_CONSTANTS}.Family_sans, {EV_FONT_CONSTANTS}.Weight_regular, {EV_FONT_CONSTANTS}.Shape_regular, Font_size_height)
		ensure
			internal_font_created: Result /= Void
			font_family_set_to_family_sans: Result.family = {EV_FONT_CONSTANTS}.Family_sans
			font_weight_set_to_weight_regular: Result.weight = {EV_FONT_CONSTANTS}.Weight_regular
			font_shape_set_to_shape_regular: Result.shape = {EV_FONT_CONSTANTS}.Shape_regular
			font_height_set_to_font_size_height: Result.height = Font_size_height
		end

end -- class APPLICATION_WINDOW

