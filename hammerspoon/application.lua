-- Application management

local osascript = require "hs.osascript"
local app = require "hs.application"
local appfinder = require "hs.appfinder"

app.enableSpotlightForNameSearches(true)

function launchApp(name)
    app.launchOrFocus(name)
    if name == 'Finder' then
        appfinder.appFromName(name):activate()
    end
end

function openEmacsClient()
    local cmd = "/opt/homebrew/bin/emacsclient -a '' -n -c"
    osascript.applescript(string.format('do shell script "%s"', cmd))
end
