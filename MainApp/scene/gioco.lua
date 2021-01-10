
-- Composer
local composer = require "composer"
-- Fisica
local physics = require('physics')
-- Funzioni dei personaggi
local zombie = require('scene.zombie')
local xeon = require('scene.xeon')

-- Variables local to scene
--
local hero, enemy -- , map
--
-- NB. Le variabili come piattaforma non serviranno più quando avremo la mappa.la quale verrà creata interamente come variabile.
--

-- Create a new Composer scene
local scene = composer.newScene()

---------
--CREATE
---------
function scene:create( event )

	local sceneGroup = self.view  -- Add scene display objects to this group

-- NB---------------------------------------------------------------------------

	--creazione della piattaforma
local platform = display.newRect(0, display.contentHeight - 10, 3840, 20)
physics.addBody(platform, "static", {bounce = 0, friction = 0.5})

-- pulsanti temporanei per testare movimento e salto                           -- Tutti questi non serviranno con la mappa
local button = display.newRect(560,display.contentCenterY,50,50)
local jump = display.newRect(750,display.contentCenterY,50,50)

--creazione dello zombie + movimento + ronda
enemy = zombie.new()
zombie.initialize(enemy, 400, 200)
zombie.movement(enemy, 130, 300, 600)
-- NB --------------------------------------------------------------------------

--sounds here*

--end sounds
-- Inizio della fisica prima del caricamento della mappa
physics.setDrawMode("hybrid")
-- gravità? physics.setGravity( 0, 32 )
physics.start()

--Caricamento della mappa
--Individuazione campione, nemici  etc.

-- Toccare la rotella per tornare al menu ?
-- function rotella:tap(event)
	-- fx.fadeOut( function()
		--	composer.gotoScene( "scene.menu")
	-- end )
-- end
-- con l'ascoltatore associato -> rotella:addEventListener("tap")

-- Insert our game items in the correct back-to-front order
-- sceneGroup:insert( map )
-- sceneGroup:insert( score ) ?
-- sceneGroup:insert( rotella )

end -- fine del creazione

-- Function to scroll the map
local function enterFrame(event)

	local elapsed = event.time
	-- DA IMPLEMENTARE MAGARI IN UNO DEI FILE CON FUNZIONI
	-- ESEMPIO DI SCROLLING DEL PERSONAGGIO EROE
	--if hero and hero.x and hero.y and not hero.isDead then
		---local x, y = hero:localToContent( 0, 0 )
		--x, y = display.contentCenterX - x, display.contentCenterY - y
		--map.x, map.y = map.x + x, map.y + y
		-- Easy parallax
		--if parallax then
			--parallax.x, parallax.y = map.x / 6, map.y / 8  -- Affects x more than y
		--end
	--end
	--end -- fine funzione
	--
end -- fine scrolling

local function xeonMove(event)
    xeon.moveXeon(hero, event)
end

local function xeonJump(event)
    xeon.jumpXeon(hero, event)
end
-- Queste funzioni sono da richiamare e basta (?)

-- ASCOLTATORI funzioni
button:addEventListener("touch", xeonMove)
jump:addEventListener("tap", xeonJump)

---------
-- SHOW
---------
function scene:show( event )

	local phase = event.phase
	if ( phase == "will" ) then
		fx.fadeIn() -- Dissolvenza
		Runtime:addEventListener( "enterFrame", enterFrame )
	elseif ( phase == "did" ) then
		-- Avviare un rumore di cambio scena
		-- For more details on options to play a pre-loaded sound, see the Audio Usage/Functions guide:
		-- https://docs.coronalabs.com/guide/media/audioSystem/index.html
		-- Ex. audio.play( self.sounds.wind, { loops = -1, fadein = 750, channel = 15 } )
	end

end --end show

---------
-- HIDE
---------
function scene:hide( event )

	local phase = event.phase
	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
		Runtime:removeEventListener( "enterFrame", enterFrame )
	end

end -- end hide

---------
-- DESTROY
---------
function scene:destroy( event )
  --collectgarbage()

end -- end destroy

---------
--ASCOLTATORI
---------
-- Ascoltatori scene
scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")
--Ascoltatori oggetti


return scene --fine
