-------------------------------------
----------- LEFT IS RIGHT -----------
-------------------------------------

-- Compat support for other mods

local function TheOnlyCureButBetterSupport()
    require("TOC_main")
    if getActivatedMods():contains('Amputation2') == false then return end


    -- Add an event to check wheter the right hand is cut or not. If it is, then force the secondary mode

    local player = getPlayer()
    local mod_data = player:getModData()
    local toc_limbs_data = mod_data.TOC.Limbs
    local lir_data = mod_data.LIR

    local function CheckForceLeftHand()

        if toc_limbs_data["Right_Hand"].is_cut or toc_limbs_data["Right_LowerArm"].is_cut or toc_limbs_data["Right_UpperArm"].is_cut then
            lir_data.can_switch_hand = false
            lir_data.is_hand_switched = true
        end


    end


  Events.EveryOneMinute.Add(CheckForceLeftHand)


end

Events.OnGameStart.Add(TheOnlyCureButBetterSupport)