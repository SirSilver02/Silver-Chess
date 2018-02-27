function love.conf(t)
	local window_size = 64 * 8
	
    t.window.width = window_size
    t.window.height = window_size
	t.window.icon = "assets/images/icon.png"
	t.window.title = "Silver Chess"
end