local state = {}

function state:on_first_enter()
    local message_label = self.ui_manager:add("label")
    message_label:set_text("Disconnected from server.")
    message_label:dock(FILL)
end

function state:on_enter()
    self.time_passed = 0
    self.skip_time = 1
    self.auto_skip_time = self.skip_time + 5
    self.can_skip = false
end

function state:update(dt)
    self.time_passed = self.time_passed + dt

    if self.time_passed >= self.skip_time then
        self.can_skip = true

        if self.time_passed >= self.auto_skip_time then
            states.set_current_state("main_menu")
        end
    end
end

function state:mousepressed()
    if self.can_skip then
        states.set_current_state("main_menu")
    end
end

function state:keypressed()
    if self.can_skip then
        states.set_current_state("main_menu")
    end
end

states.new_state("disconnected", state)