

function love.load()


    Player = {x=200,y=200,speed=.5,velocityX=0,velocityY=0,drag=.95, rotX=0, rotSpeed=3,maxSpeed=5}
    SpritePlayer = love.graphics.newImage("Sprites/space.png")
    TableProjectiles = {}
    Asteroid = {x=0,y=0,speed=.5,velocityX=0,velocityY=0,mass=10,radius=8}

    TableAsteroids = {}
    SpawnAsteroids()

end




function love.draw()
    -- love.graphics.setColor(0,0,0,255)
    --player collison box debug
    love.graphics.rectangle("line",Player.x - 18.5, Player.y - 18.5, 30,28)
    -- love.graphics.setColor(255,255,255,255)
    --player sprite
    love.graphics.draw(SpritePlayer, Player.x, Player.y, math.rad(Player.rotX + 90), .5, .5, 32, 32, 0, 0)

    
    if #TableProjectiles > 0 then
        for i = 1, #TableProjectiles, 1 do
            --debug collison box for projectile ↓
            love.graphics.rectangle("line", TableProjectiles[i].x - 15, TableProjectiles[i].y - 5, 10, 10)

            love.graphics.circle("line",TableProjectiles[i].x,
                                        TableProjectiles[i].y, 5)
        end
    end

    for i = 1, #TableAsteroids, 1 do
        love.graphics.rectangle("fill",TableAsteroids[i].x,TableAsteroids[i].y,
                                       TableAsteroids[i].width,TableAsteroids[i].height)
        
    end

        
end

function love.update(dt)
    UserInput()
    UpdateProjectiles(dt)
    Collisons()





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
        table.insert(TableProjectiles, {x=Player.x +(math.cos(math.rad(Player.rotX))),y=Player.y +(math.sin(math.rad(Player.rotX))),speed=.5,velocityX=5, velocityY=5, angle=Player.rotX})    
    else
        Shot = false
    end
    
    Player.x = Player.x + Player.velocityX
    Player.y = Player.y + Player.velocityY
    Player.velocityX = Player.velocityX * Player.drag
    Player.velocityY = Player.velocityY * Player.drag
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







function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
            x2 < x1+w1 and
            y1 < y2+h2 and
            y2 < y1+h1
end


function Collisons()
    for ast = 1, #TableAsteroids, 1 do
        for proj = 1, #TableProjectiles, 1 do
            local hit = CheckCollision(TableAsteroids[ast].x,TableAsteroids[ast].y,TableAsteroids[ast].width,TableAsteroids[ast].height,TableProjectiles[proj].x,TableProjectiles[proj].y,10,10)
            local playerHit = CheckCollision(TableAsteroids[ast].x,TableAsteroids[ast].y,15,10, Player.x - 18.5, Player.y - 18.5, 30,28) 
            if hit then
                print("HIT", TableAsteroids[ast].x, " ", TableAsteroids[ast].y)
            end
            if playerHit then
                print("PLAYER HIT", Player.x, " ", Player.y)
                
            end
            
        end
    end
    
    
end




function SpawnAsteroids()
    for i = 1, 10, 1 do
        table.insert(TableAsteroids, {x=love.math.random(1,love.graphics.getWidth()),
                                      y=love.math.random(1,love.graphics.getHeight()),
                                      velocityX=0, velocityY=0, mass=10,width=15,height=10})
    end
end