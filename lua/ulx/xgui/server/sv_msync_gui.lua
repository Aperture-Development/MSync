ULib.ucl.registerAccess(	"xgui_msync", "superadmin", "Allows to see and Change the MRSync Settings.", "XGUI" )
local mrsync = {}
function mrsync.Init()
	xgui.addDataType( "MSync-Settings", function() return MSync.Settings end, "xgui_msync", 0, -10 )
end
xgui.addSVModule( "MSync", mrsync.Init )