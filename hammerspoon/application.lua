-- Application management

hs.application.enableSpotlightForNameSearches(true)

function launchApp(name)
  hs.application.launchOrFocus(name)
  if name == 'Finder' then
    hs.appfinder.appFromName(name):activate()
  end
end
