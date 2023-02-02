-------------------------------------
----------- LEFT IS RIGHT -----------
-------------------------------------

-- Some stuff taken from the amazing Off Hand Attack mod from AbraxasDusk! Thanks!

-- LIST OF STUFF TO IMPLEMENT
-- TODO Switchable state (Left to Right, Right to Left)
-- TODO Add a way to use some specific objects with the secondary hand
-- TODO Implement multi hit
-- TODO Add malus for 2 handed weapons 
-- TODO Damage values are kinda fucked, not sure why

local function LIR_AttackWithOffHand(player)

    -- Check if off hand has a weapon
    local off_hand_weapon = player:getSecondaryHandItem()

    if off_hand_weapon:IsWeapon() then

        ISTimedActionQueue.add(LIRAttackingWithOffHand:new(player, off_hand_weapon))
    end
end





local function OnMouseDown(x, y)
    -- TODO we can't really "override" the main attack, so it can still cause some issues
    -- stop main attack and replaces it with my method
    local player = getPlayer()
    local lir_data = player:getModData().LIR

    if player and player:isAiming() then
        if lir_data.is_hand_switched then
            LIR_AttackWithOffHand(player)
        else
            print("LIR: Normal attack")
        end
    end

end


-- Check for keyboard input to switch hands
local function OnKeyboardInput(key)
    
    local player = getPlayer()
    local lir_data = player:getModData().LIR

    -- check if 9 is pressed
    if key == 45 and lir_data.can_switch_hand then

        local new_value = not player:getModData().LIR.is_hand_switched
        player:getModData().LIR.is_hand_switched = new_value

    end

    
end


local function InitLIR()
    local player = getPlayer()
    local mod_data = player:getModData()

    mod_data.LIR = {
        is_hand_switched = false,
        can_switch_hand = true,

    }

    Events.OnKeyStartPressed.Add(OnKeyboardInput)
    Events.OnMouseDown.Add(OnMouseDown)
end







Events.OnCreatePlayer.Add(InitLIR)
