-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar)

local composer = require "composer"

composer.gotoScene( "screens.logo", "crossFade", 1000 )
