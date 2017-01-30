-- Script Made by: Aperture-Hosting, edited by Princess Celestia
-- Web: www.Aperture-Hosting.de
-- Contact: webmaster@aperture-hosting.de

-- TODO move this into some shared config file or somewhere
local tableName = "mrsync"

if(file.Exists( "bin/gmsv_mysqloo_linux.dll", "LUA" ) or file.Exists( "bin/gmsv_mysqloo_win32.dll", "LUA" ))then
	MSync = MSync or {}
	local ulxsql = ulxsql or {}
	local ULXDB = ULXDB or {}

	local function mrsyncconnect()
		require("mysqloo")
		MSync.DB = mysqloo.connect(MSync.Settings.mysql.Host, MSync.Settings.mysql.Username, MSync.Settings.mysql.Password, MSync.Settings.mysql.Database, MSync.Settings.mysql.Port)
		MSync.DB.onConnected = MSync.checkTables
		MSync.DB.onConnectionFailed = MSync.DBError
		MSync.DB:connect()
		
	end
	
	/* NOT WORKING CURRENTLY! Stay tuned for Updates! 
	function MSync.Connect()
		require("mysqloo")
		MSync.DB = mysqloo.connect(MSync.Settings.mysql.Host, MSync.Settings.mysql.Username, MSync.Settings.mysql.Password, MSync.Settings.mysql.Database, MSync.Settings.mysql.Port)
		MSync.DB.onConnected = function() MSync.SQLStatus = "Connected (C1)" end
		MSync.DB.onConnectionFailed = function() MSync.SQLStatus = "Connection failed (C2)" end
		MSync.DB:connect()
		
	end
	*/
	function MSync.DBError()
		Msg("[MSync] Connection to database failed\n")
	end
	
	function checkQuery(query)
		local playerInfo = query:getData()
		return playerInfo[1] ~= nil
	end
	 
	local num_rows = 0
	
	function MSync.checkTables(server)
		print("[MSync] Connected to database")
		print("[MSync] Checking database\n")
		if(table.HasValue(MSync.Settings.EnabledModules, "MRSync")) then
			include( "msync/mrsync_sql.lua" )
			MSync.CreateRanksTable()
		end
		if(table.HasValue(MSync.Settings.EnabledModules, "MBSync")) then
			include( "msync/mbsync_sql.lua" )
			MSync.CreateBansTable()
		end
		/*if(table.HasValue(MSync.Settings.EnabledModules, "MPSync")) then
			//Ranks
			//Permissions
			//Rank ID and Permission ID
			//Servers
			//Server id and Permission ID
		end*/
	end
	 
	mrsyncconnect()
		
	include( "msync/mbsync_chat.lua" )
	include( "msync/msync_hooks.lua" )
	
else
	print('[MSync] WARNING! You need MySQLoo v9 or higher for this addon to work!')
	print('[MSync] Get it from here: https://facepunch.com/showthread.php?t=1515853')
	print('[MSync] Here are installation instructions:')
	print('[MSync] https://help.serenityservers.net/index.php?title=Garrysmod:How_to_install_mysqloo_or_tmysql')
end

		

		 

		 
		 

