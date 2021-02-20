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
local map, hero, enemy  -- dichiarazione delle variabili eroe mappa
local mapLimitLeft = 0  -- definizione dei limiti della mappa sx
local mapLimitRight = 960 -- lim dx
local intro
-- creazione di una nuova scena composer
local scene = composer.newScene()
local sceneGroup -- crazione variabile del group


local function skipIntro()
	intro:removeSelf()
	intro = nil
	physics.start()
end

-------------
-- fase CREATE
-------------
function scene:create( event )

	sceneGroup = self.view  -- Add scene display objects to this group
	sceneGroup.anchorX = 0
	sceneGroup.anchorY = 0
	sceneGroup.anchorChildren = true

	--sounds here*
  -- end sound

	physics.start()
	physics.setDrawMode("hybrid")
	physics.pause() -- metto in pausa per poter caricare tutti gli oggetti senza grandi costi di elaborazione
	physics.setGravity( 0, 32 )

	intro = display.newImageRect('scene/img/infoinizio.png', 480, 320)

	local filename = 'scene/maps/lvl1/livello1.json'
	local mapData = json.decodeFile(system.pathForFile(filename, system.ResourceDirectory))
	map = tiled.new(mapData, "scene/maps/lvl1")

	--Posizionamento della mappa
	map.anchorX = 0
	map.anchorY = 0


	--Carico il personaggio
	hero = robot.createRobot()
	print(hero.type)
	
	-- Carico il nemico e per controllo verifico se enemy.type torna il tipo del nemico
	enemy = zombie.createZombie()
	print(enemy.type)

-- GRUPPI SCENE --
-- Insert our game items in the correct back-to-front order
sceneGroup:insert( map )
sceneGroup:insert( hero )
sceneGroup:insert( enemy )

end -- fine del creazione
-------------
-- fine CREATE
-------------

------------
----Camera scroll function
------------

local function moveCamera (event) 
	local offsetX = 100
	local heroWidth = hero.width
	local displayLeft = -sceneGroup.x
	local nonScrollingWidth = display.contentWidth - offsetX
	local nonScroll = display.contentWidth - heroWidth

	if (hero.x >= mapLimitLeft + heroWidth and hero.x <= mapLimitRight - heroWidth) then
		if (hero.x > displayLeft + nonScroll) then
			sceneGroup.x = -hero.x + nonScroll
		elseif (hero.x < displayLeft + heroWidth) then
			sceneGroup.x = -hero.x + heroWidth
		end
	end

end
---------------
--- Fine camera scrolling
---------------


------------
-- fase SHOW
------------
function scene:show( event )
	local sceneGroup = self.view

	local phase = event.phase
	if ( phase == "will" ) then
		hero.x = 200
		hero.y = 200
		enemy.x = 400
		enemy.y = 200
		intro.x = display.contentCenterX
		intro.y = display.contentCenterY
		Runtime:addEventListener('enterFrame', moveCamera)
	elseif ( phase == "did" ) then
		-- Avviare un rumore di cambio scena
		intro.tap = skipIntro
		intro:addEventListener('tap', skipIntro)
	end

end
---------------------------
--- fine SHOW
---------------------------


-------------
--fase HIDE
-------------
function scene:hide( event )
	local sceneGroup = self.view

	local phase = event.phase
	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
		Runtime:removeEventListener('enterFrame', moveCamera)

	end

end
--------------
--  fine HIDE
--------------

---------------
-- fase DESTROY
---------------
function scene:destroy( event )
	local sceneGroup = self.view
  --collectgarbage()

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
