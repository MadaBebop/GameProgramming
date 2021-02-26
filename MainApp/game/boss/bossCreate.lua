local M = {}

function M.createBoss()

    --========== CARICO TUTTE LE ANIMAZIONI DEL BOSS ===========================
    local idleData = {width = 464, height = 467, numFrames = 26, sheetContentWidth = 2784, sheetContentHeight = 2335}
    local bossSheet = graphics.newImageSheet("game/boss/bossspritesheet.png", idleData)

    local bossSequence = {
            name = "Idle",
            sheet = bossSheet,
            start = 1,
            count = 26,
            time = 1600,
            loopCount = 0,
            loopDirection = "forward"
        }

        --==================== FINE ANIMAZIONI =======================--
    local boss = display.newSprite(bossSheet, bossSequence) -- creazione del boss
    boss:setSequence("Idle")
    boss:play()
    --Creazione del corpo fisico
    boss.type= "boss"
    boss.isDead = false
    physics.addBody(boss, "static",{radius = 60} )
    boss:scale(0.5,0.5)

    -- Funzione per la rimozione del boss una volta morto, viene richiamata dalla funzione onCollision()
    local function removeBoss()
        boss.isDead = true
        boss:removeSelf()
        boss = nil
    end

    -- Funzione di collisione per il boss
    function onCollision( event )
        local phase = event.phase
        local other = event.other

        if (phase == 'began') then
            if (other.type == 'bullet') then
                -- Quando il boss viene colpito lo facciamo lampeggiare
                transition.blink(boss, {time = 800})
            end
        elseif(phase == 'ended') then
            -- Qui viene eliminato l'oggetto che ha colliso con il boss
            other:removeSelf()
            other = nil
            timer.performWithDelay(2500, removeBoss)
          end
    end

    boss:addEventListener('collision', onCollision)

    return boss
end


return M
