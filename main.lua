require("libraries.silver_ui")
require("libraries.event")
require("states")

function love.load()
    states.set_current_state("main_menu")
end