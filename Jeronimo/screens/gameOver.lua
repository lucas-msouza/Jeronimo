----------------------------------------------------------------------------------
--
-- Tela game over
--
----------------------------------------------------------------------------------

-- Bibliotecas

local composer = require( "composer" )
local widget  =require( "widget" )
local common = require( "class.common" )
local scene = composer.newScene()

---------------------------------------------------------------------------------

-- Constantes
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local btnReloadFile = "assets/btnReload.png"
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

	-- backGround = display.newRect( centerX, centerY, 380, 570 )
	-- backGround:setFillColor( 0.5 )
	-- backGround.alpha = 0.5
	-- sceneGroup:insert( backGround )

	btnTryAgain = widget.newButton{ defaultFile = btnReloadFile, onRelease = common.btnAnimation }
	btnTryAgain.x = centerX - 50
	btnTryAgain.y = 400	
	btnTryAgain.action = ReloadGame
	sceneGroup:insert( btnTryAgain )

	btnMenu = widget.newButton{ defaultFile = btnMenuFile, onRelease = common.btnAnimation }
	btnMenu.x = centerX + 50
	btnMenu.y = 400
	btnMenu.action = GoToMenu
	sceneGroup:insert( btnMenu )

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