--Script Made by: Aperture-Hosting
-- Web: www.Aperture-Hosting.de
-- Contact: webmaster@aperture-hosting.de

if(file.Exists( "bin/gmsv_mysqloo_linux.dll", "LUA" ) or file.Exists( "bin/gmsv_mysqloo_win32.dll", "LUA" ))then
	MSync = MSync or {}
	local ulxsql = ulxsql or {}
	local ULXDB = ULXDB or {}

	local function mrsyncconnect()
		require("mysqloo")
		MSync.DB = mysqloo.connect(MSync.Settings.mysql.Host, MSync.Settings.mysql.Username, MSync.Settings.mysql.Password, MSync.Settings.mysql.Database, MSync.Settings.mysql.Port)
		MSync.DB.onConnected = MSync.checkTable
		MSync.DB.onConnectionFailed = MSync.DBError
		MSync.DB:connect()
		
	end
	
	/* NOT WORKING CURRENTLY! Stay tuned for Updates! 
	function MSync.Connect()
		require("mysqloo")
		MSync.DB = mysqloo.connect(MSync.Settings.mysql.Host, MSync.Settings.mysql.Username, MSync.Settings.mysql.Password, MSync.Settings.mysql.Database, MSync.Settings.mysql.Port)
		MSync.DB.onConnected = function() MSync.SQLStatus = "Connected (C1)" end
		MSync.DB.onConnectionFailed = function() MSync.SQLStatus = "Connection Failed (C2)" end
		MSync.DB:connect()
		
	end
	*/
	function MSync.DBError()
			Msg("[MSync] Connection to Failed\n")
	end
	
	function checkQuery(query)
		local playerInfo = query:getData()
		if playerInfo[1] ~= nil then
					return true
		else
					return false
		end
	end
	 
	local num_rows = 0
	
	function MSync.checkTable(server)
			print("[MSync] Connected to Database")
			print("[MSync] Checking database\n")
			if(table.HasValue(MSync.Settings.EnabledModules,"MRSync"))then
				local MRSyncCT  = server:query( "CREATE TABLE IF NOT EXISTS `mrsync` (`steamid` varchar(20) NOT NULL, `groups` varchar(30) NOT NULL, `servergroup` varchar(30) NOT NULL)" )
				MRSyncCT.onError = function(Q,Err) print("[MRSync] Failed to Create Table: " .. Err) end
				MRSyncCT:start()
			end
			if(table.HasValue(MSync.Settings.EnabledModules,"MBSync"))then
				// SteamID; Banning Admin;Reason;Ban Date;Duration
				local MBSyncCT  = server:query( "CREATE TABLE IF NOT EXISTS `mbsync` (`steamid` varchar(20) NOT NULL,`nickname` varchar(30) NOT NULL, `admin` varchar(30) NOT NULL, `reason` varchar(30) NOT NULL,`ban_date` INT NOT NULL ,`duration` INT NOT NULL, UNIQUE KEY `steamid_UNIQUE` (`steamid`))" )
				MBSyncCT.onError = function(Q,Err) print("[MBSync] Failed to Create Table: " .. Err) end
				MBSyncCT:start()
			end
			/*if(table.HasValue(MSync.Settings.EnabledModules,"MPSync"))then
				//Ranks
				//Permissions
				//Rank ID and Permission ID
				//Servers
				//Server id and Permission ID
			end*/
	end
	 
	mrsyncconnect()
	 
	include( "msync/mrsync_sql.lua" )
	include( "msync/mbsync_sql.lua" )
	include( "msync/mbsync_chat.lua" )
	include( "msync/msync_hooks.lua" )
	
else
	print('[MSync] WARNING! You need MySQLoo for this Script to Run!')
	print('[MSync] Get it from Here: http://facepunch.hatt.co/showthread.php?t=1357773')
	print('[MSync] Here is an Install Instruction:')
	print('[MSync] https://help.serenityservers.net/index.php?title=Garrysmod:How_to_install_mysqloo_or_tmysql')
end

		

		 

		 
		 

