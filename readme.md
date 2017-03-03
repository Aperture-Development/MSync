# MSync (**M**ySQL **Sync**hronisation)

This is a free all around solution for multi-server communities.
This addon syncs ranks and bans (more features to be added).

Join my website: https://Aperture-Hosting.de - A forum for developers and support all around GMod

## Features

### MSync (MySQL Synchronisation):

MSync is the all around solution for server synchronisation.

- In-game configuration via XGUI
- Saveable settings
- To get the current version, type `msync_version` into the server console
- Even with `sv_allowcslua` enabled players cannot get the settings table without permission. Those who try to 'force get it' get kicked

#### MRSync (MySQL Rank Synchronisation):

MRSync will keep your staff ranks synchronised across your servers.
- Saving ranks on `PlayerDisconnected` and `ShutDown` hooks
- Ability to set ranks that get synced through all servers
- Ability to set ranks as 'ignored' to make them not synchronised

#### MBSync (MySQL Ban Synchronisation):

MBSync is a free solution for synchronising bans. If you ban someone, they are banned on all your servers.
- `ulx checkban <steamid>` command
- Overwrites `ulx ban`, `ulx banid` and `ulx unban`
- adjustable ban message which provides all the information about the ban and ban appeal

## Requirements

1. MySQLoo (https://facepunch.com/showthread.php?t=1515853)
2. ULX and ULib (http://ulyssesmod.net/downloads.php)
3. MySQL database

## Basic setup

First you need to install MySQLoo which can be found here: https://facepunch.com/showthread.php?t=1515853
An excellent instruction of how to install it can be found here: https://help.serenityservers.net/index.php?title=Garrysmod:How_to_install_mysqloo_or_tmysql

After that you need to setup a database for your ranks and/or bans.
1. Create a user for MRSync with a complex password
2. Add a database scheme for the user
3. Set your database parameters settings in-game
4. Restart your server
5. If it says `[MSync] Connected to database`, you are done.

## Planned features

- Web panel
- MWS (MySQL Warning System)
- Rank backups
- MPSync (MySQL Permission Synchronisation)
- MUSync (MySQL Utime Synchronisation)

## Support/Bugs

Please use my support ticked system at: https://www.aperture-hosting.de/ticketsystem/
Or mail me under: Webmaster@Rainbow-Dash.com

## Other

Join my Website to talk to other programmers and for help with your stuff:
https://Aperture-Hosting.de/ (work in progress)

Follow me on GitHub: https://github.com/captain1242

Communities I am playing on:

Instant-Roleplay - https://Instant-Roleplay.com/
Cloudsdale Gaming - http://CloudsdaleGaming.com/
X-Coder Buildserver
