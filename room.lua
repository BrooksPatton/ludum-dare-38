local Vector = require('./vector')
local Ball = require('./ball')
local Player = require('./player')

local Room = {}
Room.__index = Room

function Room.new()
  local t = {}
  setmetatable(t, Room)

  t.shrinkingSpeed = s
  t.location = Vector.new(0, 0)
  t.width = width
  t.height = height
  t.balls = {}
  t.gravity = Vector.new(0, 30)
  t.player = Player.new()
  t.timeBallLastAdded = love.timer.getTime()
  t.maxBalls = 5
  t.ballsCreated = 0

  return t
end

function Room:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle('line', self.location.x, self.location.y, self.width, self.height)

  for i, ball in ipairs(self.balls) do
    ball:draw()
  end

  self.player:draw()
end

function Room:update(dt)
  for i, ball in ipairs(self.balls) do
    ball:applyForce(self.gravity * dt)
    ball:update()
    ball:checkEdges()

    local playerHit = self.player:isHitByBall(ball)
    if playerHit and self.player.lives > 0 then
      self.player.lives = self.player.lives - 1
    end

    if self.player.bullet then
      if self:didBulletHitBall(ball, self.player.bullet) then
        table.remove(self.balls, i)
      end
    end
  end

  if self:shouldAddBall() then
    table.insert(self.balls, Ball.new())
    self.ballsCreated = self.ballsCreated + 1
  end

  self.player:update(dt)
end

function Room:didBulletHitBall(ball, bullet)
  local dist = ball.location:dist(bullet.location)

  if dist < ball.radius then
    return true
  end

  return false
end

function Room:shouldAddBall()
  local newTime = love.timer.getTime()
  local delta = newTime - self.timeBallLastAdded

  if delta >= 1 and self.ballsCreated < self.maxBalls then
    self.timeBallLastAdded = newTime
    return true
  end

  return false
end

return Room
