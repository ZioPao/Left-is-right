-------------------------------------
----------- LEFT IS RIGHT -----------
-------------------------------------

-- Some stuff taken from the amazing Off Hand Attack mod from AbraxasDusk! Thanks!

-- LIST OF STUFF TO IMPLEMENT
-- TODO Switchable state (Left to Right, Right to Left)
-- TODO Add a way to use some specific objects with the secondary hand




local function InitLIR()
    local player = getPlayer()
    local mod_data = player:getModData()

    mod_data.LIR = {
        is_hand_switched = false,

    }
end








local function OnMouseDown(x, y)
    -- TODO we can't really "override" the main attack, so it can still cause some issues
    -- stop main attack and replaces it with my method
    local player = getPlayer()
    local lir_data = player:getModData().LIR

    if player and player:isAiming() then
        if lir_data.is_hand_switched then
            -- our methods
            LIR_AttackWithOffHand(player, lir_data)
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
    if key == 45 then

        local new_value = not player:getModData().LIR.is_hand_switched
        player:getModData().LIR.is_hand_switched = new_value

    end

    
end

Events.OnCreatePlayer.Add(InitLIR)
Events.OnKeyStartPressed.Add(OnKeyboardInput)

Events.OnMouseDown.Add(OnMouseDown)