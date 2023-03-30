InventoryIsOpen = false
Inventory = {}


function InventoryDefault()
    InventoryReset()
    InventoryAdd({name="Rock", amount=0,type=1})
    InventoryAdd({name="Ice", amount=0,type=2})
    InventoryAdd({name="Iron", amount=0,type=3})
    InventoryAdd({name="Gold", amount=0,type=4})
    
    
end


function InventoryOpen()
    love.graphics.setColor(love.math.colorFromBytes(200,200,200))
    love.graphics.rectangle("fill",75,100,love.graphics.getWidth() - 150, love.graphics.getHeight() - 250)

    love.graphics.setColor(0,0,0,1)
    love.graphics.print("Inventory", 80, 100)
    for i = 1, #Inventory, 1 do
        love.graphics.print(Inventory[i].name .. ": ".. tostring(Inventory[i].amount), 80, 100 + (i * 20))
    end
    

    love.graphics.setColor(1,1,1,1)
end

function InventoryAdd(Table)
    table.insert(Inventory, Table)
end

function InventoryRemove(Index)
    table.remove(Inventory, Index)
end

function InventoryReset()
    Inventory = {}
end