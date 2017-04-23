local http = require('socket.http')

local channel = love.thread.getChannel('postScore')
local score = channel:pop()
local body = 'score=' .. score

http.request('http://localhost:3000/api/v1/high-score', body)

love.event.quit(0)
