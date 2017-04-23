local Button = require('./button')
local Vector = require('./vector')

local Landing = {}
Landing.__index = Landing

function Landing.new()
  local t = {}
  setmetatable(t, Landing)


  t.titleText = 'A Very Small Room'
  t.subtitleText = 'It\'s your entire world right now' -- 32 characters
  t.titleFont = love.graphics.newFont(42)
  t.subtitleFont = love.graphics.newFont(16)
  t.startText = 'Press return to begin playing'
  t.startFont = love.graphics.newFont(24)
  t.levelButtons = {}
  t:createLevelButtons(7)

  t:setBorder()

  return t
end


function Landing:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.setFont(self.titleFont)
  love.graphics.print(self.titleText, 200, 150)

  love.graphics.setColor(255, 255, 255)
  love.graphics.setFont(self.subtitleFont)
  love.graphics.print(self.subtitleText, 175, 200)

  love.graphics.setColor(255, 255, 255)
  love.graphics.setFont(self.startFont)
  love.graphics.print(self.startText, 175, 500)

  for i, button in ipairs(self.levelButtons) do
    button:draw(50)
  end
end

function Landing:update()
  local isClick = love.mouse.isDown(1)

  if isClick then
    local x, y = love.mouse.getPosition()

    self:handleClick(x, y)
  end
end

function Landing:createLevelButtons(num)
  for i = 0, num do
    local offset = 100 * i
    offset = offset + i * 15

    local location = Vector.new(offset, 300)
    local button = Button.new(location, 'Level ' .. i + 1, 'white')
    button.value = i + 1

    table.insert(self.levelButtons, button)
  end
end

function Landing:handleClick(x, y)
  for i, button in ipairs(self.levelButtons) do
    if button:clicked(x, y) then
      level = button.value
    end
  end

  self:setBorder()
end

function Landing:setBorder()
  for i, button in ipairs(self.levelButtons) do
    if button.value == level then
      button.selected = true
    else
      button.selected = false
    end
  end
end

return Landing
