-- -- Bindings and shit

-- function IsLirChangedHandPressed()
--     return isKeyDown(getCore():getKey('LIRChangeHand'))
-- end

-- local LIR_CreateBindings = function()

--     local LIR_bindings = {
--         {  name = '[LeftIsRight]'
--         },
--         {
--             value = "LIRChangeHand",
--             key = Keyboard.X
--         }
--     }
-- end


-- local FHcreateBindings = function()
--     --local FHnewBinds = {}
--     local FHbindings = {
--         {
--             name = '[FancyHandwork]'
--         },
--         {
--             value = 'FHModifier',
--             key = Keyboard.KEY_LCONTROL,
--         },
--         {
--             value = 'FHSwapKey',
--             action = FHswapItems,
--             key = 0,
--         },
--         {
--             value = 'FHSwapKeyMod',
--             action = FHswapItemsMod,
--             key = Keyboard.KEY_E,
--             swap = true
--         },
--     }

--     for _, bind in ipairs(FHbindings) do
--         if bind.name then
--             table.insert(keyBinding, { value = bind.name, key = nil })
--         else
--             if bind.key then
--                 table.insert(keyBinding, { value = bind.value, key = bind.key })
--             end
--         end
--     end

--     local FHhandleKeybinds = function(key)
--         local player = getSpecificPlayer(0)
--         local action
--         for _,bind in ipairs(FHbindings) do
--             if key == getCore():getKey(bind.value) then
--                 if bind.swap then
--                     if isFHModKeyDown() then
--                         action = bind.action
--                         break
--                     end
--                 else
--                     action = bind.action
--                     break
--                 end
--             end
--         end
    
--         if not action or isGamePaused() or not player or player:isDead() then
--             return 
--         end
--         action(player)
--     end

--     FancyHands.addKeyBind = function(keybind)
--         table.insert(FHbindings, keybind)
--     end

--     Events.OnGameStart.Add(function()
--         Events.OnKeyPressed.Add(FHhandleKeybinds)
--     end)
    
-- end

-- local function FancyHandwork()
--     print(getText("UI_Init_FancyHandwork"))

--     if isServer() then return end
--     FHcreateBindings()

--     Events.OnGameStart.Add(function()
--         if isClient() then
--             Events.OnPlayerUpdate.Add(function(player)
--                 fancyMP(player)
--                 calcRecentMove(player)
--             end)
--         else
--             Events.OnPlayerUpdate.Add(function(player)
--                 fancy(player)
--                 calcRecentMove(player)
--             end)
--         end
--     end)
-- end

-- FancyHandwork()