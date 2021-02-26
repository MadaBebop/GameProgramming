------------------
--- LIBRERIE
------------------
local composer = require "composer"
local tiled = require "com.ponywolf.ponytiled"
local physics = require "physics"
local json = require "json"
local robot = require 'game.hero.robot'
local zombie = require 'game.zombie.zombie'
local door = require 'game.lib.door'

----------------
--- Variabili
----------------
local map, hero, enemy, porta  -- dichiarazione delle variabili eroe mappa
-- Limiti della mappa
local mapLimitLeft = 0  
local mapLimitRight = 960 

local intro

-- Creazione di una nuova scena composer
local scene = composer.newScene()
local sceneGroup 


-- Funzione dello skip dell'intro
local function skipIntro()
	intro:removeSelf()
	intro = nil
	physics.start()
end

-- Funzione che controlla se l'eroe è morto, se true allora viene lanciata la scena di Game Over
function gameOver()
	if (hero.isDead) then
		audio.fadeOut({channel = 1, time = 400})
		composer.removeScene('scene.gameOver')
		composer.gotoScene('scene.gameOver', {effect = 'fade', time = 500})
	end
end


-------------
-- fase CREATE
-------------
function scene:create( event )

	sceneGroup = self.view  

	physics.start()
	physics.setDrawMode("normal")
	physics.setGravity( 0, 32 )

	intro = display.newImageRect('scene/img/infoinizio.png', 480, 320)

	-- Creazione della mappa grazie alla libreria Ponytiled 
	local filename =  'scene/maps/lvl1/livello1.json'
	local pathToTile = 'scene/maps/lvl1'  
	local mapData = json.decodeFile(system.pathForFile(filename, system.ResourceDirectory))
	map = tiled.new(mapData, pathToTile)


	-- Setting dei punti di ancoraggio della mappa
	map.anchorX = 0
	map.anchorY = 0

	--Carico il personaggio
	hero = robot.createRobot()

	-- Carico il nemico
	enemy = zombie.createZombie()

	-- Carico la porta
	porta = door.createDoor()
	physics.addBody(porta, 'static', {isSensor = true})


	-- I vari display objects vengono inseriti del al gruppo della scena corrente
	sceneGroup:insert( map )
	sceneGroup:insert( hero )
	sceneGroup:insert( enemy )
	sceneGroup:insert( porta )

end
-------------
-- fine CREATE
-------------


-- Funzione per il camera scroll 
local function moveCamera (event)
	local offsetX = 100
	local heroWidth = hero.width
	local displayLeft = -sceneGroup.x
	local nonScroll = display.contentWidth / 2

	if (hero.x >= mapLimitLeft + offsetX and hero.x <= mapLimitRight - nonScroll) then
		if (hero.x > displayLeft + nonScroll) then
			sceneGroup.x = -hero.x + nonScroll
		elseif (hero.x < displayLeft + offsetX) then
			sceneGroup.x = -hero.x + offsetX
		end
	end
	return true
end


--------------
-- inizio SHOW
--------------
function scene:show( event )
	sceneGroup = self.view

	local phase = event.phase
	if ( phase == "will" ) then
		-- Pos. Eroe
		hero.x = 200
		hero.y = 200
		-- Pos. Enemy
		enemy.x = 400
		enemy.y = 200
		-- Pos. Intro
		intro.x = display.contentCenterX
		intro.y = display.contentCenterY
		-- Pos porta
		porta.x = mapLimitRight - 50
		porta.y = 260


		-- Ascoltatori per il movimento di camera e il Game Over 
		Runtime:addEventListener('enterFrame', moveCamera)
		Runtime:addEventListener('enterFrame', gameOver)
		

	elseif ( phase == "did" ) then
		intro.tap = skipIntro
		intro:addEventListener('tap', skipIntro)
	end

end
---------------
--- fine SHOW
---------------


-------------
--inizio HIDE
-------------
function scene:hide( event )
	sceneGroup = self.view

	local phase = event.phase
	if ( phase == "will" ) then

		--Rimozione degli ascoltatori della scena
		Runtime:removeEventListener('enterFrame', moveCamera)
		Runtime:removeEventListener('enterFrame', gameOver)

	elseif ( phase == "did" ) then
					
	end
end
--------------
--  fine HIDE
--------------

---------------
-- inizio DESTROY
---------------
function scene:destroy( event )
	sceneGroup = self.view

end
--------------
-- end DESTROY
--------------

---------
--ASCOLTATORI
---------
-- Ascoltatori scene
scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")


return scene --fine
