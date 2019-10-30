local ui_button = {
	id = 0,
	label = {},
	state = 'off', -- hovered, pressed, off
	hover_color = {255, 255, 255, 255},
	selected_color = {0, 0, 255, 255}
}
ui_button.__index = ui_button

function ui_button:extend()
  local cls = {}
  for k, v in pairs(self) do
    if k:find("__") == 1 then
      cls[k] = v
    end
  end
  cls.__index = cls
  setmetatable(cls, self)
  return cls
end

function ui_button:new()
	return ui_button:extend()
end

function ui_button:draw()
	if self.state == 'hover' then
		love.graphics.setColor(self.hover_color)
	elseif self.state == 'selected' then
		love.graphics.setColor(self.selected_color)
	else
		love.graphics.setColor(255, 255, 255, 255)
	end

	self.label:draw()
end

return ui_button