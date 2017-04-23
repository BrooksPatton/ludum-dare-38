local Vector = require('./vector')

local Ball = {}
Ball.__index = Ball

function Ball.new(acceleration, location, radius)
  local t = {}
  setmetatable(t, Ball)

  t.mass = love.math.random(0, 5)
  t.radius = radius
  t.location = location
  t.velocity = Vector.new(0, 0)
  t.acceleration = acceleration
  t.lineWidth = 3

  if t.mass == 0 then
    t.color = {255, 255, 255}
  elseif t.mass == 1 then
    t.color = {255, 255, 0}
  elseif t.mass == 2 then
    t.color = {255, 0, 0}
  elseif t.mass == 3 then
    t.color = {0, 255, 255}
  elseif t.mass == 4 then
    t.color = {0, 0, 150}
  elseif t.mass == 5 then
    t.color = {255, 0, 255}
  end

  return t
end

function Ball:draw()
  love.graphics.setLineWidth(self.lineWidth)
  love.graphics.setColor(self.color)
  love.graphics.circle('line', self.location.x, self.location.y, self.radius)
end

function Ball:applyForce(force)
  local f

  if self.mass == 0 then
    f = force
  else
    f = force / self.mass
  end

  self.acceleration = self.acceleration + f
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
