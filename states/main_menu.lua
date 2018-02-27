local state = {}

function state:on_first_enter()
    local center_panel_func = function(this)
        local children = this:get_children()
        local height = #children * children[1]:get_height()

        this:set_height(height)
        this.y = this:get_parent():get_height() / 2 - height / 2
    end

    self.ui_manager:add_font("title", love.graphics.newFont(22))

    local background_panel = self.ui_manager:add("panel")
    background_panel:dock(FILL)

    local title_panel = background_panel:add("panel")
    title_panel:set_dock_margin(0, 40, 0, 0)
    title_panel:set_draw_outline(false)
    title_panel:dock(TOP)

    local title_label = title_panel:add("label")
    title_label:set_text("Silver Chess")
    title_label:set_font("title")
    title_label:dock(TOP)

    local button_panel = background_panel:add("panel")
    button_panel:set_dock_margin(200, 0, 200, 0)
    button_panel:dock(FILL)

    button_panel:add_hook("on_validate", "resize", center_panel_func)

    self.host_panel = self.ui_manager:add("panel")
    self.host_panel:set_dock_margin(100, 0, 100, 0)
    self.host_panel:dock(FILL)

        local top_panel = self.host_panel:add("panel")
        top_panel:dock(TOP)

            local host_label = top_panel:add("label")
            host_label:set_text("Host Match")
            host_label:dock(FILL)

            self.host_panel:add_hook("on_validate", "resize", center_panel_func)

        local port_panel = self.host_panel:add("panel")
        port_panel:dock(TOP)

            local port_label = port_panel:add("label")
            port_label:set_text("Port:")
            port_label:set_width(160)
            port_label:dock(LEFT)

            local port_text_entry = port_panel:add("text_entry")
            port_text_entry:set_text("22122")
            port_text_entry:set_width(160)
            port_text_entry:dock(FILL)

        local bottom_panel = self.host_panel:add("panel")
        bottom_panel:dock(TOP)

            local start_button = bottom_panel:add("button")
            start_button:set_text("Start")
            start_button:set_width(200)
            start_button:dock(LEFT)
        
            start_button:add_hook("on_clicked", "start", function(this)
                states.set_current_state("connecting", true, "localhost", port_text_entry:get_text())
            end)

            local back_button = bottom_panel:add("button")
            back_button:set_text("Back")
            back_button:dock(FILL)

            back_button:add_hook("on_clicked", "hide", function(this)
                self.host_panel:set_visible(false)
                self.host_panel:set_hover_enabled(false)
            end)


    local host_button = button_panel:add("button")
    host_button:set_text("Host Match")
    host_button:dock(TOP)

    host_button:add_hook("on_clicked", "thing", function(this)
        self.host_panel:set_visible(true)
        self.host_panel:set_hover_enabled(true)
    end)

    self.join_panel = self.ui_manager:add("panel")
    self.join_panel:set_dock_margin(100, 0, 100, 0)
    self.join_panel:dock(FILL)

    self.join_panel:add_hook("on_validate", "resize", center_panel_func)

        local top_panel = self.join_panel:add("panel")
        top_panel:dock(TOP)

            local join_label = top_panel:add("label")
            join_label:set_text("Join Match")
            join_label:dock(FILL)

        local ip_panel = self.join_panel:add("panel")
        ip_panel:dock(TOP)

            local ip_label = ip_panel:add("label")
            ip_label:set_text("Address:")
            ip_label:set_width(160)
            ip_label:dock(LEFT)

            local ip_text_entry = ip_panel:add("text_entry")
            ip_text_entry:set_text("")
            ip_text_entry:dock(FILL)
        
        local port_panel = self.join_panel:add("panel")
        port_panel:dock(TOP)

            local port_label = port_panel:add("label")
            port_label:set_text("Port:")
            port_label:set_width(160)
            port_label:dock(LEFT)

            local port_text_entry = port_panel:add("text_entry")
            port_text_entry:set_text("27015")
            port_text_entry:dock(FILL)

        local bottom_panel = self.join_panel:add("panel")
        bottom_panel:dock(TOP)

            local connect_button = bottom_panel:add("button")
            connect_button:set_text("Connect")
            connect_button:set_width(200)
            connect_button:dock(LEFT)

            connect_button:add_hook("on_clicked", "connect", function(this)
                states.set_current_state("connecting")
            end)

            local back_button = bottom_panel:add("button")
            back_button:set_text("Back")
            back_button:dock(FILL)

            back_button:add_hook("on_clicked", "hide", function(this)
                self.join_panel:set_visible(false)
                self.join_panel:set_hover_enabled(false)
            end)
            

    local join_button = button_panel:add("button")
    join_button:set_text("Join Match")
    join_button:dock(TOP)

    join_button:add_hook("on_clicked", "thing", function(this)
        self.join_panel:set_visible(true)
        self.join_panel:set_hover_enabled(true)
    end)

    local quit_button = button_panel:add("button")
    quit_button:set_text("Quit")
    quit_button:dock(TOP)

    quit_button:add_hook("on_clicked", "thing", function(this)
        love.event.quit()
    end)
end

function state:on_enter()
    self.host_panel:set_visible(false)
    self.host_panel:set_hover_enabled(false)

    self.join_panel:set_visible(false)
    self.join_panel:set_hover_enabled(false)
end

states.new_state("main_menu", state)