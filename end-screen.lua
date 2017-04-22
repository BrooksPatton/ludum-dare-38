local titleText = 'Game Over'
local subtitleText = 'You got squised' -- 32 characters
local titleFont = love.graphics.newFont(42)
local subtitleFont = love.graphics.newFont(16)
local startText = 'Press return to play again!'
local startFont = love.graphics.newFont(24)

function drawEnd()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(titleFont)
    love.graphics.print(titleText, 200, 150)

    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(subtitleFont)
    love.graphics.print(subtitleText, 175, 200)

    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(startFont)
    love.graphics.print(startText, 175, 500)
end

return drawEnd
