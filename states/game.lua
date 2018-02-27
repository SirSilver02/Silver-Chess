local board = require("board")

local state = {}

function state:on_first_enter()
    local center_panel_func = function(this)
        local children = this:get_children()
        local height = #children * children[1]:get_height()

        this:set_height(height)
        this.y = this:get_parent():get_height() / 2 - height / 2
    end

    self.background_panel = self.ui_manager:add("panel")
    self.background_panel:dock(FILL)

    local escape_panel = self.background_panel:add("panel")
    escape_panel:set_dock_margin(200, 0, 200, 0)
    escape_panel:dock(FILL)

    escape_panel:add_hook("on_validate", "resize", center_panel_func)

        local disconnect_button = escape_panel:add("button")
        disconnect_button:set_text("Disconnect")
        disconnect_button:dock(TOP)

        disconnect_button:add_hook("on_clicked", "disconnect", function(this)
            states.set_current_state("main_menu")
        end)

        local quit_button = escape_panel:add("button")
        quit_button:set_text("Quit")
        quit_button:dock(TOP)

        quit_button:add_hook("on_clicked", "quit", function(this)
            love.event.quit()
        end)

    event.add("on_move", "thing", function(current_x, current_y, x, y)
        self.client:send("piece_moved", {
            current_x, 
            current_y, 
            x, 
            y
        })
    end)

    event.add("on_move_received", "thing", function(current_x, current_y, x, y)
        self.board[current_x][current_y]:move(x, y)

        if not love.window.hasFocus() then
            love.window.requestAttention(true)
        end
    end)

    event.add("on_color_received", "assign_color", function(color)
        self.color = color
    end)

    event.add("on_pawn_promoted", "promote_pawn", function(x, y)
        print("START PROMOTING BOYS")
        --start drawing some squares
        --get which one u clicked
        --promote piece
        --end your turn
    end)
end

function state:on_enter(server, client)
    self.server = server
    self.client = client

    self.board = board:new()

    self.background_panel:set_visible(false)
    self.background_panel:set_hover_enabled(false)
end

function state:update(dt)
    if self.server then
        self.server:update()
    end

    self.client:update()
end

function state:draw()
    self.board:draw(self.color)
end

local selected_piece = nil

function state:mousepressed(mx, my)
    local tile_size = self.board.tile_size
    local board_x, board_y = math.ceil(mx / tile_size), math.ceil(my / tile_size)
    local hovered_piece

    if self.color == "black" then
        board_x = 9 - board_x
        board_y = 9 - board_y
    end

    hovered_piece = self.board[board_x] and self.board[board_x][board_y]

    if hovered_piece then
        selected_piece = hovered_piece
        selected_piece.should_draw_moves = true
    end
end

function state:mousereleased(mx, my)
    local tile_size = self.board.tile_size
    local board_x, board_y = math.ceil(mx / tile_size), math.ceil(my / tile_size)

    if self.color == "black" then
        board_x = 9 - board_x
        board_y = 9 - board_y
    end

    if selected_piece then
        if selected_piece.color == self.color then
            local current_x, current_y = selected_piece.x, selected_piece.y
            selected_piece:move(board_x, board_y)

            event.run("on_move", current_x, current_y, board_x, board_y)
        end

        selected_piece.should_draw_moves = false
        selected_piece = nil
    end
end

function state:keypressed(key)
    if key == "escape" then
        self.background_panel:set_visible(not self.background_panel:get_visible())
        self.background_panel:set_hover_enabled(not self.background_panel:get_hover_enabled())
    end
end

function state:on_exit()
    if self.client then
        self.client:disconnectNow()
    end

    if self.server then
        self.server:destroy()
    end
end

function state:quit()
    self:on_exit()
end

states.new_state("game", state)