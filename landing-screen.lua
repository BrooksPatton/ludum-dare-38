local Button = require('./button')
local Vector = require('./vector')
local Ball = require('./ball')

local Landing = {}
Landing.__index = Landing

function Landing.new()
  local t = {}
  setmetatable(t, Landing)

  t.titleText = 'A Small Room'
  t.titleFont = love.graphics.newFont(42)
  t.titleLoc = Vector.new(250, 30)
  t.titleColor = {255, 255, 255}

  t.subtitleText = 'your entire world is now this room' -- 32 characters
  t.subtitleFont = love.graphics.newFont(16)
  t.subtitleLoc = Vector.new(265, t.titleLoc.y + 50)
  t.subtitleColor = {200, 200, 255}

  t.levelText = 'Choose a level'
  t.levelFont = love.graphics.newFont(24)
  t.levelLoc = Vector.new(50, 175)
  t.levelColor = {255, 255, 255}
  t.levelButtons = {}
  t:createLevelButtons(7, t.levelLoc)

  t.moveText = 'Move'
  t.moveFont = love.graphics.newFont(24)
  t.moveLoc = Vector.new(t.levelLoc.x + 250, t.levelLoc.y)
  t.moveColor = {255, 255, 255}

  t.moveLeftText = 'Left Arrow or "a"'
  t.moveLeftFont = love.graphics.newFont(20)
  t.moveLeftLoc = Vector.new(t.moveLoc.x - 50, t.moveLoc.y + 50)
  t.moveLeftColor = {255, 255, 255}

  t.moveRightText = 'Right Arrow or "d"'
  t.moveRightFont = love.graphics.newFont(20)
  t.moveRightLoc = Vector.new(t.moveLeftLoc.x, t.moveLeftLoc.y + 25)
  t.moveRightColor = {255, 255, 255}

  t.fire1Text = 'Shoot the balls'
  t.fire1Font = love.graphics.newFont(20)
  t.fire1Loc = Vector.new(t.moveLoc.x - 40, t.moveLoc.y + 135)
  t.fire1Color = {255, 200, 200}

  t.fire2Text = 'with the left mouse button'
  t.fire2Font = love.graphics.newFont(20)
  t.fire2Loc = Vector.new(t.fire1Loc.x - 60, t.fire1Loc.y + 20)
  t.fire2Color = {255, 200, 200}

  t.avoidText = 'Avoid the balls'
  t.avoidFont = love.graphics.newFont(20)
  t.avoidLoc = Vector.new(t.moveLoc.x + 250, t.moveLoc.y)
  t.avoidColor = {255, 255, 255}

  local ballLoc = Vector.new(t.avoidLoc.x + 75, t.avoidLoc.y + 175)
  local ballAcceleration = Vector.new(0, 0)
  local ballRadius = 100
  t.ball = Ball.new(ballAcceleration, ballLoc, ballRadius)

  t.startText = 'Press RETURN to start'
  t.startFont = love.graphics.newFont(24)
  t.startLoc = Vector.new(t.titleLoc.x, t.titleLoc.y + 525)
  t.startColor = {255, 255, 255}

  t:setBorder()

  return t
end


function Landing:draw()
  self:drawSection('title')
  self:drawSection('subtitle')
  self:drawSection('level')
  self:drawSection('move')
  self:drawSection('moveLeft')
  self:drawSection('moveRight')
  self:drawSection('fire1')
  self:drawSection('fire2')
  self:drawSection('avoid')
  self:drawSection('start')

  for i, button in ipairs(self.levelButtons) do
    button:draw(50)
  end

  self.ball:draw()
end

function Landing:update()
  local isClick = love.mouse.isDown(1)

  if isClick then
    local x, y = love.mouse.getPosition()

    self:handleClick(x, y)
  end
end

function Landing:createLevelButtons(num, textLoc)
  for i = 0, num - 1 do
    local offset = textLoc.y + 35
    offset = offset + i * 45

    local location = Vector.new(textLoc.x + 35, offset)
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

function Landing:drawSection(s)
  love.graphics.setColor(self[s .. 'Color'])
  love.graphics.setFont(self[s .. 'Font'])
  love.graphics.print(self[s .. 'Text'], self[s .. 'Loc'].x, self[s .. 'Loc'].y)
end

return Landing
