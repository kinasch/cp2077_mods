# Build Manager
## About this mod

With this mod you can save, load and reset your builds (attributes, proficiencies, perks and traits) to play around with various play-styles.
As this type of reset (including the attributes) is not part of the base game, this mod may be considered cheating.

**Please please please back-up your saves and maybe take screenshots of your current build.**

## Install:
1) Install / Update [Cyber Engine Tweaks](https://www.nexusmods.com/cyberpunk2077/mods/107) (at least v1.22.0) and [redscript](https://www.nexusmods.com/cyberpunk2077/mods/1511).
2) Download and extract the mod from here.
3) Drag the bin and r6 folders into your "Cyberpunk 2077" game folder.

## Usage:
Open the Cyber Engine Tweaks Overlay while loaded in a game save and, in the BuildManager window, create new saves or overwrite old saves, load builds or reset your current build. *For every action, please give the script a few seconds.*  
The little icons next to the saves open windows to show some information and to delete the save respectively.  
If you reload all scripts, you have to also reload a save, to get the Manager working again.

## Uninstall:
1) Close the game and delete the "BuildManager" folders from:  
1.1)  `"Cyberpunk 2077\bin\x64\plugins\cyber_engine_tweaks\mods"` and  
1.2) `"Cyberpunk 2077\r6\scripts"`

## Notes:
* Backup your saves and maybe take screenshots of your current build. This mod actively resets attributes and perk points and may cause you to not be able to use your items and skills if something goes wrong (the messages in the console are just for show, they don't actually check whether the build was saved or loaded sucessfully).
* If you're not seeing the Window in the Overlay, try reloading the save or exiting any menu.
* **Overwriting and loading a save, as well as resetting have no prompt to confirm!**
* I think I created a limit on how much saves you can have, which should be 10.
* Saves are only displayed if the level you made the build on is lower or the same as your current level (might cause problems, if you're level 45,5 and try to access a 45,8 level save, let me know if it does).

Inventory is neither saved nor updated on build load/reset. This means that you keep your current equipment not only in your inventory, but also equipped. You could load a Quick Hacking build and still have a Sandevistan equipped, for example.
Use this mod near a ripper doc (or with the [RipperDeck](https://www.nexusmods.com/cyberpunk2077/mods/2850) mod by psiberx) or your stash/wardrobe (or mods to access them in on the go).

## Thanks to
The people over at the [modding discord](https://discord.gg/Epkq79kd96).  
The [CET team](https://github.com/yamashi/CyberEngineTweaks/graphs/contributors) for [Cyber Engine Tweaks](https://github.com/yamashi/CyberEngineTweaks).  
The people behind the [decompiled code](https://codeberg.org/adamsmasher/cyberpunk).  
Especially to [psiberx](https://www.nexusmods.com/users/108159138) for the GameSession.lua from the [cet-kit](https://github.com/psiberx/cp2077-cet-kit).
