local ui_label = {
	text = {},
	x = 0, y = 0,
	scale_x = 0, scale_y = 0,
	width = 0, height = 0,
	offset_x = 0, offset_y = 0
}
ui_label.__index = ui_label

function ui_label:extend()
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

function ui_label:new()
end

function ui_label:new(text, font, x, y, scale)
	local cls = ui_label:extend()
	cls.x = x
	cls.y = y
	cls.scale_x = scale
	cls.scale_y = scale
	cls.text = love.graphics.newText(font, text)
	cls.width, cls.height = cls.text:getDimensions()
	cls.offset_x = cls.width / 2
	cls.offset_y = cls.height / 2
	return cls
end

function ui_label:draw()
	love.graphics.draw(self.text, self.x, self.y, 0, self.scale_x, self.scale_y, self.offset_x, self.offset_y)
end

return ui_label