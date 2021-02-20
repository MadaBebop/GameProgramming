--------------------------------------------------------------------------------
-- MENU' DEL GIOCO:
--------------------------------------------------------------------------------

--------------------------------------------
-- Librerie
--------------------------------------------
--Utilizzo della libreria composer con annessa creazione della scena
local composer = require "composer"
local widget = require "widget" -- widget library per il bottone di avvio e lo slider

--------------------------------------------
-- Dichiarazioni locali
--------------------------------------------
-- creazione nuova scena composer
local scene = composer.newScene()

---bottone e suo ascoltatore
local playBtn -- Creazione del bottone che darà inizio al livello 1
-- Ascoltatore del bottone
local function onPlayBtnRelease()
			composer.gotoScene( "scene.livello1")
end

--- slider e suo ascoltatore
local slider -- creazione dello slider
-- Ascoltatore dello slider
local function sliderListener( event )
		audio.setVolume(event.value/100)
end

---------
--- fase CREATE
--------
function scene:create( event )
	local sceneGroup = self.view -- Chiamata quando la scena non esiste

	-- background
	local background = display.newImageRect( "scene/menusrc/background.png", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX
	background.y = 0 + display.screenOriginY

	---
	-- Creazione del widget bottone (Il quale carichera il gioco)
	---
	playBtn = widget.newButton{ --creazione delle caratteristiche del bottone
		labelColor = { default={ 1.0 }, over={ 0.5 } }, -- colore dell'etichetta
		defaultFile = "scene/menusrc/button.png",   --
		overFile = "scene/menusrc/button-over.png", --
		width = 154, height = 40,  -- Dimensioni
		onRelease = onPlayBtnRelease	--Chiamata alla funzione del bottone!
	} -- Fine del bottone

	playBtn.x = display.contentCenterX  --Posizionamento del bottone x,y
	playBtn.y = display.contentHeight - 125
	------
	-- Fine Bottone
	------

	-----
	-- Slider
	-----
	slider = widget.newSlider( -- definizione delle caratteristiche dello slider
    {
        x = 500, -- posizionamento
        y = 120,
				orientation = "vertical",
        height = 100,
        value = 50,  -- Start slider at 50% (optional)
        listener = sliderListener
    } )
	---------------
	--- fine slider
	---------------

	--Inserimento della musica
	local music = audio.loadStream("music/WBA Free Track.mp3")
	audio.setVolume(0.5)
	audio.play(music,{loops=-1})

	-- Inserimento GRUPPI delle scene
	sceneGroup:insert( background ) --Sfondo
	sceneGroup:insert( playBtn )  --Bottone
	sceneGroup:insert( slider ) -- slider

end -- Fine della creazione degli oggetti


------------
--- SHOW
-----------
-- Mostrare la scena
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then

	end
end

---------
--HIDE
---------
-- Nascondere la scena
function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

---------
--- DESTROY
---------
-- Distruzione della scena
function scene:destroy( event )
	local sceneGroup = self.view

	background:removeSelf()
	background = nil
	composer.removeScene('menu')

	if playBtn then
		playBtn:removeSelf()	-- I widget devono essere eliminati manualmente
		playBtn = nil
	end

	slider:removeSelf( )
	
end
---------------------------------------------------------------------------------
-- ASCOLTATORI della scena
---------------------------------------------------------------------------------

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene  --FINE MENU
