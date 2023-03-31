function GenerateNoise(height,width)
    local noise = {}
    for y = 1, height, 1 do
        for x = 1, width, 1 do
            local nx = x/width - .5
            local ny = y/height - .5
            table.insert(noise,love.math.noise(nx,ny))
        end
    end
    return noise
end