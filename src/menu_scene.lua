----> SETTINGS { MUSIC VOL, MASTER VOL, FULLSCREEN, LANGUAGE, RESET}

local menu_scene = {}

local settings = {
	master_volume = 10,
	music_volume = 10,
	sound_volume = 10,
	fullscreen = false,
	language = 'english'
}

hovered_button = 0

function menu_scene:new()
end

function menu_scene:load()
	buttons = {}
	
	title_label = ui_label:new("NBMORSE", m5x7_font, window_width / 2, window_height - (window_height - 130), 8)
	
	local single_btn = ui_button:new()
	single_btn.id = 0
	single_btn.label = ui_label:new("SINGLE", m5x7_font, window_width / 2, window_height - (window_height - 290), 2)
	single_btn.hover_color = {255, 0, 0}
	table.insert(buttons, single_btn)

	local versus_btn = ui_button:new()
	versus_btn.id = 1
	versus_btn.label = ui_label:new("VERSUS", m5x7_font, window_width / 2, window_height - (window_height - 320), 2)
	versus_btn.hover_color = {255, 0, 0}
	table.insert(buttons, versus_btn)
	
	local settings_btn = ui_button:new()
	settings_btn.id = 2
	settings_btn.label = ui_label:new("SETTINGS", m5x7_font, window_width / 2, window_height - (window_height - 350), 2)
	settings_btn.hover_color = {255, 0, 0}
	table.insert(buttons, settings_btn)
	
	local quit_btn = ui_button:new()
	quit_btn.id = 3
	quit_btn.label = ui_label:new("QUIT", m5x7_font, window_width / 2, window_height - (window_height - 380), 2)
	quit_btn.hover_color = {255, 0, 0}
	table.insert(buttons, quit_btn)
	
	hover_button(hovered_button)

	credits_label = ui_label:new("a game by David Sousa and music by Diogo Ribeiro.", m5x7_font, window_width / 2, window_height - 10, 1)
end

function menu_scene:update(dt)
	for i = 1, #buttons do
		local button = buttons[i]
		if button.state == 'selected' then
			if button.id == 0 then
				game_state = 'GAMEPLAY'
				gameplay_scene:load()
			elseif button.id == 3 then
				love.event.quit()
			end

			hover_button(button.id)
		end
	end
end

function menu_scene:draw()
	title_label:draw()
	credits_label:draw()

	for i = 1, #buttons do
		buttons[i]:draw()
	end
end

function menu_scene:keypressed(key)
	if key == 'up' then
		hover_button(hovered_button - 1)
	elseif key == 'down' then
		hover_button(hovered_button + 1)
	elseif key == 'return' then
		select_button(hovered_button)
	end
end

--HELPERS

function hover_button(id)
	buttons[hovered_button + 1].state = 'off'
	hovered_button = (id) % #buttons
	buttons[hovered_button + 1].state = 'hover'
end

function select_button(id)
	buttons[id + 1].state = 'selected'
end

return menu_scene