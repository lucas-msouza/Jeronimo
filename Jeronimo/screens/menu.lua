----------------------------------------------------------------------------------
--
-- Menu do jogo
--
----------------------------------------------------------------------------------

-- Bibliotecas

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )

----------------------------------------------------------------------------------

-- Constantes

local centerX, centerY = display.contentCenterX, display.contentCenterY
local _H, _W = display.contentHeight, display.contentWidth

---------------------------------------------------------------------------------

function StartGame( event )

	composer.gotoScene( "screens.game", "fade", 200 )

	return true

end

function scene:create( event )

	local sceneGroup = self.view

	local sky = display.newRect( centerX, centerY, 380, 570 )
	sky:setFillColor(0.5, 0.8, 1)

	local title = display.newText("Jeronimo", centerX, 40 , "Arial", 60)

	local btnStart = widget.newButton
	{
		defaultFile = "assets/laserSwitchGreenOff.png",
		overFile = "assets/laserSwitchGreenOn.png",
		onRelease = StartGame,
	}

	btnStart.x = centerX
	btnStart.y = _H - 100

	sceneGroup:insert(sky)
	sceneGroup:insert(title)
	sceneGroup:insert(btnStart)


end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

		composer.removeScene( "screens.logo" )
		composer.removeScene( "screens.game", true )
		composer.removeScene( "screens.gameOver", true )

	elseif phase == "did" then

	end	
end

function scene:hide( event )
	local phase = event.phase
	
	if event.phase == "will" then

	elseif phase == "did" then

	end	
end


function scene:destroy( event )

end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene