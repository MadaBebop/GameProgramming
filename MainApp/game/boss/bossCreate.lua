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
end
    --==================== FINE ANIMAZIONI =======================--

    local boss = display.newSprite(bossSheet, bossSequence) -- creazione del boss
    boss:setSequence("Idle")
    boss:play()
    --Creazione del corpo fisico
    physics.addBody(boss, "dynamic",{radius = 50} )
return M
