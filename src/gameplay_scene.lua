local gameplay_scene = {}

gameplay_canvas = {}
cell_size = { w = 32, h = 32 }

water_color = {0, 0, 255}
water_shooting_color = {222, 222, 222}
ship_shooting_color = {255, 0, 0}
white_color = {255, 255, 255}
green_color = {0, 255, 0}
yellow_color = {226, 255, 73}

board_letters = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'}
board_numbers = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }

international_morse_code = { 
	["·-"] = 'A', 
	["-···"] = 'B', 
	["-·-·"] = 'C', 
	["-··"] = 'D', 
	["·"] = 'E', 
	["··-·"] = 'F', 
	["--·"] = 'G', 
	["····"] = 'H', 
	["··"] = 'I', 
	["·---"] = 'J', 
	["-·-"] = 'K', 
	["·-··"] = 'L', 
	["--"] = 'M', 
	["-·"] = 'N', 
	["---"] = 'O', 
	["·--·"] = 'P', 
	["--·-"] = 'Q', 
	["·-·"] = 'R', 
	["···"] = 'S',  
	["-"] = 'T', 
	["··-"] = 'U', 
	["···-"] = 'V', 
	["·--"] = 'W', 
	["-··-"] = 'X',
	["-·--"] = 'Y', 
	["--··"] = 'Z',
	["·----"] = 1, 
	["··---"] = 2,
	["···--"] = 3,
	["····-"] = 4,
	["·····"] = 5,
	["-····"] = 6,
	["--···"] = 7,
	["---··"] = 8,
	["----·"] = 9,
	["-----"] = 0
}

morse_code = {
	unit = 0.2, -- unit value by seconds
	short_signal = 1, -- dit/dot (0)
	long_signal = 3, -- dah/dash (1)
	short_break = 1, --between symbols
	medium_break = 3, --between words
	long_break = 7, --between phrases
	data = "",
	active_counter = 0,
	inactive_counter = 0,
	coding = false
}
turn = 0
letter_index = 1
number_index = 1

function gameplay_scene:new()
end

function gameplay_scene:load()
	-- ENGLAND
	UK_nation = create_nation('ENGLAND', { w = 10, h = 10 }, { x = 30, y = 40 })
	put_ship_in_board(UK_nation, 1, 'horizontal', 5, 9)
	put_ship_in_board(UK_nation, 2, 'vertical', 0, 2)
	put_ship_in_board(UK_nation, 3, 'horizontal', 6, 0)
	put_ship_in_board(UK_nation, 4, 'vertical', 9, 5)
	put_ship_in_board(UK_nation, 5, 'horizontal', 5, 2)
	put_ship_in_board(UK_nation, 6, 'vertical', 3, 0)
	put_ship_in_board(UK_nation, 7, 'vertical', 5, 5)
	put_ship_in_board(UK_nation, 8, 'horizontal', 0, 7)
	put_ship_in_board(UK_nation, 9, 'vertical', 9, 2)
	put_ship_in_board(UK_nation, 10, 'horizontal', 0, 0)
	
	-- GERMANY
	DE_nation = create_nation('GERMANY', { w = 10, h = 10 }, { x = 370, y = 40 })
	put_ship_in_board(DE_nation, 1, 'horizontal', 0, 0)
	put_ship_in_board(DE_nation, 2, 'horizontal', 6, 4)
	put_ship_in_board(DE_nation, 3, 'horizontal', 1, 8)
	put_ship_in_board(DE_nation, 4, 'horizontal', 1, 4)
	put_ship_in_board(DE_nation, 5, 'horizontal', 2, 6)
	put_ship_in_board(DE_nation, 6, 'horizontal', 2, 2)
	put_ship_in_board(DE_nation, 7, 'horizontal', 6, 0)
	put_ship_in_board(DE_nation, 8, 'horizontal', 7, 9)
	put_ship_in_board(DE_nation, 9, 'horizontal', 5, 4)
	put_ship_in_board(DE_nation, 10, 'horizontal', 8, 7)

	-- FONT / TEXT
	text = love.graphics.newText(m5x7_font, {'[ ', green_color, board_letters[letter_index], white_color, ', ', green_color, board_numbers[number_index], white_color,  ' ]'})
    morse_text = love.graphics.newText(m5x7_font, "[  ]")

	--SHADERS
	shader = love.graphics.newShader("content/shaders/CRT-Simple.frag")

	--AUDIOS
    battle_music = love.sound.newSoundData("content/audios/battle-music.wav")
    ship_explosion_audio = love.sound.newSoundData("content/audios/explosion.wav")
    water_explosion_audio = love.sound.newSoundData("content/audios/splash.wav")
    morse_code_audio = love.sound.newSoundData("content/audios/1khz_tone.wav")
    TEsound.playLooping(battle_music, 'playlist', nil, 0.2)

	gameplay_canvas = love.graphics.newCanvas(window_width, window_height)
end

function gameplay_scene:unload()
end

function gameplay_scene:update(dt)
	if morse_code.coding then
		morse_code.active_counter = morse_code.active_counter + dt
	else
		morse_code.inactive_counter = morse_code.inactive_counter + dt
	end

	if morse_code.inactive_counter >= morse_code.medium_break * morse_code.unit then
		convert_morse_code(morse_code.data)
		morse_code.data = ""
	end

	morse_text = love.graphics.newText(m5x7_font, "[ " .. morse_code.data .. " ]")
end

function gameplay_scene:draw()
	love.graphics.setCanvas(gameplay_canvas)
	love.graphics.clear()

		-- ENGLAND
		draw_board(UK_nation, cell_size)
		if turn == 1 then
			draw_ships(UK_nation, cell_size)
		end
		draw_shooting(UK_nation, cell_size)

		-- GERMANY
		draw_board(DE_nation, cell_size)
		if turn == 0 then
			draw_ships(DE_nation, cell_size)
		end
		draw_shooting(DE_nation, cell_size)

    	-- DRAW TARGET LINE
    	love.graphics.setColor(255, 255, 255, 255)
    	local nation = nil
    	if turn == 1 then
    		nation = DE_nation
    	else
    		nation = UK_nation
    	end
    	local cell = nation.shooting_data[letter_index][number_index]
        local cell_x = (number_index - 1) * cell_size.w + nation.offset.x
        local cell_y = (letter_index - 1) * cell_size.h + nation.offset.y
        cell_x = cell_x + cell_size.w / 2
        cell_y = cell_y + cell_size.w / 2
    	love.graphics.line(cell_x - cell_size.w / 2, 0, cell_x - cell_size.w / 2, window_height)
    	love.graphics.line(cell_x + cell_size.w / 2, 0, cell_x + cell_size.w / 2, window_height)
    	love.graphics.line(0, cell_y - cell_size.h / 2, window_width, cell_y - cell_size.h / 2)
    	love.graphics.line(0, cell_y + cell_size.h / 2, window_width, cell_y + cell_size.h / 2)

		-- MORSE CODE TEXT
    	love.graphics.setColor(255, 255, 255, 255)
		local width, height = morse_text:getDimensions()
		love.graphics.draw(morse_text, window_width / 2, window_height - 90, 0, 2, 2, width/2, height/2)

		-- BOARD CELL TEXT
    	love.graphics.setColor(255, 255, 255, 255)
		width, height = text:getDimensions()
    	love.graphics.draw(text, window_width / 2, window_height - 60, 0, 2, 2, width/2, height/2)

	love.graphics.setCanvas()

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setBlendMode('alpha', 'premultiplied')
	love.graphics.setShader(shader)
	love.graphics.draw(gameplay_canvas, 0, 0, 0, scale_x, scale_y)
    love.graphics.setShader()
	love.graphics.setBlendMode('alpha')
end

function gameplay_scene:keypressed(key)
    if key == "return" then
    	if turn == 0 then
    		shoot(UK_nation, number_index, letter_index)
    	else
    		shoot(DE_nation, number_index, letter_index) 
    	end
    end

    if key == "space" then
    	morse_code.coding = true
    	morse_code.inactive_counter = 0
		TEsound.playLooping(morse_code_audio, "sfx", nil, 1)
    end
end

function gameplay_scene:keyreleased(key)
    if key == "space" then
    	if morse_code.active_counter <= morse_code.short_signal * morse_code.unit then
    		morse_code.data = morse_code.data .. '·'
    	elseif morse_code.active_counter <= morse_code.long_signal * morse_code.unit then
    		morse_code.data = morse_code.data .. '-'
    	end

    	morse_code.coding = false
    	morse_code.active_counter = 0
		TEsound.stop("sfx")
    end
end

function create_nation(id, size, offset)
	nation = {}
	nation.team = id
	nation.size = size
	nation.offset = offset
	nation.shooting_data = {}
	for y = 1, nation.size.h do
		nation.shooting_data[y] = {}
	    for x = 1, nation.size.w do
	    	table.insert(nation.shooting_data[y], 0)
	    end
	end
	nation.ships_data = {}
	for y = 1, nation.size.h do
		nation.ships_data[y] = {}
	    for x = 1, nation.size.w do
	    	table.insert(nation.ships_data[y], 0)
	    end
	end
	nation.wrecked_ships = 0
	nation.ships = {}
	create_ship(nation, 'aircraft_carrier', 5)
	create_ship(nation, 'tanker', 4)
	create_ship(nation, 'tanker', 4)
	create_ship(nation, 'destroyer', 3)
	create_ship(nation, 'destroyer', 3)
	create_ship(nation, 'destroyer', 3)
	create_ship(nation, 'submarine', 2)
	create_ship(nation, 'submarine', 2)
	create_ship(nation, 'submarine', 2)
	create_ship(nation, 'submarine', 2)

	return nation
end

function create_ship(nation, type, size)
	local ship = {}
	ship.type = type
	ship.size = size
	ship.direction = 'horizontal'
	ship.destroyed_tiles = 0
	ship.destroyed = false
	ship.tiles = {}
	for i = 1, ship.size do
		table.insert(ship.tiles, {x = -1, y = -1})
	end

	table.insert(nation.ships, ship)
end

function put_ship_in_board(nation, ship_id, direction, x, y)
	local ship = nation.ships[ship_id]
	ship.direction = direction
	if ship.direction == 'horizontal' then
		for i = 1, #ship.tiles do
			local tile = ship.tiles[i];
			tile.x = x + i - 1
			tile.y = y
			nation.ships_data[y + 1][x + i] = ship_id
		end
	elseif ship.direction == 'vertical' then
		for i = 1, #ship.tiles do
			local tile = ship.tiles[i];
			tile.x = x
			tile.y = y + i - 1
			nation.ships_data[y + i][x + 1] = ship_id
		end
	end
end

function shoot(nation, x, y)
	if nation.shooting_data[y][x] == 0 then
		nation.shooting_data[y][x] = 1
		local ship_id = nation.ships_data[y][x]

		if ship_id == 0 then
			turn = (turn + 1) % 2;
			TEsound.play(water_explosion_audio, 'sfx', 1)
		else
			local ship = nation.ships[ship_id]
			ship.destroyed_tiles = ship.destroyed_tiles + 1

			if ship.destroyed_tiles == ship.size then
				ship.destroyed = true
				nation.wrecked_ships = nation.wrecked_ships + 1
			end


    		TEsound.playLooping(ship_explosion_audio, 'sfx', 1)
		end
	else
		print('invalid')
	end
end


function draw_board(nation, cell_size)
	love.graphics.setLineWidth(1)
	love.graphics.setColor(water_color)
	
	for y = 1, nation.size.h do
        for x = 1, nation.size.w do
        	local cell = nation.shooting_data[y][x]
            local cell_x = (x - 1) * cell_size.w + nation.offset.x
            local cell_y = (y - 1) * cell_size.h + nation.offset.y

    		love.graphics.rectangle("line", cell_x, cell_y, cell_size.w, cell_size.h)
        end
	end
end

function draw_shooting(nation, cell_size)
	for y = 1, #nation.shooting_data do
        for x = 1, #nation.shooting_data[y] do
        	local cell = nation.shooting_data[y][x]
            local cell_x = (x - 1) * cell_size.w + nation.offset.x
            local cell_y = (y - 1) * cell_size.h + nation.offset.y

        	if cell == 1 then
        		if nation.ships_data[y][x] == 0 then
        			draw_water_shooting(cell_x, cell_y)
        		else
					draw_ship_shooting(cell_x, cell_y, cell_size, 4)
        		end
        	end
        end
	end
end

function draw_water_shooting(x, y)
	love.graphics.setColor(water_shooting_color)
	love.graphics.circle('fill', x + 16, y + 16, 4)
end

function draw_ship_shooting(x, y, tile_size, offset)
	love.graphics.setColor(ship_shooting_color)

	love.graphics.setLineWidth(3)
	love.graphics.line(x + offset, y + offset, x + tile_size.w - offset, y + tile_size.h - offset)
	love.graphics.line(x + offset, y + tile_size.h - offset, x + tile_size.w - offset, y + offset)

	love.graphics.setLineWidth(1)
	love.graphics.rectangle("line", x, y, tile_size.w, tile_size.h)
end

function draw_ships(nation, cell_size)
	for i = 1,#nation.ships do
		local ship = nation.ships[i]
	    for i = 1, #ship.tiles do
			local tile = ship.tiles[i];
			if tile.x ~= -1 and tile.y ~= -1 then
	        	local x = tile.x * cell_size.w + nation.offset.x
	        	local y = tile.y * cell_size.h + nation.offset.y
				love.graphics.setColor(0, 255, 0)
	    		love.graphics.rectangle("line", x, y, cell_size.w, cell_size.h)
			end
	    end
	end
end

function convert_morse_code(code_data)
	code_data = international_morse_code[code_data]

	if code_data ~= nil then
		if type(code_data) == "number" then
			for i, board_number in ipairs(board_numbers) do
			  if board_number == code_data then
			  	number_index = i
				text:set({'[ ', green_color, board_letters[letter_index], white_color, ', ', green_color, board_numbers[number_index], white_color,  ' ]'})
			  end
			end
		elseif type(code_data) == "string" then
			--board_letters = 
			for i, board_letter in ipairs(board_letters) do
			  if board_letter == code_data then
			  	letter_index = i
				text:set({'[ ', green_color, board_letters[letter_index], white_color, ', ', green_color, board_numbers[number_index], white_color,  ' ]'})
			  end
			end
		end
	end

	return code_data
end

return gameplay_scene