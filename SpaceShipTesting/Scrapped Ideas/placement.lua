function Gridify(ScreenHeight, ScreenWidth)
    TableGrid = {}
    for i=1, love.graphics.getWidth()/16, 1 do
        for j=1, love.graphics.getHeight()/16, 1 do
            table.insert(TableGrid, {x=(i*16), y=(j*16), width=16, height=16, occupied=false})
        end
    end
    return TableGrid
end

