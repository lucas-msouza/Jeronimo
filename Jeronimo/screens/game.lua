----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------
-- Bibliotecas

local composer = require( "composer" )
local common = require("class.common") 
local widget = require( "widget" )
-- local physics = require( "physics" )
-- physics.setDrawMode( "hybrid" )
local scene = composer.newScene()

----------------------------------------------------------------------------------
-- Constantes

local sheepFile = "assets/sheep4.png"
local stickerFile = "assets/sticker.png"
local btnPauseFile = "assets/btnPause.png"
local cloud_1File = "assets/cloud_1.png"
local cloud_2File = "assets/cloud_2.png"
local cloud_3File = "assets/cloud_3.png"
local tempest_1File = "assets/tempest_1.png"
local tempest_2File = "assets/tempest_2.png"
local tempest_3File = "assets/tempest_3.png"
local tempest_4File = "assets/tempest_4.png"
local tempest_5File = "assets/tempest_5.png"


local centerX, centerY = display.contentCenterX, display.contentCenterY
local _H, _W = display.contentHeight, display.contentWidth
local sqrt = math.sqrt
local ceil = math.ceil
local random = math.random
local oneBlock = display.contentWidth/3
local left = ceil( oneBlock * 0.5 )
local center = ceil( oneBlock + left )
local right = ceil( oneBlock * 2 + left )
local reverse = 1
local cloudFiles = { cloud_1File, cloud_2File, cloud_3File }
local tempestFiles = { tempest_1File, tempest_2File, tempest_3File, tempest_4File, tempest_5File}
local cloudsDensity = 2

local _DeadZone = 20

local enemieSpeedS = 2
local enemieSpeedM = 4
local enemieSpeedF = 6

---------------------------------------------------------------------------------
-- Variáveis

local x1, x2 -- Usado para identificar o sentido do movimento
local direction
local canMove
local isCheckingCollisions
local score
local txtScore
local waveNumber
local canResetWave

---------------------------------------------------------------------------------
	-- Objetos

local backGround
local sheep
local btnPause
local enemies = {}
local cloudsBackGroundFirst = {}
local cloudsBackGroundSecond = {}
local cloudsGroupFirst = display.newGroup( )
local cloudsGroupSecond = display.newGroup( )


----------------------------------------------------------------------------------
-- Funcões

local function AddPhysics( )
	physics.start( )
	physics.setGravity( 0, 0 )

	local sheepOutLine = graphics.newOutline(1, sheepFile)
	physics.addBody( sheep, {outline = sheepOutLine, isSensor =true })
	
	local stickerOutLine = graphics.newOutline(1, stickerFile)
	for i=1,#enemies do
		physics.addBody( enemies[i] , {outline = stickerOutLine})
	end
end


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
    local objectSize = (obj2.width/2) + (obj1.width/2)
    
    if distance < objectSize then

        return true

    end
	
    return false
	
end


local function GameOver( )
	
	transition.cancel()
	composer.gotoScene( "screens.gameOver", "fade", 400 )

end

local function CheckingCollisions( )

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

local function DisplayWaveText( num )
	
	local tempestText = display.newImage( tempestFiles[num], centerX, centerY)
	tempestText.display = false
	tempestText:scale(0, 0) 

	transition.scaleTo( tempestText, { xScale = 1, yScale = 1, time = 1000, 
	onComplete = function ( )
		transition.scaleTo( tempestText, { xScale = 0.1, yScale = 0.1, time = 1000, transition = easing.inElastic,
		onComplete = function ()
			tempestText:removeSelf( )
			tempestText = nil
			respawnEnemies()
			canResetWave = true
		end } )
	end } )


end

local function ResetWave( )

	lastEnemie = enemies[#enemies]

	if ( lastEnemie.y < -20 and canResetWave ) then

		canResetWave = false
		waveNumber = waveNumber + 1		

		if(waveNumber == 6) then
			GameOver()
		else 
			DisplayWaveText( waveNumber )
		end
		
	end

end

local function UpdateScore( )
	
	for i=1, #enemies do
		if (enemies[i].y < 0 and enemies[i].isVisible) then
			enemies[i].isVisible = false
			score = score + 1
			txtScore.text = score
		end
	end
end

local function AnimateSheep( )

	if(sheep.anime) then 

		sheep.anime = false

		if(reverse == 0) then
			transition.to( sheep, { rotation=-45, time=1000, transition=easing.inOutCubic, 
			onComplete = function() 
				reverse = 1
				sheep.anime = true
			end
			})
		else
			transition.to( sheep, { rotation= 45, time=1000, transition=easing.inOutCubic, 
			onComplete = function() 
				reverse = 0
				sheep.anime = true
			end
			})
		end
	end
end

local function AnimateEnemies( )

	for i=1, #enemies  do
		if(enemies[i].anime) then
			enemies[i].anime = false
			if (enemies[i].rotation == 15) then
				transition.to( enemies[i], { rotation = -15, time = 500, transition = easing.inOutCubic, 
				onComplete = function ()
					enemies[i].anime = true
				end
				})
			elseif (enemies[i].rotation == -15) then 
				transition.to( enemies[i], { rotation = 15, time = 500, transition = easing.inOutCubic,
				onComplete = function ()
					enemies[i].anime = true
				end
				})
			end
		end
	end
end

local function MoveBackGround( )

	cloudsGroupFirst.y = cloudsGroupFirst.y - 1
	cloudsGroupSecond.y = cloudsGroupSecond.y - 1

	if(cloudsGroupFirst.y < -_H) then

		for i=1, #cloudsBackGroundFirst do
			
		local randX = random(0, _W)
		local randY = random(0, _H)

		cloudsBackGroundFirst[i].x = randX
		cloudsBackGroundFirst[i].y = randY

		end

		cloudsGroupFirst.y = _H + 50

	end

	if(cloudsGroupSecond.y < -_H) then

		for i=1, #cloudsBackGroundSecond do
		
		local randX = random(0, _W)
		local randY = random(0, _H)

		cloudsBackGroundSecond[i].x = randX
		cloudsBackGroundSecond[i].y = randY

		end

		cloudsGroupSecond.y = _H + 50

	end

end

local function gameLoop( )

	CheckingCollisions( )
	MoveEnemies( )
	MoveBackGround( )
	AnimateSheep( )
	AnimateEnemies( )
	ValidateCanMove( )
	ResetWave( )
	UpdateScore( )

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
	Runtime:removeEventListener( "enterFrame", gameLoop )
	btnPause:removeEventListener( "tap", Pause )

	-- physics.stop( )

end

----------------------------------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	cloudsGroupFirst = display.newGroup( )
	cloudsGroupSecond = display.newGroup( )

	--Create backGround

	-- backGround = display.newImage( backGroundFile, centerX, centerY )
	backGround = display.newRect( centerX, centerY, 380, 570 )
	backGround:setFillColor( 0.5, 0.8, 1 )
	sceneGroup:insert(backGround)

	for i=1, cloudsDensity do

		local randCloud = random(1, #cloudFiles)
		local randX = random(0, _W)
		local randY = random(0, _H)

		cloudsBackGroundFirst[i] = display.newImage( cloudFiles[randCloud] , randX, randY )
		cloudsBackGroundSecond[i] = display.newImage( cloudFiles[randCloud] , randX, randY )

		cloudsGroupFirst:insert( cloudsBackGroundFirst[i] )
		cloudsGroupSecond:insert( cloudsBackGroundSecond[i] )

	end
	cloudsGroupSecond.y = cloudsGroupSecond.y + _H
	sceneGroup:insert( cloudsGroupFirst )
	sceneGroup:insert( cloudsGroupSecond )

	--Create Player

	sheep =  display.newImage( sheepFile, center, centerY )
	sheep.anime = true
	sceneGroup:insert(sheep)

	--Create Enemies

	for i=1,10 do
		enemies[i] = display.newImage( stickerFile, 100, 100 )
		enemies[i].isVisible = false
		enemies[i].rotation = 15
		enemies[i].anime = true
		sceneGroup:insert(enemies[i])
	end

	--Create UI

	btnPause = widget.newButton{ defaultFile = btnPauseFile, onRelease = common.btnAnimation }
	btnPause.x = _W - 30
	btnPause.y = 30
	btnPause.action = Pause

	 sceneGroup:insert(btnPause)

	txtScore = display.newText( "", center, 30, "Comic Sans MS", 40 )
	sceneGroup:insert( txtScore )

	--Eventos
	Runtime:addEventListener( "touch", Move )


end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

	-- respawnEnemies()

	elseif phase == "did" then

	-- AddPhysics()

	canMove = true
	canResetWave = false
	isCheckingCollisions = false
	score = 0
	txtScore.text = score
	waveNumber = 1
	DisplayWaveText( waveNumber )

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