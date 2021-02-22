------------------
--- LIBRERIE
------------------
local composer = require "composer"
local tiled = require "com.ponywolf.ponytiled"
local physics = require "physics"
local json = require "json"
local robot = require 'game.hero.robot'
local zombie = require 'game.zombie.zombie'

----------------
--- Variabili
----------------
--Creazione della variabile contenente i dati della mappa e la mappa stessa
local map, hero, enemy, door  -- dichiarazione delle variabili eroe mappa
local mapLimitLeft = 0  -- definizione dei limiti della mappa sx
local mapLimitRight = 960 -- lim dx

local intro
-- creazione di una nuova scena composer
local scene = composer.newScene()
local sceneGroup -- crazione variabile del group


-- Funzione dello skip dell'intro
local function skipIntro()
	intro:removeSelf()
	-- intro = nil
	physics.start()
end

function gameOver() 
	if (hero.isDead) then
		-- composer.removeScene('scene.gameOver')
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
	physics.pause() -- metto in pausa per poter caricare tutti gli oggetti senza grandi costi di elaborazione
	physics.setGravity( 0, 32 )

	intro = display.newImageRect('scene/img/infoinizio.png', 480, 320)

-- Inserisco nella variabile mappa i dati inerenti alla mappa .json
	local filename = 'scene/maps/lvl1/livello1.json'
	local mapData = json.decodeFile(system.pathForFile(filename, system.ResourceDirectory))
	map = tiled.new(mapData, "scene/maps/lvl1")

	--Posizionamento della mappa
	map.anchorX = 0
	map.anchorY = 0

	--Carico il personaggio
	hero = robot.createRobot()

	-- Carico il nemico
	enemy = zombie.createZombie()

	door = display.newRect(20,20 , 20,20 , 20,20 , 20,20)
	door.x = mapLimitRight - 50
	door.y = 270
	door:setFillColor( 0.5 )
	-- door.isVisible = false
	door.type = 'door'



-- GRUPPI SCENE --
-- Insert our game items in the correct back-to-front order
sceneGroup:insert( map )
sceneGroup:insert( hero )
sceneGroup:insert( enemy )
sceneGroup:insert( door )

end
-------------
-- fine CREATE
-------------

---------------
-- CAMERA SCROLL
---------------

local function moveCamera (event)
	local offsetX = 100
	local heroWidth = hero.width
	local displayLeft = -sceneGroup.x
	local nonScroll = display.contentWidth - heroWidth

	if (hero.x >= mapLimitLeft + heroWidth and hero.x <= mapLimitRight - heroWidth) then
		if (hero.x > displayLeft + nonScroll) then
			sceneGroup.x = -hero.x + nonScroll
		elseif (hero.x < displayLeft + heroWidth) then
			sceneGroup.x = -hero.x + heroWidth
		end
	end
end


local function checkZombieDead(event)
	if (enemy.isDead) then
		physics.addBody(door, 'static', {isSensor = true})
	end
end


local function changeLevel(event) 
	if (hero.isCollidingWithDoor) then
		physics.stop()
		composer.removeScene('scene.livello2')
		composer.gotoScene('scene.livello2')
	end
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

		-- Creazione ASCOLTATORI

		-- Ascoltatore intro
		Runtime:addEventListener('enterFrame', moveCamera)
		Runtime:addEventListener('enterFrame', gameOver)
		Runtime:addEventListener('enterFrame', checkZombieDead)
		Runtime:addEventListener('enterFrame', changeLevel)

		-- restart physics è nella funzione skip intro!

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

	elseif ( phase == "did" ) then
		--Rimozione degli ascoltatori della scena
		Runtime:removeEventListener('enterFrame', moveCamera)
		Runtime:removeEventListener('enterFrame', gameOver)
		Runtime:removeEventListener('enterFrame', checkZombieDead)
		Runtime:removeEventListener('enterFrame', changeLevel)

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
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)


return scene --fine
