local Vector = require('./vector')

local Bullet = {}
Bullet.__index = Bullet

function Bullet.new(location)
  local t = {}
  setmetatable(t, Bullet)

  t.acceleration = Vector.new(0, 0)
  t.location = location
  t.velocity = Vector.new(0, 0)
  t.speed = 8
  t.size = 2

  love.audio.play(se.fire1)

  return t
end

function Bullet:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.circle('fill', self.location.x, self.location.y, self.size)
end

function Bullet:applyForce(force)
  self.acceleration = self.acceleration + force
end

function Bullet:update(dt)
  self.velocity = self.velocity + self.acceleration * dt
  self.location = self.location + self.velocity * self.speed
  self.acceleration = self.acceleration * 0
end

return Bullet
