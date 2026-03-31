# ORP Ironleaf (Nicotine Pouch System)

A lightweight, immersive nicotine pouch system built for FiveM servers using **ox_inventory** and **ox_lib**.

Designed for realistic RP environments, this script introduces multi-use nicotine cans with flavor variants, tolerance effects, and clean UI integration.

---

<img width="634" height="197" alt="Lip_Pillows" src="https://github.com/user-attachments/assets/b081b860-9dc1-4c48-be3b-73ac711e3e21" />

---

## ✨ Features

* 6 flavor variants:

  * Mint
  * Peach
  * Citrus
  * Wintergreen
  * Mocha
  * Wild Berry

* 20 uses per can (durability-based system)

* Cooldown between uses

* Stress relief integration

* Stamina boost

* Nicotine tolerance system:

  * Reduced effects with repeated use
  * Visual and physical side effects

* Dynamic item labels:

  * Example: `Ironleaf Mint (14 left)`

* Flavor-based inventory icons

* Clean animations (pill-style use)

---

## 📦 Requirements

* ox_inventory
* ox_lib

---

## ⚙️ Installation

1. Download or clone this repository into your `resources` folder:

   ```
   resources/[orp]/orp_ironleaf
   ```

2. Ensure the resource in your `server.cfg`:

   ```
   ensure ox_lib
   ensure ox_inventory
   ensure orp_ironleaf
   ```

3. Add the items to your `ox_inventory/data/items.lua` (see below).

4. Add the included item images to your ox_inventory image folder.

---

## 🧪 Item Setup

Add the following items to your `ox_inventory/data/items.lua`:

```lua
    ['ironleaf_peach'] = {
        label = 'Ironleaf Peach',
        weight = 10,
        width = 1,
        height = 1,
        stack = false,
        close = true,
        consume = 0.05,
        decay = true,
        description = 'A can of peach flavored lip pillows.',
        server = {
            export = 'orp_ironleaf.ironleaf_can'
        },
        client = {
            image = 'ironleaf_peach.png'
        }
    },
```

(Repeat for all flavors)

---

## 🎮 Usage

Each can:

* Starts with 20 uses
* Reduces durability per use
* Updates label dynamically
* Applies effects and cooldown

---

## 🔧 Configuration

All settings are located in `config.lua`, including:

* Cooldown time
* Stress relief amount
* Stamina boost
* Tolerance thresholds
* Animations
* Flavor definitions

---

## 🧠 Stress Integration

Replace the function in `client.lua`:

```lua
local function applyStressRelief(amount)
    TriggerServerEvent('hud:server:RelieveStress', amount)
end
```

Adjust this to match your server's stress system.

---

## ⚠️ Notes

* Item count will remain **1 can**, not decrease per use
* Uses are tracked via durability
* Metadata updates label, description, and image dynamically

---

## 📌 Planned Features

* Multiple nicotine strengths (3mg / 6mg / 9mg)
* Custom animations (can open / pouch placement)
* Addiction system expansion
* Shop integration presets

---

## 👤 Author

XoSAPPERoX

---

## 📜 License

This project is licensed under a custom restrictive license. See `LICENSE` for details.
