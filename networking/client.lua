local sock = require("libraries.networking.sock")

local client = {}

function client.new(ip, port, max_channels)
    local client = sock.newClient(ip, port, max_channels)

    client:on("connect", function(data)
        print("Client connected", client)
    end)

    client:on("on_move_received", function(data)
        event.run("on_move_received", data[1], data[2], data[3], data[4])
    end)

    client:on("on_color_received", function(color)
        event.run("on_color_received", color)
    end)

    return client
end

return client