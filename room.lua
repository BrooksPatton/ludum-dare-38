local Vector = require('./vector')
local Ball = require('./ball')

local Room = {}
Room.__index = Room

function Room.new()
  local t = {}
  setmetatable(t, Room)

  t.shrinkingSpeed = s
  t.location = Vector.new(0, 0)
  t.width = width
  t.height = height
  t.ball = Ball.new()
  t.gravity = Vector.new(0, 30)

  return t
end

function Room:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle('line', self.location.x, self.location.y, self.width, self.height)

  self.ball:draw()
end

function Room:update(dt)
  self.ball:applyForce(self.gravity * dt)
  self.ball:update()
  self.ball:checkEdges()
end

return Room
