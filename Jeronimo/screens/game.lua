----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------
-- Bibliotecas

local composer = require( "composer" )
local scene = composer.newScene()

----------------------------------------------------------------------------------
-- Constantes
local centerX, centerY = display.contentCenterX, display.contentCenterY
local _H, _W = display.contentHeight, display.contentWidth
local sqrt = math.sqrt
local ceil = math.ceil
local random = math.random
local oneBlock = display.contentWidth/3
local left = ceil( oneBlock * 0.5 )
local center = ceil( oneBlock + left )
local right = ceil ( oneBlock * 2 + left )
local score = 0

local _DeadZone = 20

local sheepFile = "assets/sheep.png"
local stickerFile = "assets/sticker.png"
local btnPauseFile = "assets/btnPause.png"

local enemieSpeedS = 2
local enemieSpeedM = 4
local enemieSpeedF = 6

---------------------------------------------------------------------------------
-- Variáveis

local x1, x2
local direction
local canMove
local isCheckingCollisions
local score

---------------------------------------------------------------------------------
	-- Objetos

local sky 
local sheep 
local btnPause
local enemies = {}

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

local function MoveEnemies( )

	for i=1, #enemies do
		enemies[i].y = enemies[i].y - enemieSpeedF
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


local function GameOver( )
	
	composer.gotoScene( "screens.gameOver", "fade", 400 )

end

local function checkingCollisions( )

	if(isCheckingCollisions) then
		return true
	end

	isCheckingCollisions = true

	for i=1, #enemies  do
		
		if hasCollidedCircle(enemies[i], sheep) then 
			GameOver()
		end

	end

	isCheckingCollisions = false
	
end



local function respawnEnemies( )
	local distance = _H * 0.35
	local positionY = _H + _H * 0.5

	for i=1, #enemies do

		local xRandom = random(3)

		if xRandom == 1 then
			enemies[i].x = left
		elseif xRandom == 2 then
			enemies[i].x = center
		else
			enemies[i].x = right
		end

		enemies[i].y = positionY
		positionY = positionY + distance

		enemies[i].isVisible = true

	end


end

local function ResetWave( )

	lastEnemie = enemies[10]

	if (lastEnemie.y < -20 ) then

		respawnEnemies()
		
	end



end

local function gameLoop( )

	checkingCollisions( )
	MoveEnemies( )
	ValidateCanMove( )
	ResetWave( )

end

local function Pause ( )
	

	Runtime:removeEventListener("enterFrame", gameLoop)


	local options = {
	isModal = true,
	effect = "fade",
	time = 400
	}

	composer.showOverlay( "screens.pause", options)

	return true

end

local function ClearUp( )

	Runtime:removeEventListener( "touch", Move )
	Runtime:removeEventListener("enterFrame", gameLoop)
	btnPause:removeEventListener( "tap", Pause )

end

----------------------------------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	-- Objetos

	sky = display.newRect( centerX, centerY, _W, _H )
	sky:setFillColor(0.5, 0.8, 1)
	sceneGroup:insert(sky)

	sheep =  display.newImage( sheepFile, center, centerY )
	sceneGroup:insert(sheep)
	
	--Create Enemies

	for i=1,10 do
		enemies[i] = display.newImage( stickerFile, 0, 0 )
		enemies[i].isVisible = false
		sceneGroup:insert(enemies[i])
	end

	btnPause = display.newImage( btnPauseFile, _W - 30, 30)
	sceneGroup:insert(btnPause)

	--Eventos
	Runtime:addEventListener( "touch", Move )
	btnPause:addEventListener( "tap", Pause )


end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

	respawnEnemies()

	elseif phase == "did" then

	canMove = true
	isCheckingCollisions = false
	score = 0

	-- Eventos

	Runtime:addEventListener( "enterFrame", gameLoop )

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
	Runtime:addEventListener( "enterFrame", gameLoop )
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene