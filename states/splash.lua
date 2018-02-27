local splash_lib = require("libraries.o-ten-one")

local state = {}

function state:on_enter()
    self.time_passed = 0
    self.skip_duration = 1

    self.splash = splash_lib({
        background = {0, 0, 10}
    })

    function self.splash.onDone()
        states.set_current_state("main_menu")
    end
end

function state:update(dt)
    self.time_passed = self.time_passed + dt

    self.splash:update(dt)
end

function state:draw()
    self.splash:draw()
end

function state:keypressed()
    if self.time_passed >= self.skip_duration then
        self.splash.onDone()
    end
end

function state:mousepressed()
    if self.time_passed >= self.skip_duration then
        self.splash.onDone()
    end
end

states.new_state("splash", state)