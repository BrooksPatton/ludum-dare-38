local Game = require('./game')

function love.load()
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  game = Game.new()
end

function love.draw()
  game:draw()
end

function love.update(dt)
  dt = math.min(0.029, dt)

  game:update(dt)
end
