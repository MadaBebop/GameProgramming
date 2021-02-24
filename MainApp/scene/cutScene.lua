-- Cutscene

-- Include modules/libraries
local composer = require( "composer" )

-- Variables local to scene
local prevScene = composer.getSceneName( "previous" )

-- Create a new Composer scene
local scene = composer.newScene()

function scene:show( event )

	local phase = event.phase
	-- local options = {params = event.params}
	local options = {params = {}}
	if ( phase == "will" ) then
		composer.removeScene( prevScene )
	elseif ( phase == "did" ) then
		composer.gotoScene('scene.livello2', options) -- avvio il livello 2
	end
end

scene:addEventListener( "show", scene )

return scene
