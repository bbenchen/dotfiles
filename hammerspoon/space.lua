local window = require "hs.window"
local spaces = require "hs._asm.undocumented.spaces"

local function getGoodFocusedWindow(nofull)
  local win = window.focusedWindow()
  if not win or not win:isStandard() then return end
  if nofull and win:isFullScreen() then return end
  return win
end

local function flashScreen(screen)
  local flash = hs.canvas.new(screen:fullFrame()):appendElements({
      action = "fill", fillColor = { alpha = 0.25, red=1}, type = "rectangle"})
  flash:show()
  hs.timer.doAfter(.15,function () flash:delete() end)
end

local function switchSpace(skip, dir)
  for i = 1, skip do
    hs.eventtap.keyStroke({"ctrl"}, dir)
  end
end

function moveWindowOneSpace(dir, switch)
  local win = getGoodFocusedWindow(true)
  if not win then return end
  local screen = win:screen()
  local uuid = screen:spacesUUID()
  local userSpaces = nil
  for k,v in pairs(spaces.layout()) do
    userSpaces = v
    if k == uuid then break end
  end
  if not userSpaces then return end
  local thisSpace = win:spaces() -- first space win appears on
  if not thisSpace then return else thisSpace=thisSpace[1] end
  local last = nil
  local skipSpaces = 0
  for _, spc in ipairs(userSpaces) do
    if spaces.spaceType(spc) ~= spaces.types.user then -- skippable space
      skipSpaces = skipSpaces + 1
    else -- A good user space, check it
      if last and
        ((dir == "left"  and spc == thisSpace) or
          (dir == "right" and last == thisSpace))
      then
        win:spacesMoveTo(dir == "left" and last or spc)
        if switch then
          switchSpace(skipSpaces + 1, dir)
          win:focus()
        end
        return
      end
      last = spc -- Haven't found it yet...
      skipSpaces = 0
    end
  end
  flashScreen(screen) -- Shouldn't get here, so no space found
end
