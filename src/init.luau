--!strict
-- Cmda - Modern Command Framework for Roblox
-- Version 0.1.0

local RunService = game:GetService("RunService")

local Cmda = {
    Version = "0.1.0",
    RegisteredCommands = {},
    RegisteredTypes = {},
    Hooks = {},
}

-- Register all commands from a folder
function Cmda:RegisterCommandsIn(container: Instance)
    for _, child in container:GetDescendants() do
        if child:IsA("ModuleScript") and not child.Name:match("Server$") then
            local commandDef = require(child)

            -- Look for matching Server module
            local serverModule = container:FindFirstChild(child.Name .. "Server")
            if serverModule then
                commandDef.Run = require(serverModule)
            end

            self.RegisteredCommands[commandDef.Name:lower()] = commandDef
            print(`[Cmda] Registered command: {commandDef.Name}`)
        end
    end
end

-- Register custom argument types
function Cmda:RegisterTypesIn(container: Instance)
    for _, child in container:GetChildren() do
        if child:IsA("ModuleScript") then
            self.RegisteredTypes[child.Name:lower()] = require(child)
            print(`[Cmda] Registered type: {child.Name}`)
        end
    end
end

-- Register hooks (BeforeRun, AfterRun, etc.)
function Cmda:RegisterHooksIn(container: Instance)
    for _, child in container:GetChildren() do
        if child:IsA("ModuleScript") then
            self.Hooks[child.Name] = require(child)
        end
    end
end

function Cmda:RegisterDefaultCommands()
    print("[Cmda] Default commands will be added in future versions")
end

-- Execute a command (called from UI or chat)
function Cmda:ExecuteCommand(player: Player, input: string): string
    local commandName, argsStr = input:match("^(%S+)%s*(.*)$")
    if not commandName then
        return "Invalid command format"
    end

    local cmd = self.RegisteredCommands[commandName:lower()]
    if not cmd then
        return `Command "{commandName}" not found`
    end

    -- Run BeforeRun hook if it exists
    if self.Hooks.BeforeRun then
        local success, err = self.Hooks.BeforeRun(player, cmd)
        if not success then
            return err or "You don't have permission to run this command"
        end
    end

    local parsedArgs = self:ParseArguments(cmd.Args or {}, argsStr)
    local result = cmd.Run(player, unpack(parsedArgs))

    return result or "Command executed successfully"
end

-- Simple argument parser (will be improved later)
function Cmda:ParseArguments(argDefs: {any}, input: string): {any}
    local args = {}
    for _, def in argDefs do
        local argType = self.RegisteredTypes[def.Type:lower()]
        if argType and argType.Parse then
            table.insert(args, argType.Parse(input))
        else
            table.insert(args, input)
        end
    end
    return args
end

-- Start Cmda
function Cmda:Start()
    if RunService:IsClient() then
        require(script.Client.UI)
    elseif RunService:IsServer() then
        require(script.Server.CommandService)
    end
end

return Cmda
