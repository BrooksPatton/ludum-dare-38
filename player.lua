local Vector = require('./vector')

local Player = {}
Player.__index = Player

function Player.new()
  local t = {}
  setmetatable(t, Player)

  t.width = 5
  t.height = 10
  t.speed = 50
  t.location = Vector.new(width / 2 - t.width / 2, height - t.height)
  t.velocity = Vector.new(0, 0)
  t.acceleration = Vector.new(0, 0)
  t.friction = 0.90

  return t
end

function Player:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle('fill', self.location.x, self.location.y, self.width, self.height)
end

function Player:update(dt)
  local isLeftDown = love.keyboard.isScancodeDown('left')
  local isRightDown = love.keyboard.isScancodeDown('right')

  if isLeftDown then
    local move = Vector.new(self.speed * -1, 0)
    self:applyForce(move * dt)
  elseif isRightDown then
    local move = Vector.new(self.speed, 0)
    self:applyForce(move * dt)
  end

  self.velocity = self.velocity + self.acceleration
  self.location = self.location + self.velocity
  self.acceleration = self.acceleration * 0
  self.velocity = self.velocity * self.friction
end

function Player:applyForce(force)
  self.acceleration = self.acceleration + force
end

return Player
