-------------------------------------
----------- LEFT IS RIGHT -----------
-------------------------------------

-- Compat support for other mods

LIR_ModCompat = {
    TheOnlyCureButBetter = false    
}




local function TheOnlyCureButBetterSupport()
    require("TOC_main")
    if getActivatedMods():contains('Amputation2') == false then return end
    LIR_ModCompat.TheOnlyCureButBetter = true

    local player = getPlayer()
    local toc_limbs_data = player:getModData().TOC.Limbs

    function LIRGetTimeOverrideForAmputee()

        if toc_limbs_data["Right_Hand"].is_cut or toc_limbs_data["Right_LowerArm"].is_cut or toc_limbs_data["Right_UpperArm"].is_cut then
            return 30
        else
            return 0
        end


    end




end

Events.OnGameStart.Add(TheOnlyCureButBetterSupport)