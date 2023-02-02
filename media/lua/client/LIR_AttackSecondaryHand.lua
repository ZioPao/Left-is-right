

function LIR_AttackWithOffHand(player, lir_data)

    -- Check if off hand has a weapon
    local off_hand_weapon = player:getSecondaryHandItem()

    if off_hand_weapon:IsWeapon() then

        ISTimedActionQueue.add(LIRAttackingWithOffHand:new(player, off_hand_weapon))
    end

    






end