local Game = require('./game')

function love.()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    game = Game.new()
end

function love.draw()

end