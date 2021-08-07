local fnutils = require "hs.fnutils"
local window = require "hs.window"
local spaces = require "hs._asm.undocumented.spaces"
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
local getSpaceIdsTable = function()
  local spacesLayout = spaces.layout()
  local spacesIds = {}

  fnutils.each(screen.allScreens(), function(screen)
    local spaceUUID = screen:spacesUUID()

    local userSpaces = fnutils.filter(spacesLayout[spaceUUID], function(spaceId)
      return spaces.spaceType(spaceId) == spaces.types.user
    end)

    fnutils.concat(spacesIds, userSpaces or {})
  end)

  return spacesIds
end

moveWinToSpace = function(spaceIdx, switch)
  local win = getGoodFocusedWindow(true)
  if not win then return end

  local spaceIds = getSpaceIdsTable()
  local spaceNum = tableLength(spaceIds)
  if spaceNum < spaceIdx then return end
  local spaceId = spaceIds[spaceIdx]

  if spaces.activeSpace() == spaceId then return end

  spaces.moveWindowToSpace(win:id(), spaceId)

  if switch then
    hs.eventtap.keyStroke({'ctrl'}, tostring(spaceIdx))
    win:focus()
  else
    -- focus other win
    spaces.allWindowsForSpace(spaceId)
  end
end
