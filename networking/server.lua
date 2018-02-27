local sock = require("libraries.networking.sock")

local server = {}

function server.new(ip, port, max_peers, max_channels)
    local server = sock.newServer(ip, port, max_peers, max_channels)

    local colors = {
        "black",
        "white"
    }

    server:on("connect", function(data, client)
        print("Someone connects to the server", data, client)
        local random_index = math.random(1, #colors)
        local color = colors[random_index]

        table.remove(colors, random_index)

        client:send("on_color_received", color)
    end)

    server:on("piece_moved", function(data, client)
        server:sendToAllBut(client, "on_move_received", {
            data[1], 
            data[2], 
            data[3], 
            data[4]
        })
    end)



    return server
end

return server