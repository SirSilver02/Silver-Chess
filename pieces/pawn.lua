local white_pawn_image = love.graphics.newQuad(64 * 5, 64, 64, 64, pieces_image:getDimensions())
local black_pawn_image = love.graphics.newQuad(64 * 5, 0, 64, 64, pieces_image:getDimensions())

local base = require("pieces.base")

local pawn = class(base)

function pawn:init(board, color, x, y)
    base.init(self, board, color, x, y)

    self.type = "pawn"
    self.image = color == "white" and white_pawn_image or black_pawn_image
end

function pawn:can_move(x, y, ignore_king)
    if base.can_move(self, x, y, ignore_king) then
        local color = self.color
        local board = self.board
        
        local difference_x = x - self.x
        local difference_y = y - self.y

        local piece_at_square = self.board[x][y]

        --No moving backwards.
        if color == "white" and difference_y > 0 then
            return false
        elseif color == "black" and difference_y < 0 then
            return false
        end

        --No capturing squares with pieces on them.
        if piece_at_square  then
            if math.abs(difference_x) == 1 and math.abs(difference_y) == 1 then
                return true
            else
                return false
            end
        end

        if math.abs(difference_x) > 0 then
            --En passante check
            if math.abs(difference_x) == 1 and math.abs(difference_y) == 1 then
                local adjacent_pawn = self.board[self.x + math.abs(difference_x) / difference_x] and self.board[self.x + math.abs(difference_x) / difference_x][self.y]

                if adjacent_pawn and adjacent_pawn.type == "pawn" and adjacent_pawn.color ~= self.color and adjacent_pawn.moves == 1 and board.last_piece_moved == adjacent_pawn then
                    return true
                else
                    return false
                end
            else
                return false
            end
        end

        if math.abs(difference_y) > 1 then
            --Double forward on first move
            if self.moves == 0 and math.abs(difference_y) == 2 and math.abs(difference_x) == 0 then
                local piece_in_front = board[self.x][self.y + difference_y / 2]
                
                if piece_in_front then
                    return false
                end
            else
                return false
            end
        end

        return true
    end

    return false
end

function pawn:move(x, y)
    if self:can_move(x, y) then
        local difference_x = x - self.x
        local difference_y = y - self.y

        --En passante
        if math.abs(difference_x) == 1 and math.abs(difference_y) == 1 then
            local adjacent_pawn = self.board[self.x + math.abs(difference_x) / difference_x] and self.board[self.x + math.abs(difference_x) / difference_x][self.y]
            local board = self.board

            if adjacent_pawn and adjacent_pawn.type == "pawn" and adjacent_pawn.color ~= self.color and adjacent_pawn.moves == 1 and board.last_piece_moved == adjacent_pawn then
                base.move(self, x, y)
                board[adjacent_pawn.x][adjacent_pawn.y] = nil
            else
                if self.color == "black" and y == 8 then
                    event.run("on_pawn_promoted", x, y)
                elseif self.color == "white" and y == 1 then
                    event.run("on_pawn_promoted", x, y)
                end

                base.move(self, x, y)
            end
        else
            if self.color == "black" and y == 8 then
                event.run("on_pawn_promoted", x, y)
            elseif self.color == "white" and y == 1 then
                event.run("on_pawn_promoted", x, y)
            end

            base.move(self, x, y)
        end
    end
end

return pawn