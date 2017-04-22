local Vector = require('./vector')
local Bullet = require('./bullet')

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
  t.bullet = nil

  return t
end

function Player:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle('fill', self.location.x, self.location.y, self.width, self.height)

  if self.bullet then
    self.bullet:draw()
  end
end

function Player:update(dt)
  local isLeftDown = love.keyboard.isScancodeDown('left')
  local isRightDown = love.keyboard.isScancodeDown('right')
  local isMouseDown = love.mouse.isDown(1)

  if isLeftDown then
    local move = Vector.new(self.speed * -1, 0)
    self:applyForce(move * dt)
  elseif isRightDown then
    local move = Vector.new(self.speed, 0)
    self:applyForce(move * dt)
  end

  if isMouseDown and not self.bullet then
    local location = self.location:clone()
    local mouseLocation = Vector.new(love.mouse.getX(), love.mouse.getY())
    local direction = mouseLocation - location
    direction = direction:normalized() * 100

    self.bullet = Bullet.new(location)

    self.bullet:applyForce(direction)
  elseif self.bullet then
    if self:isBulletOffScreen() then
      self.bullet = nil
    end
  end

  self.velocity = self.velocity + self.acceleration
  self.location = self.location + self.velocity
  self.acceleration = self.acceleration * 0
  self.velocity = self.velocity * self.friction

  if self.bullet then
    self.bullet:update(dt)
  end
end

function Player:applyForce(force)
  self.acceleration = self.acceleration + force
end

function Player:isBulletOffScreen()
  local x = self.bullet.location.x
  local y = self.bullet.location.y
  local result = false

  if x > width or x < 0 then
    result = true
  end

  if y > height or y < 0 then
    result = true
  end

  return result
end

return Player
