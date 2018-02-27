local white_queen_image = love.graphics.newQuad(64 * 1, 64, 64, 64, pieces_image:getDimensions())
local black_queen_image = love.graphics.newQuad(64 * 1, 0, 64, 64, pieces_image:getDimensions())

local base = require("pieces.base")
local bishop = require("pieces.bishop")
local rook = require("pieces.rook")

local queen = class(base)

function queen:init(board, color, x, y)
    base.init(self, board, color, x, y)

    self.type = "queen"
    self.image = color == "white" and white_queen_image or black_queen_image
end

function queen:can_move(x, y, ignore_king)
    if bishop.can_move(self, x, y, ignore_king) or rook.can_move(self, x, y, ignore_king) then
        return true
    end

    return false
end

return queen