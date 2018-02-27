for _, item in pairs(love.filesystem.getDirectoryItems(...)) do
    local file_path = ... .. "/" .. item

    if love.filesystem.isFile(file_path) then
        if item ~= "init.lua" then
            require(file_path:gsub("%.(%a+)", ""))
        end
    end
end