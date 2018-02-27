pieces_image = love.graphics.newImage("assets/images/pieces.png")

local pieces = {
    pawn = require("pieces.pawn"),
    bishop = require("pieces.bishop"),
    knight = require("pieces.knight"),
    rook = require("pieces.rook"),
    queen = require("pieces.queen"),
    king = require("pieces.king")
}

local board = class()

function board:init()
    self.tile_size = 64
    self.moves = 0
    self.last_piece_moved = nil

    for x = 1, 8 do
        self[x] = {}

        self[x][2] = pieces.pawn:new(self, "black", x, 2)
        self[x][7] = pieces.pawn:new(self, "white", x, 7)
    end

    self[1][1] = pieces.rook:new(self, "black", 1, 1)
    self[2][1] = pieces.knight:new(self, "black", 2, 1)
    self[3][1] = pieces.bishop:new(self, "black", 3, 1)
    self[4][1] = pieces.queen:new(self, "black", 4, 1)
    self[5][1] = pieces.king:new(self, "black", 5, 1)
    self[6][1] = pieces.bishop:new(self, "black", 6, 1)
    self[7][1] = pieces.knight:new(self, "black", 7, 1)
    self[8][1] = pieces.rook:new(self, "black", 8, 1)

    self[1][8] = pieces.rook:new(self, "white", 1, 8)
    self[2][8] = pieces.knight:new(self, "white", 2, 8)
    self[3][8] = pieces.bishop:new(self, "white", 3, 8)
    self[4][8] = pieces.queen:new(self, "white", 4, 8)
    self[5][8] = pieces.king:new(self, "white", 5, 8)
    self[6][8] = pieces.bishop:new(self, "white", 6, 8)
    self[7][8] = pieces.knight:new(self, "white", 7, 8)
    self[8][8] = pieces.rook:new(self, "white", 8, 8)

    for x = 1, 8 do
        for y = 1, 8 do
            local piece = self[x][y]

            if piece then
                if piece.color == "white" then
                    piece.king = self[5][8]
                elseif piece.color == "black" then
                    piece.king = self[5][1]
                end
            end
        end
    end
end

function board:draw(color)
    local tile_w, tile_h = self.tile_size, self.tile_size
    local is_white = false

    local white = {255, 233, 175}
    local black = {83, 124, 73}

    for y = 1, 8 do
        is_white = not is_white

        for x = 1, 8 do
            local tile_x, tile_y = tile_w * (x - 1), tile_h * (y - 1)

            love.graphics.setColor(is_white and white or black)
            love.graphics.rectangle("fill", tile_x, tile_y, tile_w, tile_h)

            love.graphics.setColor(black)
            love.graphics.rectangle("line", tile_x, tile_y, tile_w, tile_h)

            is_white = not is_white
        end
    end

    --Seperate for loop because otherwise squares will render over drawn moves

    for x = 1, 8 do
        for y = 1, 8 do
            local piece = self[x][y]

            if piece then
                piece:draw(color)
            end
        end
    end
end

return board