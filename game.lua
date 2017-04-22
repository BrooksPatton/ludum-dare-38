local landingScreen = require('./landing-screen')
local endScreen = require('./end-screen')
local Game = {}

Game.__index = Game

function Game.new()
  local t = {}
  setmetatable(t, Game)

  t.state = 'landing'
  t.score = 0

  return t
end

function Game:draw()
  if self.state == 'landing' then
    landingScreen()
  end

  if self.state == 'end' then
    endScreen()
  end
end

function Game:update()
  if self.state == 'landing' then
    local isReturnDown = love.keyboard.isScancodeDown('return')

    if isReturnDown then
      self:nextState()
    end
  end

  if self.state == 'game' then
    local isReturnDown = love.keyboard.isScancodeDown('space')

    if isReturnDown then
      self:nextState()
    end
  end
end

function Game:nextState()
  if self.state == 'landing' then
    self.state = 'game'
  elseif self.state == 'game' then
    self.state = 'end'
  end
end

return Game
