if not rorAutoInviter then rorAutoInviter = {} end

local IsPlayerInAGuild = true;

local function Print(str)
    EA_ChatWindow.Print(towstring(str));
end

function rorAutoInviter.OnInitialize()
    IsPlayerInAGuild = GuildWindow.IsPlayerInAGuild();

    RegisterEventHandler( SystemData.Events.CONVERSATION_TEXT_ARRIVED, "rorAutoInviter.OnMessageReceived");

    if not rorAutoInviter.Settings then
        rorAutoInviter.Settings = {};
        rorAutoInviter.Settings.inviteGuild = true;
        rorAutoInviter.Settings.inviteKnown = true;
        rorAutoInviter.Settings.inviteAll = false;
        rorAutoInviter.Settings.inviteString = "+";
        
    end

    LibSlash.RegisterSlashCmd("ai", function(args) rorAutoInviter.SlashCmd(args) end);

end

function rorAutoInviter.OnShutdown()
    UnregisterEventHandler(SystemData.Events.CONVERSATION_TEXT_ARRIVED, "rorAutoInviter.OnMessageReceived");
end

function rorAutoInviter.IsInTable(table, character)
    local present = false;
    for k,v in pairs(table) do
        local name = v.name;

        if(name ~= character) then
            present = true;
            break;
        end

        if present == true then
            break;
        end
    end

    return present;
end

function rorAutoInviter.OnMessageReceived()
    
    local msg = tostring(GameData.ChatData.text);
	local author = tostring(GameData.ChatData.name);
    local player = tostring(GameData.Player.name);

    local inviteGuild = rorAutoInviter.Settings.inviteGuild;
    local inviteAll = rorAutoInviter.Settings.inviteAll;
    local inviteKnown = rorAutoInviter.Settings.inviteKnown;
    local inviteString = rorAutoInviter.Settings.inviteString;

    local willInvite = false;
    local textMatch = msg == tostring(inviteString);

    local isGroupLeader = GameData.Player.isGroupLeader;

    if not isGroupLeader then
        SendChatText (towstring("/w " .. author) .." Sorry, I am not the leader of my group", L"");
        return;
    end

    if(IsPlayerInAGuild and textMatch and (inviteGuild or inviteAll or inviteKnown)) then
        guildMemberData = GetGuildMemberData();

        willInvite = rorAutoInviter.IsInTable(guildMemberData, author);
    end

    if (textMatch and not willInvite and (inviteKnown or inviteAll)) then
        local friendData = GetFriendsList();

        willInvite = rorAutoInviter.IsInTable(friendData, author);
    end

    if willInvite then
        SendChatText (towstring("/invite " .. author), L"");
    else
        SendChatText (towstring("/w " .. author) .."Sorry you are not eligible for this group.", L"");
    end
end

function rorAutoInviter.HandleBroadcastCommand()
    SendChatText(towstring("/g WAR is going on! Send me a tell with " ..rorAutoInviter.Settings.inviteString .." to get invited!"), L"")
end

function rorAutoInviter.HandleAcceptCommand(parameter)
    if(parameter == "guild") then
        rorAutoInviter.Settings.inviteGuild = true;
        rorAutoInviter.Settings.inviteKnown = false;
        rorAutoInviter.Settings.inviteAll = false;
    elseif parameter == "known" then
        rorAutoInviter.Settings.inviteGuild = true;
        rorAutoInviter.Settings.inviteKnown = true;
        rorAutoInviter.Settings.inviteAll = false;
    elseif parameter == "all" then
        rorAutoInviter.Settings.inviteGuild = true;
        rorAutoInviter.Settings.inviteKnown = true;
        rorAutoInviter.Settings.inviteAll = true;
    elseif parameter == 'off' then
        rorAutoInviter.Settings.inviteGuild = false;
        rorAutoInviter.Settings.inviteKnown = false;
        rorAutoInviter.Settings.inviteAll = false;
    else
        Print('Unknown argument:' ..parameter .."(Supported: guild, known, all, off)");
    end
    
    Print('[AI] Guild: ' .. tostring(rorAutoInviter.Settings.inviteGuild));
    Print('[AI] Known: ' .. tostring(rorAutoInviter.Settings.inviteKnown));
    Print('[AI] All: ' .. tostring(rorAutoInviter.Settings.inviteAll));

end

function rorAutoInviter.HandleSetInviteKey(parameter)
    rorAutoInviter.Settings.inviteString = parameter;
    Print("[AI] Invite key set to :" ..parameter);
end

function rorAutoInviter.SlashCmd(args)
    local command;
	local parameter;
	local separator = string.find(args," ");
	
	if separator then
		command = string.sub(args, 0, separator - 1);
		parameter = string.sub(args, separator + 1, -1);
	else
		command = args;
	end
	
    if(command == "broadcast") then
        rorAutoInviter.HandleBroadcastCommand();
    elseif (command == "accept") then
        rorAutoInviter.HandleAcceptCommand(parameter);
    elseif (command == "key") then
        rorAutoInviter.HandleSetInviteKey(parameter);
    else
        Print('---- RoR Auto Inviter ----');
        Print('Commands :');
        Print('/ai accept [guild | known | all | off]');
        Print('Guild: ' .. tostring(rorAutoInviter.Settings.inviteGuild));
        Print('Known: ' .. tostring(rorAutoInviter.Settings.inviteKnown));
        Print('All: ' .. tostring(rorAutoInviter.Settings.inviteAll));
        Print('/ai key [value] : Change the key for AA to invite a character.');
        Print('CURRENT :' ..rorAutoInviter.Settings.inviteString);
        Print('/ai broadcast : Broadcast a message into the guild chat to advertise your warband');
    end
end
