require "TimedActions/ISBaseTimedAction"

LIRAttackingWithOffHand = ISBaseTimedAction:derive("LIRAttackingWithOffHand")


-- if looking at north, then negative values
-- if looking at south, positive values


LIR_Angles = {
    south = 90,
    west = 179,     -- -179
    east = 0,
    north = -90
}

-- LIR_AcceptedRangeAngles = {
--     south = 
-- }









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
        local can_be_added = false
    
    
        if enemies:size() > 0 then
            for i = 0, enemies:size() - 1 do
                local enemy = enemies:get(i)


                if enemy ~= self.character and not enemy:isDead() then

                    local calculated_distance = enemy:DistTo(self.character)



                    if calculated_distance <= self.range then

                        print("LIR: Distance " .. calculated_distance)
                        
                        -- check angle
                        local player_angle = self.character:getDirectionAngle()

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
                            can_be_added = true
                            self:setActionAnim("OffHand_Floor")
                        end













                        -- -- Zombie south, player north

                        -- if diff_y > 0.7 then
                        --     if player_angle > 0 and player_angle < 120 then
                        --         print("Zombie south, player north")
                        --         can_be_added = true

                        --     end
                        -- end
        
                        -- -- zombie east, player west
                        -- if diff_x > 0.6 and diff_y < 0.6 then
                        --     if (player_angle > 0 and player_angle < 90) or (player_angle < 0 and player_angle > -90) then
                        --         print("Zombie east, player west")
                        --         can_be_added = true
                        --     end
        
        
                        --     -- if (player_angle > 90 and player_angle < 178) or (player_angle < -90 and player_angle > - 178) then
                        --     --     print("Yes it can hit")
        
                        --     -- end
                        -- end


                        -- -- Zombie north from player
                        -- if diff_x < 0.4 and diff_y > 0.7 then
                        --     if (player_angle < 0 and player_angle > -179) then
                        --         print("Zombie north, player south")
                        --         can_be_added = true
                        --     end
                            
                        -- end


                        -- -- Perfect East is diff_x = 1
                        -- if (diff_x > 0.8) and diff_y < 0.5 then
                        --     if (player_angle < 70 and player_angle > -70) then
                        --         print("Zombie east, player west?")
                        --         can_be_added = true
                        --     end
                        -- end

                        -- --zombie north, player east-south
                        -- if (diff_x > 0.65) and (diff_y > 0.65) then
                        --     if (player_angle < 0 and player_angle > -178) then
                        --         print("Zombie north, player east-south")
                        --         can_be_added = true
                        --     end
                        -- end

                        -- -- zombie west, player east
                        -- if (diff_x > 0.7) and (diff_y < 0.3) then
                        --     if (player_angle > 120 and player_angle < 178) or (player_angle < - 120 and player_angle > -178) then
                        --         print("zombie west, player east")
                        --         can_be_added = true
                        --     end
                        -- end

                 


                        --local enemy_position = enemy:getPosition()


                        if can_be_added then
                            table.insert(dist_table, calculated_distance)
                            table.insert(zombie_table, enemy)
                        end

                        can_be_added = false        -- reset

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
                
             


                print("LIR: Found enemy")
                local player_angle = self.character:getDirectionAngle()
                print("LIR: PlayerAngle " .. player_angle)


                -- print("LIR: player x " .. self.character:getX())
                -- print("LIR: enemy X " .. enemy:getX())
                -- print("LIR: player y " .. self.character:getY())
                -- print("LIR: enemy y " .. enemy:getY())
                -- print("LIR: player z " .. self.character:getZ())
                -- print("LIR: enemy z " .. enemy:getZ())

                --print("LIR: CompareTO " .. self.character:DistToProper(enemy))
                --local temp_p_angle = self.character:getPosition()
                --local temp_e_angle = enemy:getPosition()
                --print("LIR: Player angle " .. tostring(temp_p_angle))
                --print("LIR: Enemy angle " .. temp_e_angle)

               -- print("LIR: Diff = " .. temp_p_angle + temp_e_angle)



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
    --attackAction.hitSound = hitSound;
    
    --weaponSound = item:getSwingSound();

    return attackAction

end