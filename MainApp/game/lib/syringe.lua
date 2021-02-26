-- Modulo per la siringa, si occupa della sua creazione grafica e del suo inserimento nel mondo fisico
-- Si occupa inoltre di gestire la collisione e il conseguente raccoglimento da parte dell'eroe
local M = {}

function M.createSyringe() 

    local syringe = display.newImage('scene/maps/lvl2/siringe.png')
    physics.addBody(syringe, 'static', {bounce = 0.0, isSensor = true})
    syringe.type = 'syringe'
    syringe.isPicked = false

    function onCollision( event )
        local phase = event.phase
        local other = event.other
        if (phase == 'began') then
            if (other.type == 'robot') then
                syringe.isPicked = true
                syringe:removeSelf()
                syringe = nil
            end
        end
    end

    syringe:addEventListener('collision', onCollision)

    return syringe

end

return M