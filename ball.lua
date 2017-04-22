local Vector = require('./vector')

local Ball = {}
Ball.__index = Ball

function Ball.new()
  local t = {}
  setmetatable(t, Ball)

  t.radius = 15
  t.location = Vector.new(0, 0)
  t.velocity = Vector.new(0, 0)
  t.acceleration = Vector.new(10, 0)

  return t
end

function Ball:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.circle('line', self.location.x, self.location.y, self.radius)
end

function Ball:applyForce(force)
  self.acceleration = self.acceleration + force
end

function Ball:update()
  self.velocity = self.velocity + self.acceleration
  self.location = self.location + self.velocity
  self.acceleration = self.acceleration * 0
end

function Ball:checkEdges()
  if self.location.y > height then
    self.location.y = height
    self.velocity.y = self.velocity.y * -1
  elseif self.location.y < 0 then
    self.location.y = 0
    self.velocity.y = self.velocity.y * -1
  end

  if self.location.x > width then
    self.location.x = width
    self.velocity.x = self.velocity.x * -1
  elseif self.location.x < 0 then
    self.location.x = 0
    self.velocity.x = self.velocity.x * -1
  end
end

return Ball
