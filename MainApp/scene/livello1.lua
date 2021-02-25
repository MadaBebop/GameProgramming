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
--Creazione della variabile contenente i dati della mappa e la mappa stessa
local map, hero, enemy, porta  -- dichiarazione delle variabili eroe mappa
local mapLimitLeft = 0  -- definizione dei limiti della mappa sx
local mapLimitRight = 960 -- lim dx

local intro

-- creazione di una nuova scena composer
local scene = composer.newScene()
local sceneGroup -- crazione variabile del group


-- Funzione dello skip dell'intro
local function skipIntro()
	intro:removeSelf()
	intro = nil
	physics.start()
end


function gameOver()
	if (hero.isDead) then
		composer.removeScene('scene.gameOver')
		composer.gotoScene('scene.gameOver', {effect = 'fade', time = 500})
	end
end


-------------
-- fase CREATE
-------------
function scene:create( event )

	sceneGroup = self.view  -- Add scene display objects to this group
	sceneGroup.anchorX = 0
	sceneGroup.anchorY = 0
	sceneGroup.anchorChildren = true

	physics.start()
	physics.setDrawMode("hybrid")
	physics.setGravity( 0, 32 )

	intro = display.newImageRect('scene/img/infoinizio.png', 480, 320)

	-- Inserisco nella variabile mappa i dati inerenti alla mappa .json
	local filename =  event.params.map or 'scene/maps/lvl1/livello1.json'
	local pathToTile = event.params.path or 'scene/maps/lvl1'  
	local mapData = json.decodeFile(system.pathForFile(filename, system.ResourceDirectory))
	map = tiled.new(mapData, pathToTile)



	--Posizionamento della mappa
	map.anchorX = 0
	map.anchorY = 0

	--Carico il personaggio
	hero = robot.createRobot()

	-- Carico il nemico
	enemy = zombie.createZombie()

	-- Carico la porta
	porta = door.createDoor()
	porta.map = 'scene/maps/lvl2/livello2.json'
	porta.path = 'scene/maps/lvl2'



-- GRUPPI SCENE --
-- Insert our game items in the correct back-to-front order
sceneGroup:insert( map )
sceneGroup:insert( hero )
sceneGroup:insert( enemy )
sceneGroup:insert( porta )



end
-------------
-- fine CREATE
-------------




---------------
-- CAMERA SCROLL
---------------
-- Camera scrolling variabili

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

---------------
--- Fine CAMERA SCROLL
---------------

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

		-- Creazione ASCOLTATORI

		-- Ascoltatore intro
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
		Runtime:removeEventListener('enterFrame', moveCamera)
		Runtime:removeEventListener('enterFrame', gameOver)

	elseif ( phase == "did" ) then
		--Rimozione degli ascoltatori della scena
		
		
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
