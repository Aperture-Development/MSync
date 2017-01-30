-- Script Made by: Aperture-Hosting, edited by Princess Celestia
-- Web: www.Aperture-Hosting.de
-- Contact: webmaster@aperture-hosting.de

if(file.Exists( "bin/gmsv_mysqloo_linux.dll", "LUA" ) or file.Exists( "bin/gmsv_mysqloo_win32.dll", "LUA" ))then
	MSync = MSync or {}
	-- TODO move this into some shared config file or somewhere
	MSync.TableNameBans = "mbsync_testing"
	MSync.TableNameRanks = "mrsync_testing"
	local ulxsql = ulxsql or {}
	local ULXDB = ULXDB or {}
	
	function MSync.Connect()
		require("mysqloo")
		MSync.DB = mysqloo.connect(MSync.Settings.mysql.Host, MSync.Settings.mysql.Username, MSync.Settings.mysql.Password, MSync.Settings.mysql.Database, MSync.Settings.mysql.Port)
		MSync.DB.onConnected = MSync.checkTables
		MSync.DB.onConnectionFailed = MSync.DBError
		MSync.DB:connect()
		
	end

	function MSync.DBError()
		Msg("[MSync] Connection to database failed\n")
	end
	
	-- TODO find usages and replace them with query:hasMoreResults()
	function checkQuery(query)
		local playerInfo = query:getData()
		return playerInfo[1] ~= nil
	end
	 
	local num_rows = 0
	
	function MSync.checkTables(server)
		print("[MSync] Connected to database")
		print("[MSync] Checking database")
		if(table.HasValue(MSync.Settings.EnabledModules, "MRSync")) then
			local MRSyncCT  = server:prepare([[
				CREATE TABLE IF NOT EXISTS `]] .. MSync.TableNameRanks .. [[` (
					`steamid` varchar(20) NOT NULL,
					`groups` varchar(30) NOT NULL,
					`servergroup` varchar(30) NOT NULL
				)
			]])
			MRSyncCT.onError = function(Q, Err) print("[MRSync] Failed to create table: " .. Err) end
			MRSyncCT:start()
		end
		if(table.HasValue(MSync.Settings.EnabledModules, "MBSync")) then
			local MBSyncCT  = server:prepare([[
				CREATE TABLE IF NOT EXISTS `]] .. MSync.TableNameBans .. [[` (
					`steamid` varchar(20) NOT NULL,
					`nickname` varchar(30) NOT NULL,
					`admin` varchar(30) NOT NULL,
					`reason` varchar(30) NOT NULL,
					`ban_date` INT NOT NULL,
					`duration` INT NOT NULL,
					UNIQUE KEY `steamid_UNIQUE` (`steamid`)
				)
			]])
			MBSyncCT.onError = function(Q, Err) print("[MBSync] Failed to create table: " .. Err) end
			MBSyncCT:start()
		end
		/*if(table.HasValue(MSync.Settings.EnabledModules, "MPSync")) then
			//Ranks
			//Permissions
			//Rank ID and Permission ID
			//Servers
			//Server id and Permission ID
		end*/
	end
	
	MSync.Connect()
	
	include( "msync/mrsync_sql.lua" )
	include( "msync/mbsync_sql.lua" )
	include( "msync/mbsync_chat.lua" )
	include( "msync/msync_hooks.lua" )
	
else
	print('[MSync] WARNING! You need MySQLoo v9 or higher for this addon to work!')
	print('[MSync] Get it from here: https://facepunch.com/showthread.php?t=1515853')
	print('[MSync] Here are installation instructions:')
	print('[MSync] https://help.serenityservers.net/index.php?title=Garrysmod:How_to_install_mysqloo_or_tmysql')
end

		

		 

		 
		 

