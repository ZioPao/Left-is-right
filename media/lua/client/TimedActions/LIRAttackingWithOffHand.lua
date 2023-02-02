require "TimedActions/ISBaseTimedAction"

LIRAttackingWithOffHand = ISBaseTimedAction:derive("LIRAttackingWithOffHand")


function LIRAttackingWithOffHand:isValid()

    return true

end

function LIRAttackingWithOffHand:update()
    print("LIR: Update")

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

    local enemies = self.character:getSpottedList()

    -- removes player from the enemies list


    if enemies:size() > 0 then
        for i = 0, enemies:size() - 1 do
            local enemy = enemies:get(i)

            if enemy ~= self.character and tonumber(enemy:DistTo(self.character)) <= self.range and not enemy:isDead() then
                enemy:Hit(self.character:getSecondaryHandItem(), self.character, 1, false, 1)
                enemy:addBlood(ZombRand(1,10))
                enemy:playHurtSound()
                enemy:splatBloodFloor()
                break

            end

        end
    end







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
    setmetatable(attackAction, self)
    self.__index = self

    attackAction.character = character
    attackAction.item = item
    attackAction.stopOnWalk = false
    attackAction.stopOnRun = false
	attackAction.stopOnAim = false
	attackAction.useProgressBar = false
    --local maxTimeCalc = tonumber(time) * tonumber(getGameTime().FPSMultiplier);
    attackAction.maxTime = 2 * 5     -- TODO should scale like the base game does
    attackAction.range = item:getMaxRange()
    --attackAction.hitSound = hitSound;
    
    --weaponSound = item:getSwingSound();

    return attackAction

end