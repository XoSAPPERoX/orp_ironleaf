local cooldowns = {}
local useHistory = {}

local function debugPrint(...)
    if Config.Debug then
        print('[orp_ironleaf]', ...)
    end
end

local function now()
    return os.time()
end

local function getCooldownRemaining(src)
    local expires = cooldowns[src]

    if expires and expires > now() then
        return expires - now()
    end

    return 0
end

local function trimUseHistory(src)
    if not useHistory[src] then
        useHistory[src] = {}
        return
    end

    local cutoff = now() - (Config.Tolerance.WindowMinutes * 60)
    local filtered = {}

    for _, timestamp in ipairs(useHistory[src]) do
        if timestamp >= cutoff then
            filtered[#filtered + 1] = timestamp
        end
    end

    useHistory[src] = filtered
end

local function recordUse(src)
    if not useHistory[src] then
        useHistory[src] = {}
    end

    useHistory[src][#useHistory[src] + 1] = now()
    trimUseHistory(src)

    return #useHistory[src]
end

local function getTolerancePenalty(useCount)
    if not Config.Tolerance.Enabled then
        return nil
    end

    if useCount >= Config.Tolerance.Threshold3 then
        return Config.Tolerance.Penalty3
    elseif useCount >= Config.Tolerance.Threshold2 then
        return Config.Tolerance.Penalty2
    elseif useCount >= Config.Tolerance.Threshold1 then
        return Config.Tolerance.Penalty1
    end

    return nil
end

local function getUsesLeftFromDurability(durability)
    durability = durability or Config.DefaultDurability

    local usesLeft = math.ceil(durability / Config.DurabilityPerUse)

    if usesLeft < 0 then
        usesLeft = 0
    end

    if usesLeft > Config.UsesPerCan then
        usesLeft = Config.UsesPerCan
    end

    return usesLeft
end

local function getItemData(itemName)
    return Config.Items[itemName]
end

local function buildDisplayName(itemName, usesLeft)
    local itemData = getItemData(itemName)
    if not itemData then return 'Ironleaf' end

    return ('Ironleaf %s (%s left)'):format(itemData.label, usesLeft)
end

local function buildDescription(itemName, usesLeft)
    local itemData = getItemData(itemName)
    if not itemData then
        return 'A can of Ironleaf nicotine pouches.'
    end

    return ('%s Uses left: %s.'):format(itemData.description, usesLeft)
end

local function ensureMetadata(itemName, item)
    local metadata = item.metadata or {}

    if metadata.durability == nil then
        metadata.durability = Config.DefaultDurability
    end

    return metadata
end

local function useIronleaf(event, item, inventory, slot)
    local src = inventory.id
    if not src then return false end

    local itemName = item.name
    local itemData = getItemData(itemName)

    if not itemData then
        debugPrint(('Invalid Ironleaf item used: %s'):format(itemName or 'unknown'))
        return false
    end

    if event == 'usingItem' then
        local metadata = ensureMetadata(itemName, item)
        local usesLeft = getUsesLeftFromDurability(metadata.durability)

        if usesLeft <= 0 then
            TriggerClientEvent('ox_lib:notify', src, {
                title = Config.NotifyTitle,
                description = 'That can is empty.',
                type = 'error'
            })
            return false
        end

        local remaining = getCooldownRemaining(src)
        if remaining > 0 then
            TriggerClientEvent('ox_lib:notify', src, {
                title = Config.NotifyTitle,
                description = ('Wait %s more seconds before using another pouch.'):format(remaining),
                type = 'error'
            })
            return false
        end

        local completed = lib.callback.await(
            'orp_ironleaf:client:beginUse',
            src,
            buildDisplayName(itemName, usesLeft)
        )

        if not completed then
            return false
        end

        cooldowns[src] = now() + Config.Cooldown
        return true
    end

        if event == 'usedItem' then
        local metadata = ensureMetadata(itemName, item)
        local currentDurability = item.metadata and item.metadata.durability or Config.DefaultDurability
        local newDurability = currentDurability - Config.DurabilityPerUse

        if newDurability < 0 then
            newDurability = 0
        end

        metadata.durability = newDurability

        exports.ox_inventory:SetDurability(src, slot, newDurability)

        local usesLeft = getUsesLeftFromDurability(newDurability)

        exports.ox_inventory:SetMetadata(src, slot, metadata)

        local recentUses = recordUse(src)
        local penalty = getTolerancePenalty(recentUses)

        local stressRelief = Config.StressRelief
        local staminaBoost = Config.StaminaBoost
        local toleranceEffect = nil

        if penalty then
            stressRelief = math.floor((stressRelief * penalty.stressReliefMultiplier) + 0.5)
            staminaBoost = staminaBoost * penalty.staminaMultiplier
            toleranceEffect = penalty.effect
        end

        TriggerClientEvent('orp_ironleaf:client:applyEffects', src, {
            flavor = itemData.flavor,
            flavorLabel = itemData.label,
            usesLeft = usesLeft,
            stressRelief = stressRelief,
            staminaBoost = staminaBoost,
            toleranceEffect = toleranceEffect
        })

        if usesLeft <= 0 then
            TriggerClientEvent('ox_lib:notify', src, {
                title = Config.NotifyTitle,
                description = 'The can is empty.',
                type = 'inform'
            })
        end
    end
end

exports('ironleaf_can', useIronleaf)

AddEventHandler('playerDropped', function()
    cooldowns[source] = nil
    useHistory[source] = nil
end)
