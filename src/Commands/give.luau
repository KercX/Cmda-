return {
    Name = "give";
    Aliases = {"g"};
    Description = "Gives an item to player(s)";
    Group = "Admin";
    Args = {
        { Type = "players", Name = "targets", Description = "Who to give to" },
        { Type = "string",  Name = "item",    Description = "Item name" },
        { Type = "number",  Name = "amount",  Description = "Amount (default 1)", Optional = true }
    }
}
