local http = require('socket.http')
local Landing = require('./landing-screen')
local EndScreen = require('./end-screen')
local Room = require('./room')
local Ball = require('./ball')

local Game = {}

Game.__index = Game

function Game.new()
  local t = {}
  setmetatable(t, Game)

  t.state = 'landing'
  t.landing = Landing.new()
  t.winOrLose = nil

  return t
end

function Game:draw()
  if self.state == 'landing' then
    self.landing:draw()
  end

  if self.state == 'game' then
    self.room:draw()
    love.graphics.print(score, width - 200, 5)
  end

  if self.state == 'end' then
    self.endScreen:draw()
  end
end

function Game:update(dt)
  if self.state == 'landing' then
    local isReturnDown = love.keyboard.isScancodeDown('return')

    if isReturnDown then
      self:reset()
      self:nextState()
    else
      self.landing:update()
    end
  end

  if self.state == 'game' then
    self.room:update(dt)

    if self.room.player.lives == 0 or self.room:ballsLeft() == 0 then
      local isReturnDown = love.keyboard.isScancodeDown('return')

      if not self.time then
        self.time = love.timer.getTime()
      end
      if love.timer.getTime() - self.time > 3 then
        isReturnDown = true
      end


      if isReturnDown and not self.endScreen then
        self.endScreen = EndScreen.new(self.room.player.lives)
        self:nextState()
      end
    elseif self.room.player.lives > 0 and self.room:ballsLeft() > 0 then
      self:updateScore()
    end
  end

  if self.state == 'end' then
    local isReturnDown = love.keyboard.isScancodeDown('space')

    if isReturnDown then
      self:nextState()
    else
      self.endScreen:update()
    end
  end
end

function Game:nextState()
  if self.state == 'landing' then
    self.state = 'game'
  elseif self.state == 'game' then
    self.state = 'end'
  elseif self.state == 'end' then
    self.state = 'landing'
  end
end

function Game:updateScore()
  local currentTime = love.timer.getTime()
  local delta = currentTime - self.timeSinceLastScore
  
  if delta >= 1 then
    local mod = self.room:ballsLeft()

    score = score + 1 * mod * level
    self.timeSinceLastScore = currentTime
  end
end

function Game:reset()
  self.isPlaying = true
  score = 0
  self.room = Room.new()
  self.timeSinceLastScore = love.timer.getTime()
  self.endScreen = nil
  self.time = nil
end

return Game
