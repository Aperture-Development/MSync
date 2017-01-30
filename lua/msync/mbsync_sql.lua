if(table.HasValue(MSync.Settings.EnabledModules,"MBSync"))then	
	print("[MBSync] Loading...")
	function MSync.AddBan(ply,reason,admin,duration)
		local BanPlayer = ply:GetName()
		local BanningAdmin = admin:GetName()
		local QbanAdd = MSync.DB:query("INSERT INTO `mbsync` (`steamid`, `admin`,`nickname`, `reason`,`ban_date`,`duration`) VALUES ('"..ply:SteamID().."', '"..MSync.DB:escape(admin:GetName()).."', '"..MSync.DB:escape(ply:GetName()).."' ,'"..MSync.DB:escape(reason).."',"..os.time()..","..(tonumber(duration)*60)..") ON DUPLICATE KEY UPDATE `admin`=VALUES(admin), `reason`=VALUES(reason),`ban_date`=VALUES(ban_date),`duration`=VALUES(duration)" )
		QbanAdd.onSuccess = function(q)
			MSync.PrintToAll(Color(200,0,0),"Player: "..BanPlayer.." got banned for reason: "..reason.." by: "..BanningAdmin.." for: "..duration.." minutes")
		end
		QbanAdd.onError = function(Q,E) print("Q1") print(E) end
		QbanAdd:start()
		QbanAdd:wait()
		ply:Kick(
			"[MBSync] You are banned!\n" ..
			"Reason: " .. reason .. "\n" ..
			"Duration: " .. duration .. "\n" ..
			"Banned by: " .. BanningAdmin .. "\n" ..
			"Unban date: " .. os.date("%H:%M - %d/%m/%Y" , duration + os.time())
		)
	end
	
	function MSync.AddBanID(ply,reason,admin,duration)
		local QbanIDAdd = MSync.DB:query("INSERT INTO `mbsync` (`steamid`, `admin`,`nickname`, `reason`,`ban_date`,`duration`) VALUES ('"..ply.."', '"..MSync.DB:escape(admin:GetName()).."', 'null' ,'"..MSync.DB:escape(reason).."',"..os.time()..","..(tonumber(duration)*60)..") ON DUPLICATE KEY UPDATE `admin`=VALUES(admin), `reason`=VALUES(reason),`ban_date`=VALUES(ban_date),`duration`=VALUES(duration)")
		QbanIDAdd.onSuccess = function(q)
			MSync.PrintToAll(Color(200,0,0),"Player: "..ply.." got banned for reason: "..reason.." by: "..admin:GetName().." for: "..duration.." minutes")
		end
		QbanIDAdd.onError = function(Q,E) print("Q1") print(E) end
		--game.KickID(ply,"You got banned for "..reason.." by "..admin:GetName().." for "..duration.." Minutes")
		QbanIDAdd:start()
	end
	
	function MSync.RemoveBan(ply,admin)
		local QremBan = MSync.DB:query("DELETE FROM `mbsync` WHERE `steamid` = '" .. ply .. "'")
		QremBan.onSuccess = function(q)
			MSync.PrintToAll(Color(33,255,0),"Player: "..ply.." got unbanned by: "..admin:GetName())
		end
		QremBan:start()
	end
		
	
	function MSync.CheckBan(ply,admin)
		local QcheckBan = MSync.DB:query("SELECT * FROM `mbsync` WHERE steamid = '" .. ply .. "'")
		
		QcheckBan.onError = function(Q,E) print("Q1") print(E) end
		
		QcheckBan:start()
		QcheckBan:wait()
		
		if QcheckBan:getData()[1] then
			banTable = QcheckBan:getData()
		end
		
		if QcheckBan:getData()[1] then

			if (banTable[1].duration<=0)then
				MSync.Print(admin,Color(160,160,0),"Player "..ply.." got banned for reason "..banTable.Reason.." by "..banTable.Admin.." permanently")
			elseif(banTable[1].duration + banTable[1].ban_date>=os.time())then
				MSync.Print(admin,Color(160,160,0),("Player "..ply.." got banned for reason "..banTable.reason.." by "..banTable.admin.." until "..os.date( "%H:%M - %d/%m/%Y" ,(banTable[1].duration + banTable[1].ban_date))))
			else
				MSync.Print(admin,Color(160,160,0),("Player "..ply.." got unbanned: Ban expired"))
				MSync.RemoveBan(ply,admin)
			end
		else
			MSync.Print(admin,Color(160,160,0),("Player "..ply.." is not banned."))
			
		end
		
	end
	
	function MSync.GetBans()
		local QgetBans =  MSync.DB:query("SELECT * FROM `mbsync`")
		QgetBans:start()
		QgetBans:wait()
		MSync.Bans = QgetBans:getData()
	end
	
	function MSync.CheckIfBanned(ply)
		local QcheckIfBan = MSync.DB:query("SELECT * FROM `mbsync` WHERE steamid = '" .. ply .. "'")
		local banTable = nil
		print("[MBSync] Checking if "..ply.." is banned...")
		
		QcheckIfBan.onError = function(Q,E) print("Q1") print(E) end
		
		QcheckIfBan:start()
		QcheckIfBan:wait()

		if QcheckIfBan:getData()[1] then
			banTable = QcheckIfBan:getData()
		end
		
		if QcheckIfBan:getData()[1] then

			if (banTable[1].duration<=0)then
				
				print("[MBSync] Player "..ply.." is banned.")
				banTable[1].bool = false
				return banTable[1]
			
			elseif(banTable[1].duration + banTable[1].ban_date>=os.time())then
				print("[MBSync] Player "..ply.." is banned.")
				banTable[1].bool = false
				return banTable[1]
			else
				print("[MBSync] Player "..ply.." is not banned.")
				return true
				
			end
		else
			print("[MBSync] Player "..ply.." is not banned.")
			return true
			
		end
		
	end
	
	print("[MBSync] Loading completed!")
end