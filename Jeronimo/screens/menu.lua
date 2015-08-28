----------------------------------------------------------------------------------
--
-- Menu do jogo
--
----------------------------------------------------------------------------------

-- Bibliotecas

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local common = require("class.common") 

----------------------------------------------------------------------------------

-- Constantes

local centerX, centerY = display.contentCenterX, display.contentCenterY
local _H, _W = display.contentHeight, display.contentWidth

---------------------------------------------------------------------------------

-- Files

local btnPlayFile = "assets/btnStart.png"
local backGroundFile = "assets/background4.jpg"
local txtTitleFile = "assets/title5.png"


---------------------------------------------------------------------------------

-- Objetos

local backGround 
local title 

---------------------------------------------------------------------------------



local function StartGame( event )

	composer.gotoScene( "screens.game", "fade", 200 )

	return true

end


local function ExitGame( )

	if(system.getInfo("platformName") == "Android") then
		native.requestExit( )
	else
		os.exit( )
	end
end

---------------------------------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	backGround = display.newImage( backGroundFile, centerX, centerY )

 	title = display.newImage( txtTitleFile , centerX, 40 )

	local btnStart = widget.newButton
	{
		defaultFile = btnPlayFile,
		onRelease = common.btnAnimation,
	}

	btnStart.action = StartGame
	btnStart.x = centerX
	btnStart.y = _H - 150

	sceneGroup:insert(backGround)
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