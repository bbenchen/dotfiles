local keycodes = require "hs.keycodes"
local window = require "hs.window"
local hotkey = require "hs.hotkey"
local alert = require "hs.alert"

local function Chinese()
    print("set chinese input method")
    keycodes.currentSourceID("im.rime.inputmethod.Squirrel.Hans")
end
local function English()
    print("set english input method")
    keycodes.currentSourceID("com.apple.keylayout.US")
end
local function set_app_input_method(app_name, set_input_method_function, event)
    event = event or window.filter.windowFocused
    window.filter.new(app_name)
        :subscribe(event, function()
                       set_input_method_function()
                  end)
end
set_app_input_method('Hammerspoon', English, window.filter.windowCreated)
set_app_input_method('Spotlight', English, window.filter.windowCreated)
set_app_input_method('Raycast', English, window.filter.windowCreated)
set_app_input_method('Finder', English, window.filter.windowCreated)
set_app_input_method('System Settings', English)
set_app_input_method('Terminal', English)
set_app_input_method('kitty', English)
set_app_input_method('WezTerm', English)
set_app_input_method('Emacs', English)
set_app_input_method('IntelliJ IDEA', English)
set_app_input_method('Google Chrome', English)
set_app_input_method('Microsoft Remote Desktop', English)
set_app_input_method('Parallels Desktop', English)

set_app_input_method('WeChat', Chinese)
set_app_input_method('WPS Office', Chinese)
set_app_input_method('wpsoffice', Chinese)

hotkey.bind({'ctrl', 'cmd'}, ".", function()
    alert.show("App path:        "
               ..window.focusedWindow():application():path()
               .."\n"
               .."App name:      "
               ..window.focusedWindow():application():name()
               .."\n"
               .."BundleID:    "
               ..window.focusedWindow():application():bundleID()
               .."\n"
               .."IM source id:  "
               ..keycodes.currentSourceID())
end)
