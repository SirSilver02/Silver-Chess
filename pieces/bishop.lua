local white_bishop_image = love.graphics.newQuad(64 * 3, 64, 64, 64, pieces_image:getDimensions())
local black_bishop_image = love.graphics.newQuad(64 * 3, 0, 64, 64, pieces_image:getDimensions())

local base = require("pieces.base")

local bishop = class(base)

function bishop:init(board, color, x, y)
    base.init(self, board, color, x, y)

    self.type = "bishop"
    self.image = color == "white" and white_bishop_image or black_bishop_image
end

function bishop:can_move(x, y, ignore_king)
    if base.can_move(self, x, y, ignore_king) then
        local difference_x = x - self.x
        local difference_y = y - self.y

        --If we're NOT  moving diagonally
        if math.abs(difference_x) ~= math.abs(difference_y) then
            return false
        end
        
        local x_step = difference_x > 1 and 1 or -1
        local y_step = difference_y > 1 and 1 or -1

        local board = self.board

        for x = 0, difference_x, x_step do
            for y = 0, difference_y, y_step do
                local piece = board[self.x + x][self.y + y]

                if math.abs(x) == math.abs(y) and piece and piece ~= self then
                    --If we haven't fully traveled along the X and Y axis.
                    if x ~= difference_x and y ~= difference_y then
                        return false
                    end
                end
            end
        end

        return true
    end

    return false
end

return bishop