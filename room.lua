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
  t.maxBalls = level
  t.ballsCreated = 1
  t.startingBallSize = 100
  t.minBallSize = t.startingBallSize / 4

  t:createBall()

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
      love.audio.play(se.killed1)
      self.player.lives = self.player.lives - 1
    end

    if self.player.bullet then
      if self:didBulletHitBall(ball, self.player.bullet) then
        local destroyedBall = ball

        table.remove(self.balls, i)
        self.player.bullet = nil

        if destroyedBall.radius > self.minBallSize then
          self:createBall(destroyedBall)
        end
      end
    end
  end

  if self:shouldAddBall() then
    self:createBall()
    self.ballsCreated = self.ballsCreated + 1
  end

  self.player:update(dt)
  self.player:checkEdges()
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

function Room:ballsLeft()
  return table.getn(self.balls)
end

function Room:createBall(destroyedBall)
  if destroyedBall then
    local acceleration1 = Vector.new(love.math.random(-30, 30), -20):normalized() * 10
    local acceleration2 = Vector.new(love.math.random(-30, 30), -20):normalized() * 10

    table.insert(self.balls, Ball.new(acceleration1, destroyedBall.location, destroyedBall.radius / 2))
    table.insert(self.balls, Ball.new(acceleration2, destroyedBall.location, destroyedBall.radius / 2))
  else
    local acceleration = Vector.new(30, -50):normalized() * 10
    local location = Vector.new(-50, 0)
    local radius = 100

    table.insert(self.balls, Ball.new(acceleration, location, radius))
  end
end

return Room
