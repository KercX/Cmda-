return function(context, targets: {Player}, item: string, amount: number?)
    amount = amount or 1
    for _, plr in targets do
        print(`[Cmda] Gave {amount}x {item} to {plr.Name}`)
        -- Add your actual item giving logic here
    end
    return `Gave {amount}x {item} to {#targets} player(s)`
end
