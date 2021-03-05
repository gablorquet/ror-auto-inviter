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
        rorAutoInviter.Settings.inviteAlliance = true;
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
	local character = towstring(character, L"");
	
    for k,v in pairs(table) do
        local name = v.name;
		
		if(WStringsCompare(character, name)) then
            present = true;
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
    local inviteAlliance = rorAutoInviter.Settings.inviteAlliance;
    local inviteAll = rorAutoInviter.Settings.inviteAll;
    local inviteKnown = rorAutoInviter.Settings.inviteKnown;
    local inviteString = rorAutoInviter.Settings.inviteString;

    local willInvite = false;
    local textMatch = msg == tostring(inviteString);

    local isGroupLeader = GameData.Player.isGroupLeader;
    local isInAlliance = GameData.Guild.Alliance.Id ~= 0;
    local nbGroupMates = GetNumGroupmates();
    local isInWarband = IsWarBandActive();
    local isInGroup = nbGroupMates > 0;

    if not textMatch then
        return;
    end

    if (not isGroupLeader and isInGroup) then
        local leader = PartyUtils.GetWarbandLeader();

        SendChatText (towstring("/w " .. author) .." Sorry, I am not the leader of the group, please refer to " ..leader.name, L"");
        return;
    end

    if PartyUtils.IsWarbandFull() then
        SendChatText (towstring("/w " .. author) .." Sorry, group is full", L"");
        return;
    end

    local canInviteGuild = inviteGuild or inviteAll or inviteKnown;
    if(IsPlayerInAGuild and canInviteGuild) then
        local guildMemberData = GetGuildMemberData();

        willInvite = rorAutoInviter.IsInTable(guildMemberData, author);
    end

    local canInviteAlliance = isInAlliance and inviteAlliance;
    if (not willInvite and canInviteAlliance) then
        local allianceData = GetAllianceMemberData();

        willInvite = rorAutoInviter.IsInTable(allianceData, author);
    end

    local canInviteFriends = inviteKnown or inviteAll;
    if (not willInvite and canInviteFriends) then
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
        rorAutoInviter.Settings.inviteAlliance = false;
        rorAutoInviter.Settings.inviteKnown = false;
        rorAutoInviter.Settings.inviteAll = false;
    elseif parameter == "alliance" then
        rorAutoInviter.Settings.inviteGuild = true;
        rorAutoInviter.Settings.inviteAlliance = true;
        rorAutoInviter.Settings.inviteKnown = false;
        rorAutoInviter.Settings.inviteAll = false;
    elseif parameter == "known" then
        rorAutoInviter.Settings.inviteGuild = true;
        rorAutoInviter.Settings.inviteAlliance = true;
        rorAutoInviter.Settings.inviteKnown = true;
        rorAutoInviter.Settings.inviteAll = false;
    elseif parameter == "all" then
        rorAutoInviter.Settings.inviteGuild = true;
        rorAutoInviter.Settings.inviteAlliance = true;
        rorAutoInviter.Settings.inviteKnown = true;
        rorAutoInviter.Settings.inviteAll = true;
    elseif parameter == 'off' then
        rorAutoInviter.Settings.inviteGuild = false;
        rorAutoInviter.Settings.inviteAlliance = false;
        rorAutoInviter.Settings.inviteKnown = false;
        rorAutoInviter.Settings.inviteAll = false;
    else
        Print('Unknown argument:' ..parameter .."(Supported: guild, known, all, off)");
    end
    
    Print('[AI] Guild: ' .. tostring(rorAutoInviter.Settings.inviteGuild));
    Print('[AI] Alliance: ' .. tostring(rorAutoInviter.Settings.inviteAlliance));
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
        Print('/ai accept [guild | alliance | known | all | off]');
        Print('Guild: ' .. tostring(rorAutoInviter.Settings.inviteGuild));
        Print('Alliance: ' .. tostring(rorAutoInviter.Settings.inviteAlliance));
        Print('Known: ' .. tostring(rorAutoInviter.Settings.inviteKnown));
        Print('All: ' .. tostring(rorAutoInviter.Settings.inviteAll));
        Print('/ai key [value] : Change the key for AA to invite a character.');
        Print('CURRENT :' ..rorAutoInviter.Settings.inviteString);
        Print('/ai broadcast : Broadcast a message into the guild chat to advertise your warband');
    end
end
