require "TimedActions/ISBaseTimedAction"

LIRAttackingWithOffHand = ISBaseTimedAction:derive("LIRAttackingWithOffHand")


function LIRAttackingWithOffHand:isValid()

    return true

end

function LIRAttackingWithOffHand:update()
    
    self.current_time = self.current_time + getGameTime():getTimeDelta()


    
    --print(self.current_time)

    if self.current_time > self.time_to_attack and (not self.has_attacked) then
        
        local enemies = self.character:getSpottedList()

        -- removes player from the enemies list
        local dist_table = {}
        local zombie_table = {}
    
    
        if enemies:size() > 0 then
            for i = 0, enemies:size() - 1 do
                local enemy = enemies:get(i)


                if enemy ~= self.character and not enemy:isDead() then

                    local calculated_distance = enemy:DistTo(self.character)
                    if calculated_distance <= self.range then
                        table.insert(dist_table, calculated_distance)
                        table.insert(zombie_table, enemy)

                    end
                    
                end
            end

            local found_minimum = 1000000       -- high value to begin with
            local found_enemy_id = nil
            for i = 1, #dist_table do
                if dist_table[i] < found_minimum then
                    found_minimum = dist_table[i]
                    found_enemy_id = i
                end
            end

            if found_enemy_id then
                local enemy = zombie_table[found_enemy_id]
                print("LIR: Found enemy")
                enemy:Hit(self.character:getSecondaryHandItem(), self.character, 1, false, 1)
                enemy:addBlood(ZombRand(1,10))
                enemy:playHurtSound()
                enemy:splatBloodFloor()
            end


        end

        self.has_attacked = true
    end

end



function LIRAttackingWithOffHand:start()


    self.character:setAuthorizeShoveStomp(false)

    -- Get attack animation
    local attackType = self.item:getSubCategory()
    local attackAnim = "OffHand_Swing"

    if attackType == "Stab" then

        attackAnim = "OffHand_Stab"

    end

    self:setActionAnim(attackAnim)


    -- TODO we should wait inbetween start and perform to perform the actual attack,

  






    --local weaponSound = self.item:getSwingSound()

    -- Play weapon sound
    --self.sound = self.character:playSound(weaponSound)

end


function LIRAttackingWithOffHand:stop()
    -- can't be stopped
end

function LIRAttackingWithOffHand:perform()

    print("Doing something")
    self.character:setAuthorizeShoveStomp(true)
end

function LIRAttackingWithOffHand:new(character, item)

    
    local attackAction = {}

    local modifier = 0.3        -- TODO Since we're probably missing something for the range calc


    setmetatable(attackAction, self)
    self.__index = self

    attackAction.character = character
    attackAction.item = item
    attackAction.stopOnWalk = false
    attackAction.stopOnRun = false
	attackAction.stopOnAim = false
	attackAction.useProgressBar = false
    --local maxTimeCalc = tonumber(time) * tonumber(getGameTime().FPSMultiplier);
    attackAction.maxTime = 12 * 5     -- TODO should scale like the base game does
    attackAction.range = item:getMaxRange() + modifier

    print(attackAction.range)

    attackAction.current_time = 0
    attackAction.time_to_attack = 0.2       -- TODO Make it dynamic
    attackAction.has_attacked = false
    --attackAction.hitSound = hitSound;
    
    --weaponSound = item:getSwingSound();

    return attackAction

end