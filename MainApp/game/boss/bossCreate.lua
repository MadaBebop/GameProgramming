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
    physics.addBody(boss, "static",{radius = 60} )
    boss:scale(0.5,0.5)


    return boss
end


return M
