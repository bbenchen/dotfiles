-- Halves of the screen
hs.hotkey.bind({"ctrl","cmd"}, "h", hs.fnutils.partial(winResize, "left"))
hs.hotkey.bind({"ctrl","cmd"}, "l", hs.fnutils.partial(winResize, "right"))
hs.hotkey.bind({"ctrl","cmd"}, "j", hs.fnutils.partial(winResize, "up"))
hs.hotkey.bind({"ctrl","cmd"}, "k", hs.fnutils.partial(winResize, "down"))

-- Center of the screen
hs.hotkey.bind({"ctrl", "cmd"}, "c", winCenter)

-- Thirds of the screen
hs.hotkey.bind({"ctrl", "alt"}, "h", winLeftThird)
hs.hotkey.bind({"ctrl", "alt"}, "l", winRightThird)
hs.hotkey.bind({"ctrl", "alt"}, "j", winUpThird)
hs.hotkey.bind({"ctrl", "alt"}, "k", winDownThird)

-- Maximized
hs.hotkey.bind({"ctrl", "cmd"}, "f", hs.fnutils.partial(winResize, "max"))
hs.hotkey.bind({"ctrl", "cmd"}, "t", hs.fnutils.partial(winToggleMaximized))

-- Move between spaces
hs.hotkey.bind({"ctrl", "cmd"}, "Left", hs.fnutils.partial(moveWindowOneSpace, "left", true))
hs.hotkey.bind({"ctrl", "cmd"}, "Right", hs.fnutils.partial(moveWindowOneSpace, "right", true))
hs.hotkey.bind({"alt", "cmd"}, "Left", hs.fnutils.partial(moveWindowOneSpace, "left", false))
hs.hotkey.bind({"alt", "cmd"}, "Right", hs.fnutils.partial(moveWindowOneSpace, "right", false))

-- Move between screens
hs.hotkey.bind({"ctrl", "alt"}, "Left", hs.fnutils.partial(winMoveScreen, "left"))
hs.hotkey.bind({"ctrl", "alt"}, "Right", hs.fnutils.partial(winMoveScreen, "right"))

-- Launch app
hs.hotkey.bind({"ctrl", "cmd"}, "e", hs.fnutils.partial(launchApp, "Emacs"))
