local landingScreen = require('./landing-screen')
local endScreen = require('./end-screen')
local Room = require('./room')
local Ball = require('./ball')

local Game = {}

Game.__index = Game

function Game.new()
  local t = {}
  setmetatable(t, Game)

  t.state = 'landing'
  t.isPlaying = true
  t.lives = 1
  t.score = 0
  t.level = 0
  t.room = Room.new(30)

  return t
end

function Game:draw()
  if self.state == 'landing' then
    landingScreen()
  end

  if self.state == 'game' then
    self.room:draw()
  end

  if self.state == 'end' then
    endScreen()
  end
end

function Game:update(dt)
  if self.state == 'landing' then
    local isReturnDown = love.keyboard.isScancodeDown('return')

    if isReturnDown then
      self:nextState()
    end
  end

  if self.state == 'game' then
    if self.isPlaying then
      self.room:update(dt)
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
