if(table.HasValue(MSync.Settings.EnabledModules,"MRSync"))then	
	print("[MRSync] Loading...")
	//Function to load a Players Rank
	function MSync.LoadRank(ply)
		print("[MRSync] Loading Player Rank...")
			local queryQ = MSync.DB:query("SELECT * FROM `mrsync` WHERE steamid = '" .. ply:SteamID() .. "' AND (`servergroup` = '" .. MSync.Settings.Servergroup .. "' OR `servergroup` = 'allserver')")
			queryQ.onData = function(Q,D)
					queryQ.onSuccess = function(q)
						if checkQuery(q) then
							print("[MRSync] "..ply:GetName().." Status: "..tostring(ply:IsUserGroup(D.groups)))
							
							if( ply:IsUserGroup(D.groups))then
							
								print("[MRSync] User "..ply:GetName().." is already in his Group!")
								
							elseif(D.groups=="user")then
							
								RunConsoleCommand( 'ulx', 'removeuserid', ply:SteamID() )
								print("[MRSync] Adding "..ply:GetName().." to Group "..D.groups)
								MSync.PrintToAll(Color(255,255,255),"Adding "..ply:GetName().."to Group "..D.groups)
								
							else
							
								print("[MRSync] Adding "..ply:GetName().." to Group "..D.groups)
								RunConsoleCommand( 'ulx', 'adduserid', ply:SteamID(),D.groups )
								MSync.PrintToAll(Color(255,255,255),"Adding "..ply:GetName().."to Group "..D.groups)
								
							end
						end
					end
			end
			queryQ.onError = function(Q,E) print("Q1") print(E) end
			queryQ:start()

	end
	// Function to save a Single user 
	function MSync.SaveRank(ply)
		print("[MRSync] Saving Player Rank...")
		local plyTable = {
			steamid = ply:SteamID(),
			rank = ply:GetUserGroup(),
			name = ply:GetName()
		}
		
		local deleteQ = MSync.DB:query("DELETE FROM `mrsync` WHERE `steamid` = '" .. plyTable.steamid .. "' AND (`servergroup` = '" .. MSync.Settings.Servergroup .. "' OR `servergroup` = 'allserver')")
		deleteQ.onSuccess = function(q)
			if checkQuery(q) then
					print ("[MRSync] User "..plyTable.name.." is already created")
			end
		end
		deleteQ:start()

			   
		if not(table.HasValue(MSync.Settings.mrsync.AllServerRanks,plyTable.rank)) and not(table.HasValue(MSync.Settings.mrsync.IgnoredRanks,plyTable.rank)) then
		
			local InsertQ = MSync.DB:query("INSERT INTO `mrsync` (`steamid`, `groups`, `servergroup`) VALUES ('"..plyTable.steamid.."', '"..plyTable.rank.."','"..MSync.Settings.Servergroup.."')")
			InsertQ.onError = function(Q,E) print("Q1") print(E) end
			InsertQ:start()
			print ("[MRSync] User "..plyTable.name.." got Saved")
			
		elseif(table.HasValue(MSync.Settings.mrsync.AllServerRanks,plyTable.rank)) and not(table.HasValue(MSync.Settings.mrsync.IgnoredRanks,plyTable.rank)) then
		
			local InsertQ = MSync.DB:query("INSERT INTO `mrsync` (`steamid`, `groups`, `servergroup`) VALUES ('"..plyTable.steamid.."', '"..plyTable.rank.."','allserver')")
			InsertQ.onError = function(Q,E) print("Q1") print(E) end
			InsertQ:start()
			print ("[MRSync] User "..plyTable.name.." SID: "..ply:SteamID().." got Saved [A]")
			
		end

	end
	//Function to save all users
	function MSync.SaveAllRanks()
		print("[MRSync] Saving Player Ranks...")
		local plyTable = player.GetAll()
		for k,v in pairs(plyTable) do

			local deleteQ = MSync.DB:query("DELETE FROM `mrsync` WHERE `steam` = '" .. v:SteamID() .. "' AND `servergroup` = '" .. MSync.Settings.Servergroup .. "' OR `servergroup` = 'allserver'")
			deleteQ.onSuccess = function(q)
				if checkQuery(q) then
					print("[MRSync] Saving Users...")
				end
			end
			deleteQ:start()

				   
			if not(table.HasValue(MSync.Settings.mrsync.AllServerRanks,v:GetUserGroup())) and not(table.HasValue(MSync.Settings.mrsync.IgnoredRanks,v:GetUserGroup())) then
			
				local InsertQ = MSync.DB:query("INSERT INTO `mrsync` (`steamid`, `groups`, `servergroup`) VALUES ('"..v:SteamID().."', '"..v:GetUserGroup().."','"..MSync.Settings.Servergroup.."')")
				InsertQ.onError = function(Q,E) print("Q1") print(E) end
				InsertQ:start()
				
			elseif(table.HasValue(MSync.Settings.mrsync.AllServerRanks,v:GetUserGroup())) and not(table.HasValue(MSync.Settings.mrsync.IgnoredRanks,v:GetUserGroup())) then
			
				local InsertQ = MSync.DB:query("INSERT INTO `mrsync` (`steamid`, `groups`, `servergroup`) VALUES ('"..v:SteamID().."', '"..v:GetUserGroup().."','allserver')")
				InsertQ.onError = function(Q,E) print("Q1") print(E) end
				InsertQ:start()
				
			end
		end

	end
	print("[MRSync] Loading completed")
	
end