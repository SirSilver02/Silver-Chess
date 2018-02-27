local client = require("networking.client")
local server = require("networking.server")

local state = {}

function state:on_first_enter()
    local banner_panel = self.ui_manager:add("panel")
    banner_panel:dock(TOP)

    self.connecting_label = self.ui_manager:add("label")
    self.connecting_label:dock(FILL)

    local bottom_panel = self.ui_manager:add("panel")
    bottom_panel:dock(BOTTOM)

    local back_button = bottom_panel:add("button")
    back_button:set_text("Back")
    back_button:dock(FILL)

    back_button:add_hook("on_clicked", "thing", function()
        states.set_current_state("main_menu")
    end)
end

function state:on_enter(is_host, ip, port)
    self.server = nil
    self.client = nil
    
    self.time_passed = 0
    self.timeout = 8

    self.client_connecting_messages = {
        "Establishing connection",
        "Establishing connection.",
        "Establishing connection..",
        "Establishing connection..."
    }

    self.connecting_messages_time_elapsed = 0
    self.connecting_messages_time_duration = 1
    self.connecting_message_index = 1

    self.connecting_label:set_text(self.client_connecting_messages[self.connecting_message_index])

    if is_host then        
        self.server = server.new("*", tonumber(port))
    end

    self.client = client.new(ip, tonumber(port))
    self.client:connect()
end

function state:update(dt)
    if self.server then
        self.server:update()
    end

    if self.client then
        self.client:update()
    else
        states.set_current_state("disconnected")
    end
    
    self.time_passed = self.time_passed + dt

    if self.time_passed >= self.timeout then
        states.set_current_state("disconnected")
    end

    local client_state = self.client:getState()

    if client_state == "disconnected" then
        states.set_current_state("disconnected")
    elseif client_state == "connecting" then
        self.connecting_messages_time_elapsed = self.connecting_messages_time_elapsed + dt

        if self.connecting_messages_time_elapsed >= self.connecting_messages_time_duration then
            self.connecting_messages_time_elapsed = 0
            self.connecting_message_index = self.connecting_message_index + 1
            
            self.connecting_label:set_text(self.client_connecting_messages[self.connecting_message_index])

            if self.connecting_message_index > #self.client_connecting_messages then
                self.connecting_message_index = 1

                self.connecting_label:set_text(self.client_connecting_messages[self.connecting_message_index])
            end
        end
    elseif client_state == "connected" then
        states.set_current_state("game", self.server, self.client)
    end
end

states.new_state("connecting", state)