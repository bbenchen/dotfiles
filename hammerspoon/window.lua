-- Window management

-- Defines for window maximize toggler
local frameCache = {}
local logger = hs.logger.new("windows")
local homeDir = os.getenv("HOME")

-- Maximize window when specify application started.
local maximizeApps = {
    "/Applications/Emacs.app",
    "/Applications/Google Chrome.app",
    homeDir.."/Applications/Emacs.app",
    homeDir.."/Applications/Google Chrome.app",
}

local windowCreateFilter = hs.window.filter.new():setDefaultFilter()
windowCreateFilter:subscribe(
    hs.window.filter.windowCreated,
    function (win, ttl, last)
        for index, value in ipairs(maximizeApps) do
            if win:application():path() == value then
                win:maximize()
                win:focus()
                return true
            end
        end
end)

-- Resize current window
function winResize(how)
    local win = hs.window.focusedWindow()
    -- local app = win:application():name()
    -- local windowLayout
    local newrect

    if how == "left" then
        newrect = hs.layout.left50
    elseif how == "right" then
        newrect = hs.layout.right50
    elseif how == "up" then
        newrect = {0,0,1,0.5}
    elseif how == "down" then
        newrect = {0,0.5,1,0.5}
    elseif how == "max" then
        newrect = hs.layout.maximized
    elseif how == "left_third" or how == "hthird-0" then
        newrect = {0,0,1/3,1}
    elseif how == "middle_third_h" or how == "hthird-1" then
        newrect = {1/3,0,1/3,1}
    elseif how == "right_third" or how == "hthird-2" then
        newrect = {2/3,0,1/3,1}
    elseif how == "top_third" or how == "vthird-0" then
        newrect = {0,0,1,1/3}
    elseif how == "middle_third_v" or how == "vthird-1" then
        newrect = {0,1/3,1,1/3}
    elseif how == "bottom_third" or how == "vthird-2" then
        newrect = {0,2/3,1,1/3}
    end

    win:move(newrect)
end

function winMoveScreen(how)
    local win = hs.window.focusedWindow()
    if how == "left" then
        win:moveOneScreenWest()
    elseif how == "right" then
        win:moveOneScreenEast()
    end
end

-- Toggle a window between its normal size, and being maximized
function winToggleMaximized()
    local win = hs.window.focusedWindow()
    if frameCache[win:id()] then
        win:setFrame(frameCache[win:id()])
        frameCache[win:id()] = nil
    else
        frameCache[win:id()] = win:frame()
        win:maximize()
    end
end

-- Move between thirds of the screen
local function getHorizontalThird(win)
    local frame=win:frame()
    local screenframe=win:screen():frame()
    local relframe=hs.geometry(frame.x-screenframe.x, frame.y-screenframe.y, frame.w, frame.h)
    local third = math.floor(3.01*relframe.x/screenframe.w)
    logger.df("Screen frame: %s", screenframe)
    logger.df("Window frame: %s, relframe %s is in horizontal third #%d", frame, relframe, third)
    return third
end

local function getVerticalThird(win)
    local frame=win:frame()
    local screenframe=win:screen():frame()
    local relframe=hs.geometry(frame.x-screenframe.x, frame.y-screenframe.y, frame.w, frame.h)
    local third = math.floor(3.01*relframe.y/screenframe.h)
    logger.df("Screen frame: %s", screenframe)
    logger.df("Window frame: %s, relframe %s is in vertical third #%d", frame, relframe, third)
    return third
end

function winLeftThird()
    local win = hs.window.focusedWindow()
    local third = getHorizontalThird(win)
    if third == 0 then
        winResize("hthird-0")
    else
        winResize("hthird-" .. (third-1))
    end
end

function winRightThird()
    local win = hs.window.focusedWindow()
    local third = getHorizontalThird(win)
    if third == 2 then
        winResize("hthird-2")
    else
        winResize("hthird-" .. (third+1))
    end
end

function winUpThird()
    local win = hs.window.focusedWindow()
    local third = getVerticalThird(win)
    if third == 0 then
        winResize("vthird-0")
    else
        winResize("vthird-" .. (third-1))
    end
end

function winDownThird()
    local win = hs.window.focusedWindow()
    local third = getVerticalThird(win)
    if third == 2 then
        winResize("vthird-2")
    else
        winResize("vthird-" .. (third+1))
    end
end

function winCenter()
    local win = hs.window.focusedWindow()
    win:centerOnScreen()
end
