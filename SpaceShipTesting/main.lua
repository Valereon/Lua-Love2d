


function love.load()
    Player = {x=200,y=200,speed=.5,velocityX=0,velocityY=0,drag=.95, rotX=0, rotSpeed=3,maxSpeed=5,}
    SpritePlayer = love.graphics.newImage("Sprites/space.png")
    TableProjectiles = {}
    -- Asteroid = {x=0,y=0,speed=.5,velocityX=0,velocityY=0,mass=10}
end




function love.draw()
    love.graphics.draw(SpritePlayer, Player.x, Player.y, math.rad(Player.rotX + 90), .5, .5, 32, 32, 0, 0)
    if #TableProjectiles > 0 then
        for i = 1, #TableProjectiles, 1 do
            love.graphics.circle("line",TableProjectiles[i].x,
                                        TableProjectiles[i].y, 5)
        end
    end
    -- Player.x + (100 * math.sin(math.rad(Player.rotX)))
    -- + Player.x + (100 * math.cos(math.rad(Player.rotX)))
        
        
end

function love.update(dt)
    UserInput()
    UpdateProjectiles(dt)
    if Player.rotX > 360 then
        Player.rotX = Player.rotX - 360
    end
    if Player.rotX < -360 then
        Player.rotX = Player.rotX + 360
    end
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
        local theta = math.rad(Player.rotX) * math.pi / 180
        local x = math.cos(theta)
        local y = math.sin(theta)
        table.insert(TableProjectiles, {x=Player.x +(math.cos(math.rad(Player.rotX)) + .5),y=Player.y +(math.sin(math.rad(Player.rotX)) + .5),speed=.5,velocityX=5, velocityY=5, angle=Player.rotX})    
    else
        Shot = false
    end
    
    Player.x = Player.x + Player.velocityX
    Player.y = Player.y + Player.velocityY
    Player.velocityX = Player.velocityX * Player.drag
    Player.velocityY = Player.velocityY * Player.drag
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
end


function UpdateProjectiles(dt)
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