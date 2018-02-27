local white_rook_image = love.graphics.newQuad(64 * 2, 64, 64, 64, pieces_image:getDimensions())
local black_rook_image = love.graphics.newQuad(64 * 2, 0, 64, 64, pieces_image:getDimensions())

local base = require("pieces.base")

local rook = class(base)

function rook:init(board, color, x, y)
    base.init(self, board, color, x, y)

    self.type = "rook"
    self.image = color == "white" and white_rook_image or black_rook_image
end

function rook:can_move(x, y, ignore_king)
    if base.can_move(self, x, y, ignore_king) then
        if x == self.x or y == self.y then
            local board = self.board

            local difference_x = x - self.x
            local difference_y = y - self.y

            local step_x = difference_x > 1 and 1 or -1 
            local step_y = difference_y > 1 and 1 or -1

            for x = 0, difference_x, step_x do
                local piece = board[self.x + x][self.y]

                if piece and piece ~= self then
                    --If we haven't fully traveled along the X axis.
                    if x ~= difference_x then
                        return false
                    end
                end
            end

            for y = 0, difference_y, step_y do
                local piece = board[self.x][self.y + y]

                if piece and piece ~= self then
                    --If we haven't fully traveled along the Y axis.
                    if y ~= difference_y then
                        return false
                    end
                end
            end

            return true
        end

        return false
    end
end

return rook