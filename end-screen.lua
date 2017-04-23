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
  t.highScores = nil
  t.processedHighScores = nil
  t.inTop = false
  t.postHighScore = love.thread.newThread('post-high-score-thread.lua')
  t.postHighScoreChannel = love.thread.getChannel('postScore')

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

    if self.inTop then
      love.graphics.print('You are in the top 10!', 50, 200)
    end
end

function EndScreen:update()
  if self.highScores and not self.processedHighScores then
    print('processing high score')
    self:checkIfInTop()
    if self.inTop then
      self:sendScoreToServer()
    end
    self.processedHighScores = true
  elseif not self.highScores then
    local hs = self.getHighScoresChannel:pop()
    if hs then
      self.highScores = json.decode(hs)
    end
  end
end

function EndScreen:checkIfInTop()
  for i, v in ipairs(self.highScores) do
    if v.score < score then
      self.inTop = true
    end
  end
end

function EndScreen:sendScoreToServer()
  self.postHighScoreChannel:push(score)
  self.postHighScore:start()
end

return EndScreen
