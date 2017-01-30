if(table.HasValue(MSync.Settings.EnabledModules,"MRSync"))then
	hook.Add("PlayerInitialSpawn", "MRSyncSyncUser", MSync.LoadRank)
	hook.Add("PlayerDisconnected", "MRSyncSaveUser", MSync.SaveRank)
	hook.Add("ShutDown", "MRSyncSaveAllUsers", MSync.SaveAllRanks)
end

-- TODO lot of duplicate code
if(table.HasValue(MSync.Settings.EnabledModules,"MBSync"))then
	hook.Add( "CheckPassword", "MSyncBanCheck", function( steamID64 )
		local MBSyncTbl = MSync.CheckIfBanned(util.SteamIDFrom64(steamID64))
		local time = {}
		if (MBSyncTbl==true) then
			return true
		else
			if(MBSyncTbl.duration<=0)then
				time.duration = "Permanent"
				time.unban = "Never"
			else
				time.duration 	= MBSyncTbl.duration.." minutes "
				time.unban		= os.date( "%H:%M - %d/%m/%Y" ,(MBSyncTbl.duration + MBSyncTbl.ban_date))
			end
			
			return false , (
				"[MBSync] You are banned!\n" ..
				"Reason: " .. MBSyncTbl.reason .. "\n" ..
				"Duration: " .. time.duration .. "\n" ..
				"Banned by: " .. MBSyncTbl.admin .. "\n" ..
				"Unban date: " .. time.unban
			)
		end
	end)
	
	hook.Add( "PlayerInitialSpawn", "MSyncBanCheckBackup", function( ply )
		local MBSyncTbl = MSync.CheckIfBanned(ply:SteamID())
		local time = {}
		if (MBSyncTbl==true) then
			print("[MBSync] Backup check: "..ply:GetName().." is not banned!")
		else
			if(MBSyncTbl.duration<=0)then
				time.duration = "Permanent"
				time.unban = "Never"
			else
				time.duration 	= MBSyncTbl.duration.." minutes "
				time.unban		= os.date( "%H:%M - %d/%m/%Y" ,(MBSyncTbl.duration + MBSyncTbl.ban_date))
			end
			print("[MBSync] Backup check: "..ply:GetName().." is banned!")
			ply:Kick(
				"[MBSync] You are banned!\n" ..
				"Reason: " .. MBSyncTbl.reason .. "\n" ..
				"Duration: " .. time.duration .. "\n" ..
				"Banned by: " .. MBSyncTbl.admin .. "\n" ..
				"Unban date: " .. time.unban
			)
		end
	end)
end