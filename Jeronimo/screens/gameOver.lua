----------------------------------------------------------------------------------
--
-- Tela game over
--
----------------------------------------------------------------------------------

-- Bibliotecas

local composer = require( "composer" )
local scene = composer.newScene()

---------------------------------------------------------------------------------

-- Constantes
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local btnTryAgainFile = "assets/btnTryAgain.png"
local btnMenuFile = "assets/btnMenu.png"

---------------------------------------------------------------------------------

-- Objetos

local backGround
local txtPause 
local btnTryAgain
local btnMenu

---------------------------------------------------------------------------------

local function ReloadGame( )
	
	composer.removeScene( "screens.game", true )
	composer.gotoScene( "screens.game" , "fade", 400 )
end

local function ClearUp( )

	btnTryAgain:removeEventListener( "tap", ReloadGame )
	btnMenu:removeEventListener( "tap", GoToMenu )

end

local function GoToMenu( )

	btnTryAgain:removeEventListener( "tap", ReloadGame )
	btnMenu:removeEventListener( "tap", GoToMenu )
	
	composer.gotoScene( "screens.menu" , "fade", 400 )
end

----------------------------------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	backGround = display.newRect( centerX, centerY, 380, 570 )
	backGround:setFillColor( 0.5 )
	backGround.alpha = 0.5
	sceneGroup:insert( backGround )

	txtPause = display.newText( "Era só não bate \n na nuvem -.-\" ", centerX , 100, "Arial", 30 )
	sceneGroup:insert( txtPause )

	btnTryAgain = display.newImage( btnTryAgainFile, centerX - 50, 400 )
	sceneGroup:insert( btnTryAgain )

	btnMenu = display.newImage( btnMenuFile,  centerX + 50, 400  )
	sceneGroup:insert( btnMenu )

	btnTryAgain:addEventListener( "tap", ReloadGame )
	btnMenu:addEventListener( "tap", GoToMenu )

end

function scene:show( event )

	local phase = event.phase
	
	if phase == "did" then
	
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