Config = {}

Config.Debug = false

Config.UseTime = 3200
Config.Cooldown = 60 -- seconds between pouches
Config.UsesPerCan = 20
Config.DefaultDurability = 100
Config.DurabilityPerUse = Config.DefaultDurability / Config.UsesPerCan

Config.StressRelief = 30
Config.StaminaBoost = 0.10

Config.EnableScreenEffect = true
Config.ScreenEffectName = 'FocusIn'
Config.ScreenEffectDuration = 1200

Config.NotifyTitle = 'Ironleaf'

Config.Disable = {
    move = false,
    car = false,
    combat = true,
    sprint = true
}

Config.Anims = {
    pouch = {
        dict = 'mp_suicide',
        clip = 'pill',
        flag = 49
    }
}

Config.Items = {
    ironleaf_mint = {
        flavor = 'mint',
        label = 'Mint',
        description = 'Cool and refreshing mint flavored lip pillows.',
        image = 'ironleaf_mint.png'
    },

    ironleaf_peach = {
        flavor = 'peach',
        label = 'Peach',
        description = 'Smooth peach flavored lip pillows.',
        image = 'ironleaf_peach.png'
    },

    ironleaf_citrus = {
        flavor = 'citrus',
        label = 'Citrus',
        description = 'Bright citrus flavored lip pillows.',
        image = 'ironleaf_citrus.png'
    },

    ironleaf_wintergreen = {
        flavor = 'wintergreen',
        label = 'Wintergreen',
        description = 'Classic wintergreen flavored lip pillows.',
        image = 'ironleaf_wintergreen.png'
    },

    ironleaf_mocha = {
        flavor = 'mocha',
        label = 'Mocha',
        description = 'Rich mocha flavored lip pillows.',
        image = 'ironleaf_mocha.png'
    },

    ironleaf_wildberry = {
        flavor = 'wildberry',
        label = 'Wild Berry',
        description = 'Sweet wild berry lip pillows.',
        image = 'ironleaf_wildberry.png'
    }
}

Config.Tolerance = {
    Enabled = true,

    WindowMinutes = 30,
    Threshold1 = 3,
    Threshold2 = 5,
    Threshold3 = 7,

    Penalty1 = {
        stressReliefMultiplier = 10,
        staminaMultiplier = 0.90,
        effect = 'light'
    },

    Penalty2 = {
        stressReliefMultiplier = 5,
        staminaMultiplier = 0.75,
        effect = 'medium'
    },

    Penalty3 = {
        stressReliefMultiplier = 2,
        staminaMultiplier = 0.50,
        effect = 'heavy'
    }
}