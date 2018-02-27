local white_knight_image = love.graphics.newQuad(64 * 4, 64, 64, 64, pieces_image:getDimensions())
local black_knight_image = love.graphics.newQuad(64 * 4, 0, 64, 64, pieces_image:getDimensions())

local base = require("pieces.base")

local knight = class(base)

function knight:init(board, color, x, y)
    base.init(self, board, color, x, y)

    self.type = "knight"
    self.image = color == "white" and white_knight_image or black_knight_image
end

function knight:can_move(x, y, ignore_king)
    if base.can_move(self, x, y, ignore_king) then
        local difference_x = math.abs(x - self.x)
        local difference_y = math.abs(y - self.y)

        if difference_x == 1 and difference_y == 2 or difference_x == 2 and difference_y == 1 then
            return true
        end
    end

    return false
end

return knight