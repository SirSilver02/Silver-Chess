local move_sound = love.audio.newSource("assets/sounds/move.wav")
move_sound:setVolume(0.1)

local base = class()

function base:init(board, color, x, y)
    self.board = board
    self.color = color
    self.moves = 0 

    self.should_draw_moves = false

    self.x = x
    self.y = y
end

function base:draw_moves(color)
    local tile_size = self.board.tile_size

    love.graphics.setColor(0, 255, 0, 100)

    if color ~= self.color then
        love.graphics.setColor(255, 0, 0, 100)
    end

    for x = 1, 8 do
        for y = 1, 8 do
            if self:can_move(x, y) then
                local x2, y2 = x, y
                
                if color == "black" then
                    x2 = 9 - x2
                    y2 = 9 - y2
                end
                
                love.graphics.rectangle("fill", tile_size * (x2 - 1), tile_size * (y2 - 1), tile_size, tile_size)
            end
        end
    end
end

function base:draw(color)
    local tile_size = self.board.tile_size
    local x, y = self.x, self.y

    if color == "black" then
        x = 9 - x
        y = 9 - y
    end

    if self.image then
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(pieces_image, self.image, tile_size * (x - 1), tile_size * (y - 1))
    else  
        love.graphics.setColor(255, 0, 0)
        love.graphics.rectangle("fill", tile_size * (x - 1), tile_size * (y - 1), tile_size, tile_size)
    end

    if self.should_draw_moves then
        self:draw_moves(color)
    end
end

function base:get_king()
    return self.king
end

function base:can_move(x, y, ignore_king_safety)
    --If the square is the NOT the same as it's current square AND
    --If the file and rank are within the board's dimensions AND
    --If there isn't a same colored piece where we're trying to move AND
    --if king is not in check after move has been made THEN
    --return true else false

    if self.x == x and self.y == y then
        return false
    end
    
    if x >= 1 and x <= 8 then
        if y >= 1 and y <= 8 then
            local board = self.board
            local piece_at_square = board[x][y] 
            local current_x, current_y = self.x, self.y
            local king = self:get_king()

            if piece_at_square then
                if piece_at_square.color == self.color then
                    return false
                end
            end

            if not ignore_king_safety then
                self.x, self.y = x, y
                board[x][y] = self
                board[current_x][current_y] = nil

                local is_safe_for_king = not king:is_in_check()

                self.x, self.y = current_x, current_y
                board[x][y] = piece_at_square
                board[current_x][current_y] = self
                
                if not is_safe_for_king then
                    return false
                end
            end

            return true
        end
    end
end

function base:move(x, y)
    if self:can_move(x, y) then
        local board = self.board
        local current_x, current_y = self.x, self.y

        if board.moves % 2 == 0 and self.color == "black" then
            return
        end
    
        if board.moves % 2 == 1 and self.color == "white" then
            return
        end
    
        self.x, self.y = x, y
        board[x][y] = self
        board[current_x][current_y] = nil

        self.moves = self.moves + 1

        board.last_piece_moved = self
        board.moves = board.moves + 1
        move_sound:play()
    end
end

return base