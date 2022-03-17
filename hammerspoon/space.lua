local fnutils = require "hs.fnutils"
local window = require "hs.window"
local spaces = require "hs.spaces"
local screen = require "hs.screen"

local tableLength = function(t)
  local len = 0
  for _, _ in pairs(t) do
    len = len + 1
  end
  return len;
end

local getGoodFocusedWindow = function(nofull)
   local win = window.focusedWindow()
   if not win or not win:isStandard() then return end
   if nofull and win:isFullScreen() then return end
   return win
end

-- get ids of spaces in same layout as mission control has them (hopefully)
getUserSpaceIds = function()
  local spacesIds = {}

  fnutils.each(spaces.allSpaces(), function(spacesForScreen)
    local userSpaces = fnutils.filter(spacesForScreen, function(space)
      return spaces.spaceType(space) == "user"
    end)

    fnutils.concat(spacesIds, userSpaces or {})
  end)

  return spacesIds
end

gotoSpace = function(spaceId)
  if spaces.focusedSpace() == spaceId then return end

  spaces.gotoSpace(spaceId)
end

moveWinToSpace = function(spaceId, switch)
  local win = getGoodFocusedWindow(true)
  if not win then return end

  if spaces.focusedSpace() == spaceId then return end

  spaces.moveWindowToSpace(win:id(), spaceId)

  if switch then
    spaces.gotoSpace(spaceId)
  else
    -- focus other win
    local winIds = spaces.windowsForSpace(spaces.focusedSpace())
    if tableLength(winIds) == 0 then return end
    for _, v in ipairs(winIds) do
      win = window.find(v)
      if win then
        win:focus()
        break
      end
    end
  end
end
