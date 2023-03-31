function DefineOverviewMap(Asteroids,SpaceStations,Planets)
    Map = {}
    ObjectsOnMap = {}
    Map.Asteroids = Asteroids
    Map.SpaceStations = SpaceStations
    Map.Planets = Planets
    for i = 1, #Asteroids, 250 do
        table.insert(Map, {x = Asteroids[i].x / 10, y = Asteroids[i].y / 10, type="Asteroid", width = 10, height = 10})
    end

end

function ShowMap(PlayerX, PlayerY)
    love.graphics.setColor(love.math.colorFromBytes(0,0,0))

    love.graphics.rectangle("fill",0,0,love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(1,0,0,1)
    for i = 1, #Map, 1 do
        love.graphics.rectangle("fill",Map[i].x,Map[i].y,Map[i].width, Map[i].height)
    end
    
    love.graphics.setColor(0,0,1,1)
    love.graphics.rectangle("fill",PlayerX / 10,PlayerY / 10,10,10)


    love.graphics.setColor(1,1,1,1)
end


function Minimap(PlayerX, PlayerY)
    love.graphics.setColor(love.math.colorFromBytes(0,0,0))

    love.graphics.rectangle("fill",1,0,100, 100)

    love.graphics.setColor(1,0,0,1)
    for i = 1, #Map, 1 do
        love.graphics.rectangle("fill", Map[i].x/5, Map[i].y/5, Map[i].width/5, Map[i].height/5)
    end

    
    love.graphics.setColor(0,0,1,1)
    love.graphics.rectangle("fill",PlayerX / 10,PlayerY / 10,10,10)


    love.graphics.setColor(1,1,1,1)
    
end