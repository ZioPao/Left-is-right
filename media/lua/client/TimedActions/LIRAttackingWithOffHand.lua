require "TimedActions/ISBaseTimedAction"

LIRAttackingWithOffHand = ISBaseTimedAction:derive("LIRAttackingWithOffHand")


function LIRAttackingWithOffHand:SearchEnemy()
    local enemies = self.character:getSpottedList()

    -- removes player from the enemies list
    local dist_table = {}
    local zombie_table = {}
    local anim_table = {}
    local can_be_added = false
    local should_use_floor_anim = false
    if enemies:size() > 0 then
        for i = 0, enemies:size() - 1 do
            local enemy = enemies:get(i)
            if enemy ~= self.character and not enemy:isDead() then
                local calculated_distance = enemy:DistTo(self.character)
                if calculated_distance <= self.range then

                    print("LIR: Distance " .. calculated_distance)
                    local enemy_x = enemy:getX()
                    local player_x = self.character:getX()
    
                    local enemy_y = enemy:getY()
                    local player_y = self.character:getY()
    
                    local diff_x = player_x - enemy_x
                    local diff_y = player_y - enemy_y
    
                    print("LIR: Diff x " .. diff_x)
                    print("LIR: Diff y " .. diff_y)
    
                    local player_angle = self.character:getDirectionAngle()
                    print("LIR: PlayerAngle " .. player_angle)

                    -- TODO this is not precise enough, but it's better than nothing
                    -- TODO we should do these checks before starting the animation

                    if diff_y > 0.5 then
                        print("Zombie is north to the player")
                        can_be_added = player_angle < 0 and player_angle > -178
                    elseif diff_y < -0.5 then
                        print("Zombie is south")
                        can_be_added = player_angle > 0 and player_angle < 178
                    elseif diff_x < -0.5 then
                        print("Zombie is east")
                        can_be_added = (player_angle < 75 and player_angle > 0) or (player_angle > -75 and player_angle < 0)
                    elseif diff_x > 0.5 then
                        print("Zombie is west")
                        can_be_added = (player_angle > 90 and player_angle < 179) or (player_angle < - 90 and player_angle > -179)
                    elseif diff_x < 0.2 and diff_y < 0.2 then
                        -- Special case, zombie is really really near the player (probably downed)
                        -- TODO add actual check for the zombie to see if it's downed or not
                        can_be_added = true
                        should_use_floor_anim = true
                    end
                    if can_be_added then
                        table.insert(dist_table, calculated_distance)
                        table.insert(zombie_table, enemy)
                        table.insert(anim_table, should_use_floor_anim)
                    end

                    can_be_added = false        -- reset
                    should_use_floor_anim = false

                    print("____________________________________________")
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

        -- TODO check direction too

        if found_enemy_id then
            local enemy = zombie_table[found_enemy_id]
            local is_enemy_on_floor = anim_table[found_enemy_id]
            self.enemy_to_attack = enemy

            return is_enemy_on_floor
        end
    end
    return nil
end

function LIRAttackingWithOffHand:SetAttackAnimations(is_enemy_on_floor)

    if is_enemy_on_floor == nil or is_enemy_on_floor == false then

        local attackType = self.item:getSubCategory()
        local attackAnim = "OffHand_Swing"
    
        if attackType == "Stab" then
    
            attackAnim = "OffHand_Stab"
    
        end
    
        self:setActionAnim(attackAnim)
    
    elseif is_enemy_on_floor == true then
        self:setActionAnim("OffHand_Floor")
    end
end





function LIRAttackingWithOffHand:isValid()

    return true

end

function LIRAttackingWithOffHand:update()
    
    self.current_time = self.current_time + getGameTime():getTimeDelta()
    if self.current_time > self.time_to_attack and (not self.has_attacked) then
        if self.enemy_to_attack then
            self.enemy_to_attack:Hit(self.character:getSecondaryHandItem(), self.character, 1, false, 1)
            self.enemy_to_attack:addBlood(ZombRand(1,10))
            self.enemy_to_attack:playHurtSound()
            self.enemy_to_attack:splatBloodFloor()
            self.enemy_to_attack:playSound(self.item:getZombieHitSound())

        end
    

        self.has_attacked = true
    end

end



function LIRAttackingWithOffHand:start()


    self.character:setAuthorizeShoveStomp(false)


    -- Set enemy and animations
    local is_enemy_on_the_floor = self:SearchEnemy()
    self:SetAttackAnimations(is_enemy_on_the_floor)
	local weapon_sound = self.item:getSwingSound()
    print(weapon_sound)
    -- Play weapon sound
    self.character:playSound(weapon_sound)      -- TODO why the fuck this does not work?




    --local weaponSound = self.item:getSwingSound()

    -- Play weapon sound
    --self.sound = self.character:playSound(weaponSound)

end


function LIRAttackingWithOffHand:stop()
    -- TODO we shouldn't be able to stop it, but I've got no clue for now how to do that
    self:perform()

end

function LIRAttackingWithOffHand:perform()

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
    attackAction.maxTime = 2 * 5     -- TODO should scale like the base game does
    attackAction.range = item:getMaxRange() + modifier

    print(attackAction.range)

    attackAction.current_time = 0
    attackAction.time_to_attack = 0.2       -- TODO Make it dynamic
    attackAction.has_attacked = false
    attackAction.enemy_to_attack = nil





    --attackAction.hitSound = hitSound;
    

    return attackAction

end