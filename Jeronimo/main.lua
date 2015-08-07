-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

function StartGame( )

	screenGroup:removeSelf()

	timer.performWithDelay(10, game, 1)

end

function zuera( )
	local text = display.newText("Yasmim Gorda", 160, 400 , "Arial", 20)
end

function startScreen(  )

	local widget = require( "widget" )

    screenGroup = display.newGroup()

	local centerX = display.contentCenterX
	local centerY = display.contentCenterY

	local sky = display.newRect( centerX, centerY, 380, 570 )
	sky:setFillColor(0.5, 0.8, 1)

	local title = display.newText("Jeronimo", centerX, 0 , "Arial", 60)

	local btnStart = widget.newButton
	{
		defaultFile = "laserSwitchGreenOff.png",
		overFile = "laserSwitchGreenOn.png",
		onPress = zuera,
		onRelease = StartGame,
	}

	btnStart.x = centerX
	btnStart.y = centerY

	screenGroup:insert(sky)
	screenGroup:insert(title)
	screenGroup:insert(btnStart)

end

function game( )
	-- body


-- Bibliotecas
local physics = require("physics")
physics.start()

local sqrt = math.sqrt


-- Constantes
local centerX, centerY = display.contentCenterX, display.contentCenterY
local _H, _W = display.contentHeight, display.contentWidth
-- local oneBlock = display.contentWidth/3
-- local left = oneBlock * 0.5
-- local center = oneBlock + left
-- local right = oneBlock * 2 + left
local left = 53
local center = 160
local right = 267

local _DeadZone = 20

-- Variáveis

local x1, x2
local direction
local canMove = true
local isCheckingCollisions = false

-- Objetos
local sky = display.newRect( centerX, centerY, 380, 570 )
sky:setFillColor(0.5, 0.8, 1)

local sheepFile = "sheep.png"
local sheepOutLine = graphics.newOutline( 1, sheepFile )
local sheep =  display.newImage( sheepFile, centerX, centerY )

local stickerFile = "sticker.png"
local stickerOutLine = graphics.newOutline( 2, stickerFile )
local sticker = display.newImage( stickerFile, 0, 0 )

local enemie1 = display.newImage( stickerFile , left, _H)

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


local function checkingCollisions( )

	if(isCheckingCollisions) then
		return true
	end

	isCheckingCollisions = true
	if hasCollidedCircle(enemie1, sheep) then 
		sheep:removeSelf( )
		sheep = nil
	end

	isCheckingCollisions = false
	
end




--Eventos

Runtime:addEventListener( "enterFrame", checkingCollisions )
Runtime:addEventListener( "enterFrame", MoveEnemies )
Runtime:addEventListener( "enterFrame", ValidateCanMove )

Runtime:addEventListener( "touch", Move )

end

startScreen()