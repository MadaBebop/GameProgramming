-- Cutscene

-- Include modules/libraries
local composer = require( "composer" )

-- Variables local to scene
local prevScene = composer.getSceneName( "previous" )

-- Create a new Composer scene
local scene = composer.newScene()

function scene:show( event )

	local phase = event.phase

	if ( phase == "will" ) then
		composer.removeScene( prevScene )
	elseif ( phase == "did" ) then
		composer.gotoScene("scene.livello2") -- avvio il livello 2
	end
end

scene:addEventListener( "show", scene )

return scene
