

function love.load()
    Camera = require("Libraries/camera")
    Cam = Camera()
    

    Player = {x=200,y=200,speed=.25,velocityX=0,velocityY=0,drag=.95, rotX=0, rotSpeed=3,}
    SpritePlayer = love.graphics.newImage("Sprites/space.png")
    TableProjectiles = {}
    Asteroid = {x=0,y=0,speed=.5,velocityX=0,velocityY=0,mass=10,radius=8}

    TableAsteroids = {}
    SpawnAsteroids()

end




function love.draw()
    Cam:attach()
        -- love.graphics.setColor(0,0,0,255)
        --player collison box debug
        love.graphics.rectangle("line",Player.x - 8, Player.y - 8, 16,16)
        -- love.graphics.setColor(255,255,255,255)
        --player sprite
        love.graphics.draw(SpritePlayer, Player.x, Player.y, math.rad(Player.rotX + 90), .25, .25, 32, 32, 0, 0)

        
        if #TableProjectiles > 0 then
            for i = 1, #TableProjectiles, 1 do
                --debug collison box for projectile ↓
                -- love.graphics.rectangle("line", TableProjectiles[i].x - 15, TableProjectiles[i].y - 5, 10, 10)

                love.graphics.circle("line",TableProjectiles[i].x,
                                            TableProjectiles[i].y, 2.5)
            end
        end
 
        for i = 1, #TableAsteroids, 1 do
            love.graphics.rectangle("fill",TableAsteroids[i].x,TableAsteroids[i].y,
                                        TableAsteroids[i].width,TableAsteroids[i].height)
            
        end
    Cam:detach()

            
end

function love.update(dt)
    UserInput()
    UpdateProjectiles(dt)
    Collisons()
    ProjectileDeletion(dt)
    print("FPS: ", love.timer.getFPS())
    Cam:lookAt(Player.x,Player.y)
    -- if #TableProjectiles > 0 then
        -- print(TableProjectiles[#TableProjectiles].x,TableProjectiles[#TableProjectiles].y)
    -- end
    
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
        local playerHit = CheckCollision(TableAsteroids[ast].x,TableAsteroids[ast].y,15,10, Player.x - 8, Player.y - 8, 16,16)
        if playerHit then
            print("PLAYER HIT", Player.x, " ", Player.y)
            
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
    -- for i = 1, 10, 1 do
    --     table.insert(TableAsteroids, {x=love.math.random(1,love.graphics.getWidth()),
    --                                   y=love.math.random(1,love.graphics.getHeight()),
    --                                   velocityX=0, velocityY=0, mass=10,width=15,height=10})
    -- end
    -- format is x=?,y=?,width=?,height=?




    --Beggning Asteroid
    table.insert(TableAsteroids, {x=100,y=100,width=10,height=10,health=love.math.random(5,20)})
    --Connecting Asteroids
    for i = 1, 50, 1 do
        table.insert(TableAsteroids, {x=love.math.random(1,2000), y=love.math.random(1,2000),width=10,height=10})
        for j = 1, 250, 1 do
            local dir = love.math.random(1,4)
            if dir == 1 then
                table.insert(TableAsteroids, {x=TableAsteroids[#TableAsteroids].x + TableAsteroids[#TableAsteroids].width, y=TableAsteroids[#TableAsteroids].y, width=love.math.random(10,40), height=love.math.random(10,40),health=love.math.random(5,20)})
            elseif dir == 2 then
                table.insert(TableAsteroids, {x=TableAsteroids[#TableAsteroids].x - TableAsteroids[#TableAsteroids].width, y=TableAsteroids[#TableAsteroids].y, width=love.math.random(10,40), height=love.math.random(10,40),health=love.math.random(5,20)})
            elseif dir == 3 then
                table.insert(TableAsteroids, {x=TableAsteroids[#TableAsteroids].x, y=TableAsteroids[#TableAsteroids].y + TableAsteroids[#TableAsteroids].height, width=love.math.random(10,40), height=love.math.random(10,40),health=love.math.random(5,20)})
            elseif dir == 4 then 
                table.insert(TableAsteroids, {x=TableAsteroids[#TableAsteroids].x, y=TableAsteroids[#TableAsteroids].y - TableAsteroids[#TableAsteroids].height, width=love.math.random(10,40), height=love.math.random(10,40),health=love.math.random(5,20)})
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
        table.remove(TableAsteroids, Asteroid)
    end
    
    
end


