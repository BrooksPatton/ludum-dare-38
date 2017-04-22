local landingScreen = require('./landing-screen')
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
end

function Game:update()
  if self.state == 'landing' then
    local isReturnDown = love.keyboard.isScancodeDown('return')

    if isReturnDown then
      self:nextState()
    end
  end
end

function Game:nextState()
  if self.state == 'landing' then
    self.state = 'game'
  end
end

return Game
