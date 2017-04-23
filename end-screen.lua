local json = require('./json')

local EndScreen = {}
EndScreen.__index = EndScreen

function EndScreen.new()
  local t = {}
  setmetatable(t, EndScreen)

  t.titleText = 'Game Over'
  t.subtitleText = 'You got squised' -- 32 characters
  t.titleFont = love.graphics.newFont(42)
  t.subtitleFont = love.graphics.newFont(16)
  t.startText = 'Press return to play again!'
  t.startFont = love.graphics.newFont(24)
  t.getHighScores = love.thread.newThread('get-high-scores-thread.lua')
  t.getHighScoresChannel = love.thread.getChannel('getAllScores')
  
  t.getHighScores:start()

  return t
end

function EndScreen:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(self.titleFont)
    love.graphics.print(self.titleText, 200, 150)

    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(self.subtitleFont)
    love.graphics.print(self.subtitleText, 175, 200)

    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(self.startFont)
    love.graphics.print(self.startText, 175, 500)
end

function EndScreen:update()
  local highScores = self.getHighScoresChannel:pop()
  if highScores then
    self.highScores = json.decode(highScores)
  end
end

return EndScreen
