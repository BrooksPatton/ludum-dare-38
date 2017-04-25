local http = require('socket.http')

  local result = http.request('https://conquest-game.herokuapp.com/api/v1/high-score')
  --local result = http.request('http://localhost:3000/api/v1/high-score')
  local channel = love.thread.getChannel('getAllScores')
  channel:push(result)
love.event.quit(0)
