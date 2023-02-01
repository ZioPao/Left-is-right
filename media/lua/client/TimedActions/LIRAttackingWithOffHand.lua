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
    --local weaponSound = self.item:getSwingSound()

    -- Play weapon sound
    --self.sound = self.character:playSound(weaponSound)

end


function LIRAttackingWithOffHand:stop()
    ISBaseTimedAction.stop(self)
end

function LIRAttackingWithOffHand:perform()

    print("Doing something")
    self.character:setAuthorizeShoveStomp(true)
end

function LIRAttackingWithOffHand:new(character, item, time, range, hitSound)

    
    local attackAction = {}
    setmetatable(attackAction, self)
    self.__index = self

    attackAction.character = character;
    attackAction.item = item;
    attackAction.stopOnWalk = false;
    attackAction.stopOnRun = false;
	attackAction.stopOnAim = false;
	attackAction.useProgressBar = false;
    --local maxTimeCalc = tonumber(time) * tonumber(getGameTime().FPSMultiplier);
    attackAction.maxTime = time * 5;
    attackAction.range = range;
    --attackAction.hitSound = hitSound;
    
    --weaponSound = item:getSwingSound();

    return attackAction;

end