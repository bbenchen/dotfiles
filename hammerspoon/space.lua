local eventtap = require "hs.eventtap"
local fnutils = require "hs.fnutils"
local geometry = require "hs.geometry"
local mouse = require "hs.mouse"
local spaces = require "hs.spaces"
local timer = require "hs.timer"
local window = require "hs.window"

-- get ids of spaces in same layout as mission control has them (hopefully)
function getUserSpaceIds()
    local spacesIds = {}

    fnutils.each(spaces.allSpaces(), function(spacesForScreen)
        local userSpaces = fnutils.filter(spacesForScreen, function(space)
            return spaces.spaceType(space) == "user"
        end)

        fnutils.concat(spacesIds, userSpaces or {})
    end)

    return spacesIds
end

function gotoSpace(spaceId)
    if spaces.focusedSpace() == spaceId then return end

    spaces.gotoSpace(spaceId)
end

-- WindowState
local movingWindow = false

-- Constants
local MOUSE_OFFSET_X = 5
local MOUSE_OFFSET_Y = 12
local SWITCH_DELAY = 0.2
local RELEASE_DELAY = 0.5

local function simulateKeyEvent(modifier1, key)
    eventtap.event.newKeyEvent(modifier1, true):post()
    eventtap.event.newKeyEvent(key, true):post()
    timer.doAfter(0.1, function()
        eventtap.event.newKeyEvent(modifier1, false):post()
        eventtap.event.newKeyEvent(key, false):post()
    end)
end

function moveWinToRightSpace()
    if movingWindow then return end
    movingWindow = true

    local screenSpaces = spaces.spacesForScreen()
    local currentSpace = spaces.focusedSpace()

    if currentSpace == screenSpaces[#screenSpaces] then
        movingWindow = false
        return
    end

    local win = window.focusedWindow()
    if not win then
        movingWindow = false
        return
    end
    win:unminimize()
    win:raise()

    local frame = win:frame()
    local clickPos = geometry.point(frame.x + MOUSE_OFFSET_X, frame.y + MOUSE_OFFSET_Y)
    local centerPos = geometry.point(frame.x + frame.w / 2, frame.y + frame.h / 2)

    mouse.absolutePosition(clickPos)

    eventtap.event.newMouseEvent(eventtap.event.types.leftMouseDown, clickPos):post()

    timer.doAfter(SWITCH_DELAY, function()
        simulateKeyEvent("ctrl", "right")
    end)

    timer.doAfter(RELEASE_DELAY, function()
        eventtap.event.newMouseEvent(eventtap.event.types.leftMouseUp, clickPos):post()
        mouse.absolutePosition(centerPos)
        win:raise()
        win:focus()
        movingWindow = false
    end)
end

function moveWinToLeftSpace()
    if movingWindow then return end
    movingWindow = true

    local screenSpaces = spaces.spacesForScreen()
    local currentSpace = spaces.focusedSpace()

    if currentSpace == screenSpaces[1] then
        movingWindow = false
        return
    end

    local win = window.focusedWindow()
    if not win then
        movingWindow = false
        return
    end
    win:unminimize()
    win:raise()

    local frame = win:frame()
    local clickPos = geometry.point(frame.x + MOUSE_OFFSET_X, frame.y + MOUSE_OFFSET_Y)
    local centerPos = geometry.point(frame.x + frame.w / 2, frame.y + frame.h / 2)

    mouse.absolutePosition(clickPos)

    eventtap.event.newMouseEvent(eventtap.event.types.leftMouseDown, clickPos):post()

    timer.doAfter(SWITCH_DELAY, function()
        simulateKeyEvent("ctrl", "left")
    end)

    timer.doAfter(RELEASE_DELAY, function()
        eventtap.event.newMouseEvent(eventtap.event.types.leftMouseUp, clickPos):post()
        mouse.absolutePosition(centerPos)
        win:raise()
        win:focus()
        movingWindow = false
    end)
end
