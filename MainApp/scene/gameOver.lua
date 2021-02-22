local composer = require 'composer'

local scene = composer.newScene()

-- VARIABILI
local gameOver
local gameOverAudio



function scene:create(event)
    local sceneGroup = self.view

    gameOver = display.newImageRect(sceneGroup, 'scene/img/gameover.png', 480, 320)
    gameOverAudio = audio.loadSound('music/gameoverSound.mp3')

end


-- Funzione per tornare al menu
local function returnToMenu()
    -- composer.removeScene('scene.menu')
    composer.gotoScene('scene.menu', {effect = 'fade', time = '500'})
    
end


function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == 'will') then
        gameOver.x = display.contentCenterX
        gameOver.y = display.contentCenterY
    elseif (phase == 'did') then
        gameOver.tap = returnToMenu
        gameOver:addEventListener('tap', returnToMenu)
        audio.play(gameOverAudio, {loop = -1, channel = 2})
    end
end


function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == 'will') then
        gameOver:removeEventListener('tap', returnToMenu)
        audio.pause(gameOverAudio)
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