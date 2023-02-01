

function LIR_AttackWithOffHand(player, lir_data)

    -- Check if off hand has a weapon
    local off_hand_weapon = player:getSecondaryHandItem()

    -- Check if it is actully a weapon
    -- ....
    ISTimedActionQueue.add(LIRAttackingWithOffHand:new(player, off_hand_weapon, 2, 10, nil))
    






end