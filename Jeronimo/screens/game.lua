----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------
-- Bibliotecas
local physics = require("physics")
local composer = require( "composer" )
local scene = composer.newScene()

physics.start()
----------------------------------------------------------------------------------
-- Constantes
local centerX, centerY = display.contentCenterX, display.contentCenterY
local _H, _W = display.contentHeight, display.contentWidth
local sqrt = math.sqrt
-- local oneBlock = display.contentWidth/3
-- local left = oneBlock * 0.5
-- local center = oneBlock + left
-- local right = oneBlock * 2 + left
local left = 53
local center = 160
local right = 267

local _DeadZone = 20

local sheepFile = "assets/sheep.png"
local stickerFile = "assets/sticker.png"
local btnPauseFile = "assets/btnPause.png"

---------------------------------------------------------------------------------
-- Variáveis

local x1, x2
local direction
local canMove = true
local isCheckingCollisions = false

---------------------------------------------------------------------------------
	-- Objetos

local sky 
local sheep 
local sticker 
local enemie1 
local btnPause

----------------------------------------------------------------------------------
-- Funcões

local function Move(event)

	if(event.phase == "moved") then

		x1 = event.xStart
		x2 = event.x

		if(canMove) then

			--Esquerda
			if (x1 > x2 and (x1 - x2 > _DeadZone)) then
				
				if(sheep.x == right) then
					-- sheep.x = center
					canMove = false
					transition.moveTo( sheep, { x=center, y=sheep.y, time=500 } )
				elseif(sheep.x == center) then
					-- sheep.x = left
					canMove = false
					transition.moveTo( sheep, { x=left, y=sheep.y, time=500 } )
				end
		
			--Direita
			elseif (x2 > x1 and (x2 - x1 > _DeadZone)) then
				
				if(sheep.x == left) then
					-- sheep.x = center
					canMove = false
					transition.moveTo( sheep, { x=center, y=sheep.y, time=500 } )
				elseif(sheep.x == center) then
					-- sheep.x = right
					canMove = false
					transition.moveTo( sheep, { x=right, y=sheep.y, time=500 } )
				end
			end

		end

	end
end

local function ValidateCanMove( event )

	if(sheep == nil) then
		return false
	end

	if(sheep.x == left or sheep.x == center or sheep.x == right) then
		canMove = true
	end

end

local int =2
local int1 = 4
local function MoveEnemies( event )
	
	sticker.x = sticker.x + int
	enemie1.y = enemie1.y + int1

	if ( sticker.x > _W ) then
		int = int * -1
	elseif ( sticker.x < 0 ) then
		int = int * -1
	end

	if ( enemie1.y > _H ) then 
		int1 = int1 * -1
	elseif ( enemie1.y < 0 ) then
		int1 = int1 * -1
	end

end

	
local function hasCollided(obj1, obj2)
	
    if obj1 == nil then
        return false
    end

    if obj2 == nil then
        return false
    end

    local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
	
    local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
	
    local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
	
    local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax

    return (left or right) and (up or down)
	
end

	
local function hasCollidedCircle(obj1, obj2)

    if obj1 == nil then
        return false
    end

    if obj2 == nil then	
        return false
    end

    
    local dx =  obj1.x - obj2.x;
    local dy =  obj1.y - obj2.y;
 
    local distance = sqrt(dx*dx + dy*dy);	
    local objectSize = (obj2.contentWidth/2) + (obj1.contentWidth/2)

    if distance < objectSize then

        return true

    end
	
    return false
	
end

local function Pause ( )
	
	Runtime:removeEventListener("enterFrame", MoveEnemies)


	local options = {
	isModal = true,
	effect = "fade",
	time = 400
	}

	composer.showOverlay( "screens.pause", options)

	return true

end

local function GameOver( )
	
	composer.gotoScene( "screens.gameOver", "fade", 400 )

end

local function checkingCollisions( )

	if(isCheckingCollisions) then
		return true
	end

	isCheckingCollisions = true
	if hasCollidedCircle(enemie1, sheep) then 
		GameOver()
	end

	isCheckingCollisions = false
	
end


local function ClearUp( )

	sheep:removeSelf( )
	sheep = nil
	Runtime:removeEventListener("touch", Move)
	Runtime:removeEventListener( "enterFrame", checkingCollisions )
	Runtime:removeEventListener( "enterFrame", MoveEnemies )
	Runtime:removeEventListener( "enterFrame", ValidateCanMove )
	btnPause:removeEventListener( "tap", Pause )

end



----------------------------------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	-- Objetos

	sky = display.newRect( centerX, centerY, 380, 570 )
	sky:setFillColor(0.5, 0.8, 1)
	sceneGroup:insert(sky)

	sheep =  display.newImage( sheepFile, centerX, centerY )
	sceneGroup:insert(sheep)
	
	sticker = display.newImage( stickerFile, 0, 0 )
	sceneGroup:insert(sticker)
	
	enemie1 = display.newImage( stickerFile , left, _H)
	sceneGroup:insert(enemie1)
	
	btnPause = display.newImage( btnPauseFile, 280, 0)
	sceneGroup:insert(btnPause)


	--Eventos

	Runtime:addEventListener( "enterFrame", checkingCollisions )
	Runtime:addEventListener( "enterFrame", MoveEnemies )
	Runtime:addEventListener( "enterFrame", ValidateCanMove )
	Runtime:addEventListener( "touch", Move )

	btnPause:addEventListener( "tap", Pause )

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
	
	ClearUp()

	elseif phase == "did" then
		
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view

end

function scene:ResumeGame( )
	Runtime:addEventListener( "enterFrame", MoveEnemies )
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene