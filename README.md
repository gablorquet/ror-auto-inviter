# ror-auto-inviter

RoR Auto Inviter is an addon for Warhammer Online : Return of Reckoning. It allows a group leader to quickly invite players without having to monitor chat for people looking for group.

Upon loading the addon will automatically invite people within your guild or friend list that whisper you with "+" (without the double quotes)

## Commands

```/ai accept [guild | known | all | off] (Default to : known)``` 

Setting guild will only invite characters from the player's guild. Likewise, known will also invite characters from the player's friend list. All will ignore any restrictions while off will not invite anyone

```/ai key [value] (Default to : +)```

Setting the key will overwrite the message that a character must send the play to get invited.

```/ai broadcast```

Will post in guild chat a message about the group being up and how to get in

## Macros
To use the broadcast message in a macro, use 
```/script rorAutoInviter.HandleBroadcastCommand()```
