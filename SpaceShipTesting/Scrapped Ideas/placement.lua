function Gridify(ScreenHeight, ScreenWidth)
    TableGrid = {}
    for i=1, love.graphics.getWidth()/16, 1 do
        for j=1, love.graphics.getHeight()/16, 1 do
            table.insert(TableGrid, {x=(i*16), y=(j*16), width=16, height=16, occupied=false})
        end
    end
    return TableGrid
end

--                                                   SCRAPPED IDEA PLACEMENT
-- local mouseX, mouseY = love.mouse.getPosition()
-- local spots = Gridify(mouseX, mouseY)



-- local snapX = math.floor(mouseX / 16) * 16
-- local snapY = math.floor(mouseY / 16) * 16
-- love.graphics.rectangle("fill", snapX, snapY, 16, 16)
-- if love.mouse.isDown(1) then
--     for i = 1, #spots, 1 do
--         if spots[i].x == snapX and spots[i].y == snapY then
--             spots[i].occupied = true
--         end
--     end
-- end
-- for i = 1, #spots, 1 do
--     if spots[i].occupied then
--         love.graphics.rectangle("fill", spots[i].x, spots[i].y, spots[i].width, spots[i].height)
--     end
-- end

-- for i = 1, #lines, 1 do
--     love.graphics.rectangle("line", lines[i].x, lines[i].y, lines[i].width, lines[i].height)
-- end
--                                                   SCRAPPED IDEA PLACEMENT




                                    -- PARTICLE SYSTEMS

    -- ParticlesSpaceshipFire = love.graphics.newParticleSystem(love.graphics.newImage("Sprites/ParticleWhite.png"), 64)
    -- ParticlesSpaceshipFire:setParticleLifetime(.25,.5)
    -- ParticlesSpaceshipFire:setEmissionRate(128)
    -- ParticlesSpaceshipFire:setColors(255, 165, 255, 255, 255, 0, 0, 255)
    -- love.graphics.draw(ParticlesSpaceshipFire)
    --     ParticlesSpaceshipFire:setLinearAcceleration(0,0,Player.velocityX * 10, Player.velocityY * 10)
    -- ParticlesSpaceshipFire:setPosition(Player.x + (math.cos(math.rad(Player.rotX))) - 100,Player.y + (math.sin(math.rad(Player.rotX))))
    -- ParticlesSpaceshipFire:update(dt)
                                    --PArticles systems 