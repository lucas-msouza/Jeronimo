-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar)
system.setIdleTimer( false )

local composer = require "composer"

composer.gotoScene( "screens.logo", "crossFade", 1000 )
