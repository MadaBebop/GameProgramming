--------------------------------------------------------------------------------
-- MENU' DEL GIOCO:
--------------------------------------------------------------------------------

--------------------------------------------
-- Librerie
--------------------------------------------
--Utilizzo della libreria composer con annessa creazione della scena
local composer = require "composer"
local widget = require "widget" -- widget library per il bottone di avvio e lo slider


local scene = composer.newScene()

-- Dichiarazioni variabili 
local background
local playBtn
local slider
local music



-- Funzione per far partire il livello 1 alla pressione del tasto play
local function onPlayBtnRelease()
	composer.removeHidden() -- é necessario
	-- composer.gotoScene( "scene.livello1", {params = {}})
	composer.gotoScene( "scene.livello1")
end


-- Ascoltatore dello slider per il volume
local function sliderListener( event )
	audio.setVolume(event.value/100)
end

---------
--- fase CREATE
--------
function scene:create( event )
	local sceneGroup = self.view

	-- Caricamento del background del menu
	background = display.newImageRect( "scene/menusrc/background.png", display.actualContentWidth, display.actualContentHeight )


	-- Creazione del widget bottone (Il quale carichera il gioco)
	playBtn = widget.newButton{ --creazione delle caratteristiche del bottone
		labelColor = { default={ 1.0 }, over={ 0.5 } }, -- colore dell'etichetta
		defaultFile = "scene/menusrc/button.png",   --
		overFile = "scene/menusrc/button-over.png", --
		width = 154, height = 40,  -- Dimensioni
		onRelease = onPlayBtnRelease	--Chiamata alla funzione del bottone!
	}


	
	-- Creazione dello slider per il controllo del volume
	slider = widget.newSlider( -- definizione delle caratteristiche dello slider
    {
        x = display.contentWidth - 40, -- posizionamento
        y = 100,
				orientation = "vertical",
        height = 100,
        value = 50,  -- Start slider at 50% (optional)
        listener = sliderListener
    } )


	--Inserimento della musica e avvio
	music = audio.loadStream("music/WBA Free Track.mp3")
	audio.setVolume(0.5, {channel = 1}) -- volume std al 50%


	-- Inserimento dei display object all'interno del gruppo scena principale
	sceneGroup:insert( background ) 
	sceneGroup:insert( playBtn )  
	sceneGroup:insert( slider ) 

end

------------
--- scena SHOW
-----------
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Posizionamento dei vari display objects
		background.anchorX = 0
		background.anchorY = 0
		background.x = 0 + display.screenOriginX
		background.y = 0 + display.screenOriginY
		playBtn.x = display.contentCenterX
		playBtn.y = display.contentHeight - 125
	elseif phase == "did" then
		audio.play(music,{loops=-1, channel = 1}) 

	end
end

---------
-- scena HIDE
---------
-- Nascondere la scena
function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then


	elseif phase == "did" then


	end
end

---------
--- DESTROY
---------
-- Distruzione della scena
function scene:destroy( event )
	local sceneGroup = self.view

	-- Rimozione dei widget bottone play e slider volume
	if (playBtn) then
		playBtn:removeSelf()	
		playBtn = nil
	end

	slider:removeSelf()
	slider = nil

end


-- ASCOLTATORI della scena
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene  -- FINE MENU
