----------------------------------------------------------------------------------
--
-- Pause do jogo
--
----------------------------------------------------------------------------------

-- Bibliotecas

local composer = require( "composer" )
local widget = require( "widget" )
local common = require( "class.common" )
local scene = composer.newScene()

---------------------------------------------------------------------------------

-- Constantes
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local btnPlayFile = "assets/btnPlay.png"
local btnMenuFile = "assets/btnMenu.png"
local menuPauseFile = "assets/menuPause.png"

---------------------------------------------------------------------------------

-- Variáveis

---------------------------------------------------------------------------------

local function Continue( )
	composer.hideOverlay( "fade", 400 )
end

local function GoToMenu( )
	composer.gotoScene( "screens.menu" , "fade", 400 )
end

function scene:create( event )

	local sceneGroup = self.view

	local backGround = display.newRect( centerX, centerY, 380, 570 )
	backGround:setFillColor( 0.5 )
	backGround.alpha = 0.5
	sceneGroup:insert( backGround )

	local menuPause = display.newImage( menuPauseFile, centerX, centerY - 15)
	sceneGroup:insert(menuPause)

	local btnContinue = widget.newButton { defaultFile = btnPlayFile, onRelease = common.btnAnimation }
	btnContinue.x = centerX - 50
	btnContinue.y = centerY
	btnContinue.action = Continue
	sceneGroup:insert( btnContinue )

	local btnMenu = widget.newButton{ defaultFile = btnMenuFile, onRelease = common.btnAnimation }
	btnMenu.x = centerX + 50
	btnMenu.y = centerY
	btnMenu.action = GoToMenu
	sceneGroup:insert( btnMenu )


end

function scene:show( event )

	local phase = event.phase
	
	if phase == "did" then
		system.setIdleTimer( true )
	end	
end

function scene:hide( event )

	local phase = event.phase
	local parent = event.parent
	
	if phase == "will" then
		
		system.setIdleTimer( false )
		parent:ResumeGame( )

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