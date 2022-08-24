local keycodes = require "hs.keycodes"
local window = require "hs.window"
local hotkey = require "hs.hotkey"
local alert = require "hs.alert"

local function Chinese()
  keycodes.currentSourceID("im.rime.inputmethod.Squirrel.Rime")
end
local function English()
  keycodes.currentSourceID("com.apple.keylayout.US")
end
local function set_app_input_method(app_name, set_input_method_function, event)
  event = event or window.filter.windowFocused
  window.filter.new(app_name)
    :subscribe(event, function() set_input_method_function() end)
end
set_app_input_method('Hammerspoon', English, window.filter.windowCreated)
set_app_input_method('Spotlight', English, window.filter.windowCreated)
set_app_input_method('Raycast', English, window.filter.windowCreated)
set_app_input_method('Finder', English, window.filter.windowCreated)
set_app_input_method('Terminal', English)
set_app_input_method('kitty', English)
set_app_input_method('Emacs', English)
set_app_input_method('Google Chrome', English)

set_app_input_method('WeChat', Chinese)
set_app_input_method('WPS Office', Chinese)

hotkey.bind({'ctrl', 'cmd'}, ".", function()
    alert.show("App path:        "
               ..window.focusedWindow():application():path()
               .."\n"
               .."App name:      "
               ..window.focusedWindow():application():name()
               .."\n"
               .."IM source id:  "
               ..keycodes.currentSourceID())
end)
