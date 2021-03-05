# ror-auto-inviter

RoR Auto Inviter is an addon for Warhammer Online : Return of Reckoning. It allows a group leader to quickly invite players without having to monitor chat for people looking for group.

Upon loading the addon will automatically invite people within your guild, alliance or friend list that whisper you with "+" (without the double quotes)

## Commands

```/ai accept [guild | alliance | known | all | off] (Default to : known)``` 

Setting *guild* will only invite characters from the player's guild. <br/>
Setting *alliance* will also invite players from your alliance.<br/>
Setting *known* will invite players from friend list, alliance or guild <br/>
Setting *all* will remove all checks and invite any player that whispers the invite key <br/>
Setting *off* will disable the autoinviter

```/ai key [value] (Default to : +)```

Setting the key will overwrite the message that a character must send the play to get invited.

```/ai channel [value] (Default to : g)```

Setting the channel will overwrite the destination of the broadcast message

```/ai message [value] (Default to : WAR is going on! Send me a tell with %key% to get invited! )```

Setting the message will overwrite the broadcast message. You can use %key% to refer to the invite key <br/>
Ex : 
```
/ai key INVITE
/ai message Send me %key% to get invited!
/ai channel a
/ai broadcast 
```
would send "Send me INVITE to get invited!" to the alliance (a) channel

```/ai broadcast```

Will post in the selected chat your broadcast message

## Macros
To use the broadcast message in a macro, use 
```/script rorAutoInviter.HandleBroadcastCommand()```
