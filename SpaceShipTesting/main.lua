
function love.load()
    local Camera = require("Libraries/camera")
    Cam = Camera()

    ParticlesAsteroidDestroyed = love.graphics.newParticleSystem(love.graphics.newImage("Sprites/ParticleWhite.png"), 32)
    ParticlesAsteroidDestroyed:setParticleLifetime(.5, .75)
    ParticlesAsteroidDestroyed:setLinearAcceleration(-750, -750, 750, 750)
    ParticlesAsteroidDestroyed:setColors(255, 255, 255, 255, 255, 255, 255, 0)


    require("Scripts.inventory")
    require("Scripts.map")
    require("Scripts.WorldGen")
    LoveKeys = require("Libraries.LoveKeys")

    Player = {x=200,y=200,speed=.25,velocityX=0,velocityY=0,drag=.95, rotX=0, rotSpeed=3, mass=10}
    SpritePlayer = love.graphics.newImage("Sprites/space.png")
    TableProjectiles = {}
    PerMeteorMass = 50
    AsteroidDrag = .95
    TableAsteroids = {}
    SpawnAsteroids()

    InventoryDefault()

    DefineOverviewMap(TableAsteroids,{},{})


    NoiseMap = GenerateNoise(250,250)


end


function love.draw()
    Cam:attach()
        love.graphics.draw(ParticlesAsteroidDestroyed)
        

        if Emit then
            ParticlesAsteroidDestroyed:emit(8)
        end
        Emit = false
        
        
        love.graphics.rectangle("line",Player.x - 8, Player.y - 8, 16,16)
        --player sprite
        love.graphics.draw(SpritePlayer, Player.x, Player.y, math.rad(Player.rotX + 90), .25, .25, 32, 32, 0, 0)

        
        if #TableProjectiles > 0 then
            for i = 1, #TableProjectiles, 1 do
                love.graphics.circle("line",TableProjectiles[i].x,
                                            TableProjectiles[i].y, 2.5)
            end
        end
 
        for i = 1, #TableAsteroids, 1 do
            love.graphics.rectangle("fill",TableAsteroids[i].x,TableAsteroids[i].y,
            TableAsteroids[i].width,TableAsteroids[i].height)
        end
        for i = 1, #NoiseMap, 1 do
            
        end
    Cam:detach()
        

    -- if MinimapOpen then
    --     Minimap(Player.x,Player.y)
    -- end

    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()),10,10, 0, 1, 1)
    
    if InventoryIsOpen == false and MapIsOpen == false then
        love.graphics.print("Inventory Hold: Tab", 10, 25)
        love.graphics.print("Toggle MiniMap: T", 10, 40)
        love.graphics.print("Map Hold: G", 10, 55)
        love.graphics.print("Coordanites: " .. tostring(math.floor(Player.x)) .. ", " .. tostring(math.floor(Player.y)), 10, 70)
        love.graphics.print("Closest Asteroid: " .. tostring(math.floor(ClosestAsteroid.x)) ..  ", " .. tostring(math.floor(ClosestAsteroid.y)), 10, 85)
    elseif MapIsOpen then
        ShowMap(Player.x,Player.y)
    else
        InventoryOpen()
    end

            
end

function love.update(dt)
    ParticlesAsteroidDestroyed:update(dt)

    CloseAsteroid()
    UserInput()
    UpdateProjectiles(dt)
    Collisons()
    ProjectileDeletion(dt)
    Cam:lookAt(Player.x,Player.y)
end

function UserInput()
    if love.keyboard.isDown("w") then
        Player.velocityY = Player.velocityY - Player.speed
    end
    if love.keyboard.isDown("s") then
        Player.velocityY = Player.velocityY + Player.speed
    end
    if love.keyboard.isDown("a") then
        Player.velocityX = Player.velocityX - Player.speed
    end
    if love.keyboard.isDown("d") then
        Player.velocityX = Player.velocityX + Player.speed
    end
    if love.keyboard.isDown("j") then
        Player.rotX = Player.rotX - Player.rotSpeed
    end
    if love.keyboard.isDown("l") then
        Player.rotX = Player.rotX + Player.rotSpeed
    end
    if love.keyboard.isDown("space") then
        Shot = true
    else
        Shot = false
    end
    if love.keyboard.isDown("tab") then
        InventoryIsOpen = true
    else
        InventoryIsOpen = false
    end
    if love.keyboard.isDown("g") then
        MapIsOpen = true
    else
        MapIsOpen = false
    end
    Player.x = Player.x + Player.velocityX
    Player.y = Player.y + Player.velocityY
    Player.velocityX = Player.velocityX * Player.drag
    Player.velocityY = Player.velocityY * Player.drag
end


function UpdateProjectiles(dt)
    if Shot then
        table.insert(TableProjectiles, {x=Player.x +(math.cos(math.rad(Player.rotX))),
                                        y=Player.y +(math.sin(math.rad(Player.rotX))),
                                        speed=.5,velocityX=5, velocityY=5, angle=Player.rotX, dmg=5,time=1,curTime=0})            
    end
    for i = 1, #TableProjectiles, 1 do
        TableProjectiles[i].x = TableProjectiles[i].x + (math.cos(math.rad(TableProjectiles[i].angle)) * TableProjectiles[i].velocityX)
        TableProjectiles[i].y = TableProjectiles[i].y + (math.sin(math.rad(TableProjectiles[i].angle)) * TableProjectiles[i].velocityY)
        if TableProjectiles[i].velocityX > 0 then
            TableProjectiles[i].velocityX = TableProjectiles[i].velocityX + TableProjectiles[i].speed
        end
        if TableProjectiles[i].velocityX < 0 then
            TableProjectiles[i].velocityX = TableProjectiles[i].velocityX - TableProjectiles[i].speed
        end
        if TableProjectiles[i].velocityY > 0 then
            TableProjectiles[i].velocityY = TableProjectiles[i].velocityY + TableProjectiles[i].speed
        end
        if TableProjectiles[i].velocityY < 0 then
            TableProjectiles[i].velocityY = TableProjectiles[i].velocityY - TableProjectiles[i].speed
        end
    end
end


function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
            x2 < x1+w1 and
            y1 < y2+h2 and
            y2 < y1+h1
end


function Collisons()
    Destroyed = false
    for ast = 1, #TableAsteroids, 1 do
        if Destroyed then
            break
        end
        for rock = 1, #TableAsteroids[ast], 1 do
            local playerHit = CheckCollision(TableAsteroids[ast][rock].x,TableAsteroids[ast][rock].y,15,10, Player.x - 8, Player.y - 8, 16,16)
            if playerHit then
                -- print("PLAYER HIT", Player.x, " ", Player.y)
                for AsteroidHit = 1, #TableAsteroids, 250 do
                    FinalVelocity = (100 * Player.velocityX + Player.velocityY)/(Player.mass + 100)
                    print(FinalVelocity)
                    
                end
                UpdateAstroidPos(FinalVelocity,ast)
            end
        end
        
        for proj = 1, #TableProjectiles, 1 do
            local hit = CheckCollision(TableAsteroids[ast].x,TableAsteroids[ast].y,TableAsteroids[ast].width,TableAsteroids[ast].height,TableProjectiles[proj].x,TableProjectiles[proj].y,5,5)
            if hit then
                print("HIT", TableAsteroids[ast].x, " ", TableAsteroids[ast].y)
                AsteroidDamaged(ast,proj)
                table.remove(TableProjectiles, proj)
                Destroyed = true
                break
            end            
        end
    end
    
    
end


function SpawnAsteroids()
    -- 4 astroid rock types
    -- 1. rock filled rock
    -- 2. ice filled rock
    -- 3. iron filled rock
    -- 4. gold filled rock


    for i = 1, 5, 1 do
        table.insert(TableAsteroids, {x=love.math.random(1000,5000), y=love.math.random(1000,5000),width=10,height=10,health=love.math.random(5,20), mass=PerMeteorMass, drag=AsteroidDrag,velocityX=0, velocityY=0,type=love.math.random(1,4)})
        for j = 1, 250, 1 do
            local dir = love.math.random(1,4)
            if dir == 1 then
                table.insert(TableAsteroids, {x=TableAsteroids[#TableAsteroids].x + TableAsteroids[#TableAsteroids].width, y=TableAsteroids[#TableAsteroids].y, width=love.math.random(10,40), height=love.math.random(10,40),health=love.math.random(5,20),mass=PerMeteorMass,type=love.math.random(1,4)})
            elseif dir == 2 then
                table.insert(TableAsteroids, {x=TableAsteroids[#TableAsteroids].x - TableAsteroids[#TableAsteroids].width, y=TableAsteroids[#TableAsteroids].y, width=love.math.random(10,40), height=love.math.random(10,40),health=love.math.random(5,20),mass=PerMeteorMass,type=love.math.random(1,4)})
            elseif dir == 3 then
                table.insert(TableAsteroids, {x=TableAsteroids[#TableAsteroids].x, y=TableAsteroids[#TableAsteroids].y + TableAsteroids[#TableAsteroids].height, width=love.math.random(10,40), height=love.math.random(10,40),health=love.math.random(5,20),mass=PerMeteorMass,type=love.math.random(1,4)})
            elseif dir == 4 then
                table.insert(TableAsteroids, {x=TableAsteroids[#TableAsteroids].x, y=TableAsteroids[#TableAsteroids].y - TableAsteroids[#TableAsteroids].height, width=love.math.random(10,40), height=love.math.random(10,40),health=love.math.random(5,20),mass=PerMeteorMass,type=love.math.random(1,4)})
            end
        end
    end
    
    
    



end


function ProjectileDeletion(dt)
    for i = #TableProjectiles, 1, -1 do
        TableProjectiles[i].curTime = TableProjectiles[i].curTime + dt
        if TableProjectiles[i].curTime > TableProjectiles[i].time then
            table.remove(TableProjectiles, i)
            break
        end
        
    end
    
    -- print(#TableProjectiles)
end



function AsteroidDamaged(Asteroid, projectile)
    if TableAsteroids[Asteroid].health == nil then
        return
    end
    TableAsteroids[Asteroid].health = TableAsteroids[Asteroid].health - TableProjectiles[projectile].dmg
    if TableAsteroids[Asteroid].health <= 0 then
        ParticlesAsteroidDestroyed:setPosition(TableAsteroids[Asteroid].x, TableAsteroids[Asteroid].y)
        Emit = true
        print(Inventory[TableAsteroids[Asteroid].type].amount)
        Inventory[TableAsteroids[Asteroid].type].amount = Inventory[TableAsteroids[Asteroid].type].amount + 5
        table.remove(TableAsteroids, Asteroid)
    end
    
    
end


 
function UpdateAstroidPos(Velocity,Asteroid)
    TableAsteroids[Asteroid].x = TableAsteroids[Asteroid].x  + Velocity
    TableAsteroids[Asteroid].y = TableAsteroids[Asteroid].y  + Velocity
    TableAsteroids[Asteroid].velocityX = TableAsteroids[Asteroid].velocityX  * AsteroidDrag
    TableAsteroids[Asteroid].velocityY = TableAsteroids[Asteroid].velocityY  * AsteroidDrag
end


function CloseAsteroid()
    ClosestAsteroid = {x=0,y=0}
    ClosestAsteroidDistance = 10000
    for i = 1, #TableAsteroids, 1 do
        local Distance = math.sqrt((Player.x - TableAsteroids[i].x)^2 + (Player.y - TableAsteroids[i].y)^2)
        if Distance < ClosestAsteroidDistance then
            ClosestAsteroidDistance = Distance
            ClosestAsteroid.x = TableAsteroids[i].x
            ClosestAsteroid.y = TableAsteroids[i].y
        end
    end
end