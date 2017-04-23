local Button = {}
Button.__index = Button

function Button.new(location, text, color)
  local t = {}
  setmetatable(t, Button)

  t.location = location
  t.text = text
  t.width = 100
  t.height = 35
  t.selected = false
  t.font = love.graphics.newFont(18)
  t.selectedColor = {255, 0, 0}
  t.selectedLineWidth = 5

  if color == 'white' then
    t.bgColor = {255, 255, 255}
    t.textColor = {0, 0, 0}
  end

  return t
end

function Button:draw()
  love.graphics.setColor(self.bgColor)
  love.graphics.rectangle('fill', self.location.x, self.location.y, self.width, self.height)

  love.graphics.setFont(self.font)
  love.graphics.setColor(self.textColor)
  love.graphics.printf(self.text, self.location.x, self.location.y + self.font:getHeight() / 3, self.width, 'center')

  if self.selected then
    love.graphics.setLineWidth(self.selectedLineWidth)
    love.graphics.setColor(self.selectedColor)
    love.graphics.rectangle('line', self.location.x, self.location.y, self.width, self.height)
  end
end

function Button:clicked(x, y)
  if x > self.location.x and x < self.location.x + self.width and y > self.location.y and y < self.location.y + self.height then
    return true
  end

  return false
end

return Button
