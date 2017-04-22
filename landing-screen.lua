local titleText = 'A Very Small Room'
local subtitleText = 'It\'s your entire world right now'

function drawLanding()
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(titleText, width / 2, height / 2)
end

return drawLanding