hs.grid.setGrid('12x12') -- allows us to place on quarters, thirds and halves
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.window.animationDuration = 0 -- disable animations

local debug = false

local events = require 'events'
local log = require 'log'
local timer = require("hs.timer")
local reloader = require 'reloader'

-- Forward function declarations.
local activate = nil
local activateLayout = nil
local canManageWindow = nil
local chain = nil
local handleScreenEvent = nil
local handleWindowEvent = nil
local hide = nil
local initEventHandling = nil
local internalDisplay = nil
local prepareScreencast = nil
local tearDownEventHandling = nil
local windowCount = nil
local leftDisplay = nil
local rightDisplay = nil
local debugMsg = nil
local ivantiStarted = false

local screenCount = #hs.screen.allScreens()

local grid = {
  topHalf = '0,0 12x6',
  topThird = '0,0 12x4',
  topTwoThirds = '0,0 12x8',
  rightHalf = '6,0 6x12',
  rightThird = '8,0 4x12',
  rightTwoThirds = '4,0 8x12',
  bottomHalf = '0,6 12x6',
  bottomThird = '0,8 12x4',
  bottomTwoThirds = '0,4 12x8',
  leftHalf = '0,0 6x12',
  leftThird = '0,0 4x12',
  leftTwoThirds = '0,0 8x12',
  topLeft = '0,0 6x6',
  topRight = '6,0 6x6',
  bottomRight = '6,6 6x6',
  bottomLeft = '0,6 6x6',
  fullScreen = '0,0 12x12',
  centeredBig = '3,3 6x6',
  centeredSmall = '4,4 4x4',
}

local terminal_bundles = {
  iTerm2 = 'com.googlecode.iterm2',
  Terminal = 'com.apple.Terminal',
  Alacritty = 'io.alacritty',
  Alacritty_alt = 'Alacritty',
  Kitty = 'net.kovidgoyal.kitty'
}

local ignoreAlwaysApps = {
  "Mail networking",
  "com.apple.hiservices-xpcservice",
  "iTunes Networking"
}

local numInstances = {}

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

local open_file = io.open

local function debugMsg(msg)
  if debug then
    log.i(msg)
  end
end

local function read_file(path)
  local file = open_file(path, "rb") -- r read mode and b binary mode
  if not file then return nil end
  local content = file:read "*a" -- *a or *all reads the whole file
  file:close()
  return content
end

local activate_app = function(name)
  local passthrough_apps = { "Safari" }
  local an_app = hs.appfinder.appFromName(name)
  local current_application = hs.application.frontmostApplication()

  if an_app ~= nil then
    for _,key in pairs(passthrough_apps) do
      if current_application:name() == key then
        return
      end
    end

    an_app:activate()
  end
end


local layoutConfig = {
  _before_ = (function()
    hide('com.spotify.client')
  end),

  _after_ = (function()
    for name, bundleID in pairs(terminal_bundles) do
      local app = hs.appfinder.appFromName(name)
      if app ~= nil then
        app:activate()
      end
    end
  end),

  ['com.google.Chrome'] = (function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, grid.fullScreen)
    else
      local rightscreen = hs.screen{x=1,y=0}
      hs.grid.set(window, grid.fullScreen, rightscreen)
    end
  end),

  ['com.google.Chrome.canary'] = (function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, grid.fullScreen)
    else
      local rightscreen = hs.screen{x=1,y=0}
      hs.grid.set(window, grid.fullScreen, rightscreen)
    end
  end),

  ['com.microsoft.SkypeForBusiness'] = (function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, grid.topLeft)
    else
      local primaryScreen = hs.screen{x=0,y=0}
      hs.grid.set(window, grid.topLeft, primaryScreen)
    end
  end),

  ['com.apple.MobileSMS'] = (function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, grid.topRight)
    else
      local primaryScreen = hs.screen{x=0,y=0}
      hs.grid.set(window, grid.topRight, primaryScreen)
    end
  end),

  ['com.apple.mail'] = (function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, grid.bottomHalf)
    else
      local primaryScreen = hs.screen{x=0,y=0}
      hs.grid.set(window, grid.bottomHalf, primaryScreen)
    end
  end),

  ['com.googlecode.iterm2'] = (function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, grid.fullScreen)
    else
      local leftscreen = hs.screen{x=-1,y=0}
      hs.grid.set(window, grid.fullScreen, leftscreen)
    end
  end),

  ['net.kovidgoyal.kitty'] = (function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, grid.fullScreen)
    else
      local leftscreen = hs.screen{x=-1,y=0}
      hs.grid.set(window, grid.fullScreen, leftscreen)
    end
  end),

  ['com.apple.Terminal'] = (function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, grid.fullScreen)
    else
      local leftscreen = hs.screen{x=-1,y=0}
      hs.grid.set(window, grid.fullScreen, leftscreen)
    end
  end),

  ['io.alacritty'] = (function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, grid.fullScreen)
    else
      local leftscreen = hs.screen{x=-1,y=0}
      hs.grid.set(window, grid.fullScreen, leftscreen)
    end
  end),

  ['Alacritty'] = (function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, grid.fullScreen)
    else
      local leftscreen = hs.screen{x=-1,y=0}
      hs.grid.set(window, grid.fullScreen, leftscreen)
    end
  end),

  ['net.pulsesecure.Pulse-Secure'] = (function(window, forceScreenCount)
    if ivantiStarted == false then
      ivantiStarted = true
      window:close()
    end
  end),

  ['mpv'] = (function(window, forceScreenCount)
    local count = forceScreenCount or screenCount
    if count == 1 then
      hs.grid.set(window, grid.fullScreen)
    else
      local leftscreen = hs.screen{x=-1,y=0}
      hs.grid.set(window, grid.fullScreen, leftscreen)
    end

    -- Bring the terminal up front after
    for _name, appID in pairs(terminal_bundles) do
      debugMsg('Activating app: ' .. appID)
      activate(appID)
    end
  end),
}

--
-- Utility and helper functions.
--

-- Returns the number of standard, non-minimized windows in the application.
--
-- (For Chrome, which has two windows per visible window on screen, but only one
-- window per minimized window).
windowCount = (function(app)
  local count = 0
  if app then
    for _, window in pairs(app:allWindows()) do
      if window:isStandard() and not window:isMinimized() then
        count = count + 1
      end
    end
  end
  return count
end)

hide = (function(bundleID)
  local app = hs.application.get(bundleID)
  if app then
    app:hide()
  end
end)

activate = (function(bundleID)
  local app = hs.application.get(bundleID)
  if app then
    app:activate()
  end
end)

canManageWindow = (function(window)
  local application = window:application()
  local bundleID = application:bundleID()

  -- Special handling for iTerm: windows without title bars are
  -- non-standard.
  return window:isStandard() or
  bundleID == 'com.googlecode.iterm2'
end)

local macBookPro16_2019 = '3072x1920'
local asus_ve278 = '1920x1080'

internalDisplay = (function()
  return hs.screen.find(macBookPro16_2019)
end)

leftDisplay = (function()
  hs.screen{x=-1,y=0}
end)

rightDisplay = (function()
  hs.screen{x=1,y=0}
end)

activateLayout = (function(forceScreenCount)
  layoutConfig._before_()
  events.emit('layout', forceScreenCount)

  for bundleID, callback in pairs(layoutConfig) do
    local application = hs.application.get(bundleID)
    if application then
      local windows = application:visibleWindows()
      for _, window in pairs(windows) do
        if canManageWindow(window) then
          callback(window, forceScreenCount)
        end
      end
    end
  end

  layoutConfig._after_()
end)

--
-- Event-handling
--

handleWindowEvent = (function(window)
  if canManageWindow(window) then
    local application = window:application()
    local bundleID = application:bundleID()

    -- Define bundles that may have a nil bundle, but app
    -- exists
    local nilBundles = { "mpv" }
    local nilFound = false

    debugMsg(application)
    debugMsg(bundleID)

    -- Nil bundles could mean the app doesn't properly
    -- have a bundle ID associated
    -- An example of this launching mpv
    if bundleID == nil then
      for _, key in pairs(nilBundles) do
        debugMsg('Attempting to find ' .. key)

        nilApp = hs.application.find(key)
        if not(nilApp == nil) then
          debugMsg(key .. ' found!')
          nilFound = true
          bundleID = key
        else
          debugMsg(key .. ' not found.')
        end
      end
    end

    if bundleID then
      local application = hs.application.get(bundleID)
      -- Attempt to layout adjust only if it's the first window and a layout
      -- exists
      if layoutConfig[bundleID] then
        if nilFound or windowCount(application) <= 1 then
          layoutConfig[bundleID](window)
        end
      end
    end
  end
end)

local windowFilter=hs.window.filter.new()
windowFilter:subscribe(hs.window.filter.windowCreated, handleWindowEvent)

handleScreenEvent = (function()
  -- Make sure that something noteworthy (display count) actually
  -- changed. We no longer check geometry because we were seeing spurious
  -- events.
  local screens = hs.screen.allScreens()
  if not (#screens == screenCount) then
    screenCount = #screens
    activateLayout(screenCount)
  end
end)

initEventHandling = (function()
  screenWatcher = hs.screen.watcher.new(handleScreenEvent)
  screenWatcher:start()
end)

tearDownEventHandling = (function()
  screenWatcher:stop()
  screenWatcher = nil
end)

local lastSeenChain = nil
local lastSeenWindow = nil

-- Chain the specified movement commands.
--
-- This is like the "chain" feature in Slate, but with a couple of enhancements:
--
--  - Chains always start on the screen the window is currently on.
--  - A chain will be reset after 2 seconds of inactivity, or on switching from
--    one chain to another, or on switching from one app to another, or from one
--    window to another.
--
chain = (function(movements)
  local chainResetInterval = 2 -- seconds
  local cycleLength = #movements
  local sequenceNumber = 1

  return function()
    local win = hs.window.frontmostWindow()
    local id = win:id()
    local now = hs.timer.secondsSinceEpoch()
    local screen = win:screen()

    if
      lastSeenChain ~= movements or
      lastSeenAt < now - chainResetInterval or
      lastSeenWindow ~= id
      then
        sequenceNumber = 1
        lastSeenChain = movements
      elseif (sequenceNumber == 1) then
        -- At end of chain, restart chain on next screen.
        screen = screen:next()
        debugMsg('Moving screens')
      end
      lastSeenAt = now
      lastSeenWindow = id

      hs.grid.set(win, movements[sequenceNumber], screen)
      sequenceNumber = sequenceNumber % cycleLength + 1
    end
  end)

  --
  -- Key bindings.
  --

  hs.hotkey.bind({'ctrl', 'alt'}, 'up', chain({
    grid.topHalf,
    grid.topThird,
    grid.topTwoThirds,
  }))

  hs.hotkey.bind({'ctrl', 'alt'}, 'right', chain({
    grid.rightHalf,
    grid.rightThird,
    grid.rightTwoThirds,
  }))

  hs.hotkey.bind({'ctrl', 'alt'}, 'down', chain({
    grid.bottomHalf,
    grid.bottomThird,
    grid.bottomTwoThirds,
  }))

  hs.hotkey.bind({'ctrl', 'alt'}, 'left', chain({
    grid.leftHalf,
    grid.leftThird,
    grid.leftTwoThirds,
  }))

  hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'up', chain({
    grid.topLeft,
    grid.topRight,
    grid.bottomRight,
    grid.bottomLeft,
  }))

  hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'down', chain({
    grid.fullScreen,
    grid.centeredBig,
    grid.centeredSmall,
  }))

  hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'f1', (function()
    hs.alert('One-monitor layout')
    activateLayout(1)
  end))

  hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'f2', (function()
    hs.alert('Two-monitor layout')
    activateLayout(2)
  end))

  hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'f3', (function()
    hs.alert('Three-monitor layout')
    activateLayout(3)
  end))

  hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'f4', (function()
    hs.notify.show(
    'Hammerspoon',
    'Reloaded in the background',
    'Press ⌃⌥⌘F5 to reveal the console.'
    )
    reloader.reload()
  end))

  hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'f5', (function()
    hs.console.alpha(.75)
    hs.toggleConsole()
  end))

  -- Uncomment to learn the bundle id of an active app
  -- hs.hotkey.bind({'cmd'}, 'w', (function()
  --   local current_application = hs.application.frontmostApplication()
  --   debugMsg(current_application:bundleID())
  -- end))

  -- hs.hotkey.bind({'cmd'}, '1', (function()
  --   local console_app = read_file(os.getenv("HOME") .. "/.config/terminal")
  --   local bundleID = terminal_bundles[console_app:gsub("%s+", "")]
  --   if bundleID then
  --     hs.application.launchOrFocusByBundleID(bundleID)
  --   else
  --     debugMsg("No bundle ID found for " .. console_app)
  --   end
  -- end))

  -- hs.hotkey.bind({'cmd'}, '2', (function()
  --   local bundleID = "com.apple.Safari"
  --   hs.application.launchOrFocusByBundleID(bundleID)
  -- end))

  -- hs.hotkey.bind({'cmd'}, '3', (function()
  --   local bundleID = "com.apple.mail"
  --   hs.application.launchOrFocusByBundleID(bundleID)
  -- end))

  -- hs.hotkey.bind({'cmd'}, '4', (function()
  --   local bundleID = "com.apple.MobileSMS"
  --   hs.application.launchOrFocusByBundleID(bundleID)
  -- end))

  -- hs.hotkey.bind({'cmd'}, '5', (function()
  --   local bundleID = "com.microsoft.SkypeForBusiness"
  --   hs.application.launchOrFocusByBundleID(bundleID)
  -- end))

  for _, app in pairs(ignoreAlwaysApps) do
    -- Ignore some stuff for warnings
    hs.window.filter.ignoreAlways[app] = true
  end

  log.i('Config loaded')
