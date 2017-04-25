local http = require('socket.http')

local channel = love.thread.getChannel('postScore')
local score = channel:pop()
local body = 'score=' .. score .. '&code=uywfplgjrstnhxnrbeirsndjuwyflj87w45ge3nhdneistvers'

http.request('https://conquest-game.herokuapp.com/api/v1/high-score', body)
--http.request('http://localhost:3000/api/v1/high-score', body)

love.event.quit(0)
