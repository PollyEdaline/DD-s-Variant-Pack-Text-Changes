local skins = "Variants/"

require("resources")
require("library")
if not modloader.checkFlag("ss_disable_submenu") and not modloader.checkFlag("ss_no_submenu") then 
	if not modloader.checkFlag("ss_disable_survivors") and not modloader.checkFlag("ss_no_survivors") then
		if not modloader.checkFlag("ss_disable_skins") and not modloader.checkFlag("ss_no_skins") then 
			
			require(skins.."WARD-N")
			--require(skins.."Hermit")
			require(skins.."Courrier")
			require(skins.."Usurper")
			require(skins.."Astronaut")
			--require(skins.."Countess")
			require(skins.."FAE")
			require(skins.."Marauder")
			require(skins.."Machinist")
			--require(skins.."Monk")
			require(skins.."Runt")
			--require(skins.."Bard")
			--require(skins.."Bastion")
		end
	end
end