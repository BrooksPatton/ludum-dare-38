local Vector = require('./vector')
local json = require('./json')

local EndScreen = {}
EndScreen.__index = EndScreen

function EndScreen.new(lives)
  local t = {}
  setmetatable(t, EndScreen)

  t.titleText = 'Game Over'
  t.titleFont = love.graphics.newFont(42)
  t.titleLoc = Vector.new(275, 30)
  t.titleColor = {255, 255, 255}

  t.lives = lives
  t.winWords = {
    'you won!',
    'you survived!',
    'great job!',
    'you rock!'
  }
  t.loseWords = {
    'you have been terminated',
    'you were squished',
    'a ball fell on you',
    'you were destroyed'
  }

  t.subtitleText = t:selectWords()
  t.subtitleFont = love.graphics.newFont(18)
  t.subtitleLoc = Vector.new(t.titleLoc.x + 20, t.titleLoc.y + 50)
  if t.lives > 0 then
    t.subtitleColor = {100, 255, 100}
  else
    t.subtitleColor = {255, 100, 100}
  end

  t.highScoresText = 'High Scores'
  t.highScoresFont = love.graphics.newFont(24)
  t.highScoresLoc = Vector.new(t.titleLoc.x - 150, t.titleLoc.y + 100)
  t.highScoresColor = {255, 255, 255}
  t.getHighScores = love.thread.newThread('get-high-scores-thread.lua')
  t.getHighScoresChannel = love.thread.getChannel('getAllScores')
  t.getHighScores:start()
  t.highScores = nil
  t.processedHighScores = nil
  t.startText = 'Press return to play again!'
  t.startFont = love.graphics.newFont(24)
  t.inTop = false
  t.postHighScore = love.thread.newThread('post-high-score-thread.lua')
  t.postHighScoreChannel = love.thread.getChannel('postScore')

  t.myScoreText = 'Your Score: ' .. score
  t.myScoreFont = love.graphics.newFont(24)
  t.myScoreLoc = Vector.new(t.highScoresLoc.x + 350, t.highScoresLoc.y + 100)
  t.myScoreColor = {255, 255, 255}

  t.hiScoreText = 'High Score!'
  t.hiScoreFont = love.graphics.newFont(32)
  t.hiScoreLoc = Vector.new(t.myScoreLoc.x, t.myScoreLoc.y + 50)
  t.hiScoreColor = {50, 255, 50}

  t.playText = 'press SPACE to play again'
  t.playFont = love.graphics.newFont(24)
  t.playLoc = Vector.new(t.titleLoc.x - 45, t.titleLoc.y + 450)
  t.playColor = {255, 255, 255}

  return t
end

function EndScreen:draw()
  self:drawSection('title')
  self:drawSection('subtitle')
  self:drawSection('highScores')
  self:drawSection('myScore')
  self:drawSection('play')

  if self.inTop then
    self:drawSection('hiScore')
  end

  if self.highScores then
    self:drawHighScores(self.highScoresLoc)
  end
end

function EndScreen:update()
  if self.highScores and not self.processedHighScores then
    self:checkIfInTop()
    if self.inTop then
      self:sendScoreToServer()
      self.getHighScores:start()
      self.highScores = nil
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

function EndScreen:drawSection(s)
  love.graphics.setColor(self[s .. 'Color'])
  love.graphics.setFont(self[s .. 'Font'])
  love.graphics.print(self[s .. 'Text'], self[s .. 'Loc'].x, self[s .. 'Loc'].y)
end

function EndScreen:selectWords()
  local words

  if self.lives > 0 then
    local length = table.getn(self.winWords)
    words = self.winWords[love.math.random(1, length)]
  else
    local length = table.getn(self.loseWords)
    words = self.loseWords[love.math.random(1, length)]
  end

  return words
end

function EndScreen:drawHighScores(textLoc)
  local highScoresFont = love.graphics.newFont(18)
  local coloredMyScore = false

  for i, v in ipairs(self.highScores) do
    local color = {200, 200, 200}
    local offset = textLoc.y + 10
    offset = offset + i * 30

    local location = Vector.new(textLoc.x + 35, offset)
    local text = i .. '. ' .. v.score

    if v.score == score and not coloredMyScore then
      color = {100, 255, 100}
      coloredMyScore = true
    end

    love.graphics.setColor(color)
    love.graphics.setFont(highScoresFont)
    love.graphics.print(text, location.x, location.y)
  end
end

return EndScreen
