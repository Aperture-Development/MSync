local CATEGORY_NAME = "Utility"
if(table.HasValue(MSync.Settings.EnabledModules,"MBSync"))then

	function MSync.CommandOverwrite()
		function MSync.banid( calling_ply, steamid, minutes, reason )
			steamid = steamid:upper()
			if not ULib.isValidSteamID( steamid ) then
				ULib.tsayError( calling_ply, "Invalid steamid." )
				return
			end

			local name
			local plys = player.GetAll()
			for i=1, #plys do
				if plys[ i ]:SteamID() == steamid then
					name = plys[ i ]:Nick()
					break
				end
			end

			MSync.AddBanID(steamid,reason,calling_ply,minutes)
			
		end

		local MBSyncbanid = ulx.command( CATEGORY_NAME, "ulx banid", MSync.banid, "!banid" )
		MBSyncbanid:addParam{ type=ULib.cmds.StringArg, hint="steamid" }
		MBSyncbanid:addParam{ type=ULib.cmds.NumArg, hint="minutes, 0 for perma", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
		MBSyncbanid:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=ulx.common_kick_reasons }
		MBSyncbanid:defaultAccess( ULib.ACCESS_SUPERADMIN )
		MBSyncbanid:help( "[MBSync] Bans steamid." )

		function MSync.ban( calling_ply, target_ply, minutes, reason )
			if target_ply:IsBot() then
				ULib.tsayError( calling_ply, "Cannot ban a bot", true )
				return
			end

			
			MSync.AddBan(target_ply,reason,calling_ply,minutes)
		end

		local MBSyncban = ulx.command( CATEGORY_NAME, "ulx ban", MSync.ban, "!ban" )
		MBSyncban:addParam{ type=ULib.cmds.PlayerArg }
		MBSyncban:addParam{ type=ULib.cmds.NumArg, hint="minutes, 0 for perma", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
		MBSyncban:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=ulx.common_kick_reasons }
		MBSyncban:defaultAccess( ULib.ACCESS_ADMIN )
		MBSyncban:help( "[MBSync] Bans target." )
		
		
		function MSync.unban( calling_ply, steamid )
			steamid = steamid:upper()
			if not ULib.isValidSteamID( steamid ) then
				ULib.tsayError( calling_ply, "Invalid steamid." )
				return
			end

			MSync.RemoveBan(steamid,calling_ply)
		end
		local MBSyncunban = ulx.command( CATEGORY_NAME, "ulx unban", MSync.unban,"!unban" )
		MBSyncunban:addParam{ type=ULib.cmds.StringArg, hint="steamid" }
		MBSyncunban:defaultAccess( ULib.ACCESS_ADMIN )
		MBSyncunban:help( "[MBSync] Unbans steamid." )
		
		function MSync.CheckPlayerBan(calling_ply, steamid)
		
			steamid = steamid:upper()
			if not ULib.isValidSteamID( steamid ) then
				ULib.tsayError( calling_ply, "Invalid steamid." )
				return
			end
			
			MSync.CheckBan(steamid,calling_ply)
		end
		local MBSyncbancheck = ulx.command(CATEGORY_NAME, "ulx checkban", MSync.CheckPlayerBan, "!checkban" )
		MBSyncbancheck:addParam{ type=ULib.cmds.StringArg, hint="steamid" }
		MBSyncbancheck:defaultAccess( ULib.ACCESS_ADMIN )
		MBSyncbancheck:help( "[MBSync] Check if target is Banned." )
		
		print("[MBSync] Overwritten ULX Commands")
	end

	function MSync.CheckULX()
		if not ulx.banid or not ulx.ban then
			print("[MBSync] ULX not Loaded! Rechecking in 5 Seconds!")
			timer.Simple(5,function() MSync.CheckULX() end)
		else
			MSync.CommandOverwrite()
		end
	end

	MSync.CheckULX()
end
