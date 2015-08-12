----------------------------------------------------------------------------------
--
-- Logo do jogo
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

---------------------------------------------------------------------------------

function changeScene()
	composer.gotoScene( "screens.menu", "fade", 200)
end

function clearUp( )
	
end

function scene:create( event )
	
	local sceneGroup = self.view

	local centerX = display.contentCenterX
	local centerY = display.contentCenterY

	local logo = display.newImage( "assets/logo.png", centerX, centerY )
	logo.width = 120
	logo.height = 100

	sceneGroup:insert(logo)

end

function scene:show( event )

	local phase = event.phase
	
	if phase == "did" then

		changeScene()
	
	end	
end

function scene:hide( event )

	local phase = event.phase
	
	if event.phase == "will" then

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