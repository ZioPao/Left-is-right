-------------------------------------
----------- LEFT IS RIGHT -----------
-------------------------------------

-- Some stuff taken from the amazing Off Hand Attack mod from AbraxasDusk! Thanks!

-- LIST OF STUFF TO IMPLEMENT
-- TODO Switchable state (Left to Right, Right to Left)
-- TODO 



local function InitLIR()
    local player = getPlayer()
    local mod_data = player:getModData()

    mod_data.LIR = {
        is_hand_switched = false,

    }
end








-- Switch the visible thing and use the other method to perform attacks
local function SwitchPrincipalHand(player)
    print("LIR: Switch hands")


    -- Get what hand is the principal now

    -- Switch it (set anims and methods)

    local new_value = not player:getModData().LIR.is_hand_switched
    player:getModData().LIR.is_hand_switched = new_value

end



local function OnMouseDown(x, y)
    -- stop main attack and replaces it with my method
    print("LIR: OnMouseDown")
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

        SwitchPrincipalHand(player)

    end

    
end

Events.OnCreatePlayer.Add(InitLIR)
Events.OnKeyStartPressed.Add(OnKeyboardInput)

Events.OnMouseDown.Add(OnMouseDown)