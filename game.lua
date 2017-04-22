local Game = {}
Game.__index = Game

function Game.new()
    local t = {}
    setmetatable(t, Game)

    return t
end

return Game