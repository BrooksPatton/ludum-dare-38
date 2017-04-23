--require('./cupid')
local Game = require('./game')

function love.load()
  score = 0
  level = 1

  loadSounds()
  
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

function loadSounds()
  se = {}

  se.ballCreate = love.audio.newSource('sounds/create_ball_01.ogg', 'static')
  se.bounce3 = love.audio.newSource('sounds/bounce_03.ogg', 'static')
  se.fire1 = love.audio.newSource('sounds/fire_01.ogg', 'static')
  se.killed1 = love.audio.newSource('sounds/killed_01.ogg', 'static')
end
