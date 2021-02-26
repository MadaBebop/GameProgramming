local M = {}

function M.createZombie()
    
    --========== CARICO TUTTE LE ANIMAZIONI DELLO ZOMBIE ===========================
    local idleData = {width = 65, height = 78, numFrames = 15, sheetContentWidth = 975, sheetContentHeight = 78}
    local idleSheet = graphics.newImageSheet("game/zombie/IdleSheet.png", idleData)

    local walkData = {width = 65, height = 78, numFrames = 10, sheetContentWidth = 650, sheetContentHeight = 78}
    local walkSheet = graphics.newImageSheet("game/zombie/walkSheet.png", walkData)

    local deathData = {width = 88, height = 74, numFrames = 12, sheetContentWidth = 1056, sheetContentHeight = 74}
    local deathSheet = graphics.newImageSheet('game/zombie/deathSheet.png', deathData)


    local zombieSequences = {
        {
            name = 'Idle',
            sheet = idleSheet,
            start = 1,
            count = 15,
            time = 1500,
            loopCount = 0,
            loopDirection = "bounce"
        },
        {
            name = "Walk",
            sheet = walkSheet,
            start = 1,
            count = 10,
            time = 500,
            loopCount = 0,
            loopDirection = "forward"
        },
        {
            name = "Death",
            sheet = deathSheet,
            start = 1,
            count = 12,
            time = 500,
            loopCount = 1,
            loopDirection = "forward"
        }   
    }

    local zombie = display.newSprite(idleSheet, zombieSequences)
    zombie.type = 'zombie'
    local zombieShape = { -12,18 , 12,18 , 12,-15 ,-12,-15 }
    physics.addBody(zombie, 'dynamic', {friction = 1.0, density = 3.5, shape = zombieShape})
    zombie:scale(-0.5, 0.5)
    zombie:setSequence('Idle')
    zombie:play()
    zombie.isFixedRotation = true
    zombie.isDead = false


    -- Questa funzione viene chiamata quando la collisione tra zombie e proiettile è terminata
    -- Si occupa di rimuovere lo zombie
    -- Per la rimozione dello zombie abbiamo preferito scrivere a parte questa funzione per far si che essa potesse
    -- essere chiamata in secondo momento (tramite il transition.fadeOut) e lasciare che l'animazione di morte venisse eseguita correttamente
    local function removeDeadBodies()
        zombie.isDead = true 
        zombie:removeSelf()
        zombie = nil  
    end

    -- Funzione per gestire la collisione con lo zombie
    function collision (event)
        local phase = event.phase
        local other = event.other
        
        if (phase == 'began') then
            if (other.type == 'bullet') then
                zombie:setSequence('Death')
                zombie:play()
            end
        elseif (phase == 'ended') then
            if (other.type == 'bullet') then
                other:removeSelf()
                other = nil
                transition.fadeOut(event.target, {time = 350, onComplete = removeDeadBodies})
            end

        end 

    end

    zombie:addEventListener('collision', collision)




    return zombie
end

return M