require "application"
require "inputmethod"
require "window"
require "space"
require "hotkey"

local function reload(paths)
    print("begin config reload")
    local doReload = false
    for _, file in pairs(paths) do
        if file:sub(-4) == ".lua" then
            print("A lua config file changed, reload")
            doReload = true
        end
    end
    if not doReload then
        print("No lua file changed, skipping reload")
        return
    end

    hs.reload()
    print("finish config reload")
end

local config_file_watcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload)
config_file_watcher:start()

print("config loaded")
