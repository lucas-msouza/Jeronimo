----------------------------------------------------------------------------------
--
-- Pause do jogo
--
----------------------------------------------------------------------------------

-- Bibliotecas

local composer = require( "composer" )
local scene = composer.newScene()

---------------------------------------------------------------------------------

-- Constantes
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local btnContinueFile = "assets/btnContinue.png"

---------------------------------------------------------------------------------

-- Variáveis

---------------------------------------------------------------------------------

function clearUp( )

end

function Continue( )
	composer.hideOverlay( "fade", 400 )
end

function scene:create( event )

	local sceneGroup = self.view

	local backGround = display.newRect( centerX, centerY, 380, 570 )
	backGround:setFillColor( 0.5 )
	backGround.alpha = 0.5
	sceneGroup:insert( backGround )

	local txtPause = display.newText( "Paused", centerX , 100, "Arial", 30 )
	sceneGroup:insert( txtPause )

	local btnContinue = display.newImage( btnContinueFile, centerX, 400 )
	sceneGroup:insert( btnContinue )

	btnContinue:addEventListener( "tap", Continue )

end

function scene:show( event )

	local phase = event.phase
	
	if phase == "did" then
	
	end	
end

function scene:hide( event )

	local phase = event.phase
	
	if phase == "will" then

			clearUp()

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