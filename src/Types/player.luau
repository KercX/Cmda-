--!strict
return {
    Parse = function(input: string): Player?
        local player = game.Players:FindFirstChild(input)
        if player then return player end

        for _, p in game.Players:GetPlayers() do
            if p.Name:lower():find(input:lower()) then
                return p
            end
        end
        return nil
    end
}
