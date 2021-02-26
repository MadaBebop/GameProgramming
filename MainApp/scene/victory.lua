local composer = require 'composer'

local scene = composer.newScene()

-- VARIABILI
local victory
local victoryAudio



function scene:create(event)
    local sceneGroup = self.view

    victory = display.newImageRect(sceneGroup, 'scene/img/victory.png', 480, 320)
    victoryAudio = audio.loadSound('music/victorySound.mp3')
end
 -- end create

-- Funzione per tornare al menu
local function returnToMenu()
    composer.removeScene('scene.menu')
    composer.gotoScene('scene.menu', {effect = 'fade', time = 500})

end


function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == 'will') then

        victory.x = display.contentCenterX
        victory.y = display.contentCenterY

    elseif (phase == 'did') then

        victory.tap = returnToMenu
        victory:addEventListener('tap', returnToMenu)
        audio.play(victoryAudio, {loop = -1, channel = 3})

    end
end


function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == 'will') then
        victory:removeEventListener('tap', returnToMenu)
        audio.fadeOut({channel = 3, time= 400})

    elseif (phase == 'did') then

    end
end


function scene:destroy( event )
	local sceneGroup = self.view

end



scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
