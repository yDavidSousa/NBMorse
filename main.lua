require 'src/TEsound'
gameplay_scene = require 'src/gameplay_scene'
menu_scene = require 'src/menu_scene'
loading_scene = require 'src/loading_scene'
ui_button = require 'src/ui_button'
ui_label = require 'src/ui_label'

game_state = 'MENU'
main_canvas = {}

function love.load()
	love.graphics.setDefaultFilter('nearest')
	love.graphics.setLineStyle('rough')

	m5x7_font = love.graphics.newFont("content/fonts/m5x7.ttf", 16)

	if game_state == 'MENU' then
		menu_scene:load()
	elseif game_state == 'GAMEPLAY' then
		gameplay_scene:load()
	end
	
	resize(2)
	main_canvas = love.graphics.newCanvas(window_width, window_height)
end

function love.update(dt)
	if game_state == 'MENU' then
		menu_scene:update(dt)
	elseif game_state == 'GAMEPLAY' then
		gameplay_scene:update(dt)
	end

	TEsound.cleanup()
end

function love.keypressed(key)
	if game_state == 'MENU' then
		menu_scene:keypressed(key)
	elseif game_state == 'GAMEPLAY' then
		gameplay_scene:keypressed(key)
	end

	if key == 'f1' then
		game_state = 'MENU'
		menu_scene:load()
	elseif key == 'f2' then
		game_state = 'GAMEPLAY'
		gameplay_scene:load()
	end
end

function love.keyreleased(key)
	if game_state == 'MENU' then
	elseif game_state == 'GAMEPLAY' then
		gameplay_scene:keyreleased(key)
	end
end

function love.draw()

	love.graphics.setCanvas(main_canvas)
	love.graphics.clear()

	if game_state == 'MENU' then
		menu_scene:draw()
	elseif game_state == 'GAMEPLAY' then
		gameplay_scene:draw()
	end

	love.graphics.setCanvas()

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setBlendMode('alpha', 'premultiplied')
	love.graphics.draw(main_canvas, 0, 0, 0, scale_x, scale_y)
	love.graphics.setBlendMode('alpha')
end

function resize(scale)
	love.window.setMode(window_width * scale, window_height * scale)
	scale_x, scale_y = scale, scale;
end

function switch_scene(current_scene, next_scene)

end