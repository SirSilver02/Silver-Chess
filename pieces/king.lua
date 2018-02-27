local white_king_image = love.graphics.newQuad(64 * 0, 64, 64, 64, pieces_image:getDimensions())
local black_king_image = love.graphics.newQuad(64 * 0, 0, 64, 64, pieces_image:getDimensions())

local base = require("pieces.base")

local king = class(base)

function king:init(board, color, x, y)
    base.init(self, board, color, x, y)

    self.type = "king"
    self.image = color == "white" and white_king_image or black_king_image
end

function king:can_move(x, y, ignore_king)
    if base.can_move(self, x, y, ignore_king) then
        local board = self.board

        local difference_x = x - self.x
        local difference_y = y - self.y

        --Castling
        if math.abs(difference_x) == 2 and math.abs(difference_y) == 0 then
            if self.moves == 0 then
                if not ignore_king then
                    if self:is_in_check() then
                        return false
                    end
                end

                local rook = board[difference_x > 1 and 8 or 1][self.y]

                if rook and rook.type == "rook" then
                    if rook.moves == 0 and rook.color == self.color then
                        local direction = difference_x > 1 and 1 or -1

                        if self:can_move(self.x + direction, y, ignore_king) then 
                            local board = self.board
                            local piece_at_square = board[self.x + direction][y] 
                            local current_x, current_y = self.x, self.y

                            if piece_at_square then
                                return false
                            end

                            self.x, self.y = self.x + direction, y
                            board[current_x + direction][y] = self
                            board[current_x][current_y] = nil

                            local can_castle = false
            
                            if self:can_move(x, y, ignore_king) then
                                can_castle = true
                            end

                            self.x, self.y = current_x, current_y
                            board[current_x + direction][y] = piece_at_square
                            board[current_x][current_y] = self

                            if can_castle and rook:can_move(self.x + direction, y) then
                                return true
                            end
                        end
                    end
                end
            end
        end

        if math.abs(difference_x) < 2 and math.abs(difference_y) < 2 then
            return true
        end

        return false
    end

    return false
end

function king:is_in_check()
    local enemy_king = nil
    
    for x = 1, 8 do
        for y = 1, 8 do
            local piece = self.board[x][y]

            if piece and piece.color ~= self.color and piece.type ~= "king" then
                enemy_king = enemy_king or piece:get_king()

                if piece:can_move(self.x, self.y, true) then
                    return true
                end
            end
        end
    end

    --Doing it this way prevents a stack overflow. Might be a symptom of a bigger problem.
    if enemy_king and enemy_king:can_move(self.x, self.y, true) then
        return true
    end

    return false
end

function king:move(x, y)
    if self:can_move(x, y) then
        local difference_x = x - self.x

        --castling
        if math.abs(difference_x) == 2 then
            local board = self.board
            local rook = board[difference_x > 1 and 8 or 1][self.y]
            local current_x, current_y = rook.x, rook.y

            base.move(self, x, y)

            rook.x, rook.y = self.x - difference_x / 2, y
            board[rook.x][rook.y] = rook
            board[current_x][current_y] = nil
        else
            base.move(self, x, y)
        end
    end
end

return king