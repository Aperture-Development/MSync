MSync = MSync or {}
MSync.Bans = MSync.Bans or {}
MSync.Settings = MSync.Settings or {}
MSync.ULX = MSync.ULX or {}
MSync.AllowedGroups = MSync.AllowedGroups or {}
MSync.version = "A 1.3"
MSync.MBsyncVersion = "A 1.0"
MSync.MRsyncVersion = "A 1.3"
MSync.xgui_panelVersion = "A 1.5"

concommand.Add( "msync_version", function( ply, cmd, args )
	print("[MSync] Version: \nMSync version: "..MSync.version.." \nMBSync version: "..MSync.MBsyncVersion.." \nMRSync version: "..MSync.MRsyncVersion.." \nMSync XGUI version: "..MSync.xgui_panelVersion)
end )

//Load Function on Enable of the Addon
function MSync.load()

	if not (file.Exists( "msync/settings.txt", "DATA" ))then
		print("[MSync] Writting Settings File")
		file.CreateDir( "msync" )
		
		MSync.Settings = {
			Servergroup = "Default",
			EnabledModules = {
				"MRSync"
			},
			DisabledModules = {
				"MBSync"
			},
			mysql = {
				Host = "127.0.0.1",
				Port = 3306,
				Database = "",
				Username = "root",
				Password = ""
			},
			mrsync = {
				AllServerRanks = {
					"owner",
					"superadmin",
					"admin"
				},
				IgnoredRanks = {
					"drp_donator",
					"drp_admin"
				}
			}
		}
		
		file.Write( "msync/settings.txt", util.TableToJSON( MSync.Settings, true ))
		
	elseif(file.Exists( "msync/settings.txt", "DATA" ))then
		print("[MSync] Getting Settings File")
		MSync.Settings = util.JSONToTable( file.Read( "msync/settings.txt", "DATA" ))
		
	end

	util.AddNetworkString( "MSyncRevertSettings" )
	util.AddNetworkString( "MSyncTableSend" )
	util.AddNetworkString( "MSyncGetSettings" )
	util.AddNetworkString( "MSyncChatPrint" )
	util.AddNetworkString( "MSyncGetBans" )
	util.AddNetworkString( "MSyncRevertBans" )
	include( "autorun/server/sv_msync_modules.lua" )
	include( "msync/mysql_main.lua" )
	if(table.HasValue(MSync.Settings.EnabledModules,"MBSync"))then
		MSync.GetBans()
	end
end

function MSync.SaveSettings()
	file.Write( "msync/settings.txt", util.TableToJSON( MSync.Settings, true ))
end

//Read Groups for Permissions



//Send Settings to Players
net.Receive("MSyncGetSettings", function( len, ply )
			
			local plygroup = ply:GetUserGroup()
			if(ULib.ucl.query(ply,"xgui_msync"))then
				net.Start("MSyncRevertSettings")
					net.WriteTable( MSync.Settings )
				net.Send(ply)
			else
				MSync.SendMessageToAdmins(Color(255,255,255),"WARNING: Player: "..ply:GetName().." Tryed to Exploit the Server and got Kicked! (A2)")
				ply:Kick( "[MSync] CSLua: Tryed to Force get Server Settings Table (A2)" )
			end
			
end)

//Get The Ban Table
net.Receive("MSyncGetBans", function( len, ply )
			
			local plygroup = ply:GetUserGroup()
			MSync.GetBans()
			if(ULib.ucl.query(ply,"xgui_msync"))then
				net.Start("MSyncRevertBans")
					net.WriteTable( MSync.Bans )
				net.Send(ply)
			else
				MSync.SendMessageToAdmins(Color(255,255,255),"WARNING: Player: "..ply:GetName().." Tryed to Exploit the Server and got Kicked! (A2)")
				ply:Kick( "[MSync] CSLua: Tryed to Force get Server Settings Table (A2)" )
			end
			
end)
//Get Table and save the Settings
net.Receive("MSyncTableSend", function( len, ply )

		local plygroup = ply:GetUserGroup()
		if(ULib.ucl.query(ply,"xgui_msync"))then
			MSync.Settings = net.ReadTable()
			MSync.SaveSettings()
		else
			MSync.SendMessageToAdmins(Color(255,255,255),"WARNING: Player: "..ply:GetName().." Tryed to Exploit the Server and got Kicked! (A2)")
			ply:Kick( "[MSync] CSLua: Tryed to Force Send Settings Table (A2)" )
		end
end)

function MSync.SendMessageToAdmins(col,text)
	for k, v in pairs( player.GetAll() ) do
		if(v:IsAdmin())then
			net.Start("MSyncChatPrint")
				net.WriteColor(col)
				net.WriteString(text)
			net.Send(v)
		end
	end
end

function MSync.PrintToAll(col,text)
	net.Start("MSyncChatPrint")
		net.WriteColor(col)
		net.WriteString(text)
	net.Broadcast()
end

function MSync.Print(ply,col,text)
	net.Start("MSyncChatPrint")
		net.WriteColor(col)
		net.WriteString(text)
	net.Send(ply)
end

hook.Add( "Initialize", "MSync_Load", MSync.load )