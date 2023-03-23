

function love.load()
    Player = {x=200,y=200,speed=.5,velocityX=0,velocityY=0,drag=.95, rotX=0, rotSpeed=3,maxSpeed=5,}
    Projectile = {x=0,y=0,speed=.5,velocityX=0,velocityY=0}
    SpritePlayer = love.graphics.newImage("Sprites/space.png")

    
    Asteroid = {x=0,y=0,speed=.5,velocityX=0,velocityY=0,mass=10}
    Asteroid1 = {x=0,y=0,speed=.5,velocityX=0,velocityY=0,mass=10}
    Asteroid2 = {x=0,y=0,speed=.5,velocityX=0,velocityY=0,mass=10}
    Asteroid3 = {x=0,y=0,speed=.5,velocityX=0,velocityY=0,mass=10}
    Asteroid4 = {x=0,y=0,speed=.5,velocityX=0,velocityY=0,mass=10}
    Asteroid5 = {x=0,y=0,speed=.5,velocityX=0,velocityY=0,mass=10}

    -- World = love.physics.newWorld(0,200, true)
end




function love.draw()
    love.graphics.draw(SpritePlayer, Player.x, Player.y, math.rad(Player.rotX), .5, .5, 32, 32, 0, 0)
    if Shot then
        love.graphics.circle("fill", Projectile.x, Projectile.y, 5)
    end
end

function love.update(dt)
    Shot = UserInput()
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
        Shooting = true
    end
    
    Player.x = Player.x + Player.velocityX
    Player.y = Player.y + Player.velocityY
    Player.velocityX = Player.velocityX * Player.drag
    Player.velocityY = Player.velocityY * Player.drag
    Shooting = false
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
end