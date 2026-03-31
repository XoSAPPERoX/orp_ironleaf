local effectActive = false

local function debugPrint(...)
    if Config.Debug then
        print('[orp_ironleaf]', ...)
    end
end

local function loadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return end

    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Wait(50)
    end
end

local function playTimedAnim(animData)
    loadAnimDict(animData.dict)

    TaskPlayAnim(
        PlayerPedId(),
        animData.dict,
        animData.clip,
        3.0,
        3.0,
        animData.duration or -1,
        animData.flag or 49,
        0.0,
        false,
        false,
        false
    )

    Wait(animData.duration or 1000)
    ClearPedTasks(PlayerPedId())
end

local function applyStressRelief(amount)
    amount = tonumber(amount) or 0
    if amount <= 0 then return end
    TriggerServerEvent('hud:server:RelieveStress', amount)
end

local function doLightToleranceFeedback()
    lib.notify({
        title = Config.NotifyTitle,
        description = 'That one does not hit quite like the first few did.',
        type = 'inform'
    })
end

local function doMediumToleranceFeedback()
    if not effectActive then
        effectActive = true
        AnimpostfxPlay('SuccessTrevor', 0, false)

        CreateThread(function()
            Wait(1200)
            AnimpostfxStop('SuccessTrevor')
            effectActive = false
        end)
    end

    lib.notify({
        title = Config.NotifyTitle,
        description = 'Too much nicotine is starting to make you feel a little off.',
        type = 'warning'
    })
end

local function doHeavyToleranceFeedback()
    local ped = PlayerPedId()

    if not effectActive then
        effectActive = true
        AnimpostfxPlay('Dont_tazeme_bro', 0, false)

        CreateThread(function()
            Wait(1800)
            AnimpostfxStop('Dont_tazeme_bro')
            effectActive = false
        end)
    end

    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)

    CreateThread(function()
        Wait(1500)
        StopGameplayCamShaking(true)
    end)

    if not IsPedRagdoll(ped) then
        SetPedToRagdoll(ped, 900, 900, 0, false, false, false)
    end

    lib.notify({
        title = Config.NotifyTitle,
        description = 'You overloaded yourself with nicotine and feel sick.',
        type = 'error'
    })
end

lib.callback.register('orp_ironleaf:client:beginUse', function(displayLabel)
    local ped = PlayerPedId()

    if IsEntityDead(ped) then
        return false
    end

    if IsPedSwimming(ped) or IsPedSwimmingUnderWater(ped) then
        lib.notify({
            title = Config.NotifyTitle,
            description = 'Now is not the time for that.',
            type = 'error'
        })
        return false
    end

    loadAnimDict(Config.Anims.pouch.dict)

    local success = lib.progressCircle({
        duration = Config.UseTime,
        label = ('Using %s...'):format(displayLabel or 'Ironleaf'),
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = Config.Disable,
        anim = {
            dict = Config.Anims.pouch.dict,
            clip = Config.Anims.pouch.clip,
            flag = Config.Anims.pouch.flag
        }
    })

    ClearPedTasks(ped)

    return success
end)

RegisterNetEvent('orp_ironleaf:client:applyEffects', function(payload)
    if not payload then return end

    local flavorLabel = payload.flavorLabel or 'Original'
    local usesLeft = payload.usesLeft or 0
    local stressRelief = payload.stressRelief or 0
    local staminaBoost = payload.staminaBoost or 0
    local toleranceEffect = payload.toleranceEffect

    applyStressRelief(stressRelief)
    RestorePlayerStamina(PlayerId(), staminaBoost)

    if Config.EnableScreenEffect then
        if not effectActive then
            effectActive = true
            AnimpostfxPlay(Config.ScreenEffectName, 0, false)

            CreateThread(function()
                Wait(Config.ScreenEffectDuration)
                AnimpostfxStop(Config.ScreenEffectName)
                effectActive = false
            end)
        end
    end

    if toleranceEffect == 'light' then
        doLightToleranceFeedback()
    elseif toleranceEffect == 'medium' then
        doMediumToleranceFeedback()
    elseif toleranceEffect == 'heavy' then
        doHeavyToleranceFeedback()
    end

    lib.notify({
        title = Config.NotifyTitle,
        description = ('%s pouch used. %s left in the can.'):format(flavorLabel, usesLeft),
        type = 'success'
    })
end)
