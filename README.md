# Classic+ Pro Beta 1.0

## Addon for World of Warcraft Classic

### Overview
- A resource-efficient add-on that uses only 380kb of memory to customize and enhance the native user interface and user experience.
- The general intention for this addon was to avoid having to download a whole catalog of addons, which are often bloated with code and sometimes inefficient due to their modifiability and outdated architecture.
- Primarily download this addon as well as Questie and Auctionator, and you are ready to play.
- Gives the overall user interface a more minimalistic, streamlined look and feel, while maintaining the integrity of the game's overall art direction by using only native game textures and components.
- Adds simple but effective quality of life features with minimal processing requirements.

#### Font Change
- Moving the "fonts" folder to the "classic_" directory changes the overall in-game font.

#### Actionbars
- Textures have been removed.
- Default action bars are now centered at the bottom of the screen. 
- Range check coloring lets you know when you are in range to use a particular action by recoloring the action button.

#### Unitframes
- Now have a simpler design
- Have a fixed position (To be changed)
- Are aligned with the action buttons for a neat look and feel.

#### Nameplates
- Textures have been changed.
- The color of the respective nameplate turns orange as soon as the player has aggro.
- An enemy castbar is displayed under the respective nameplate.
- Player triggered debuffs are displayed above the respective nameplate.

#### Personal Resource Display
- A Personal Resouce display is now shown as soon as you are in combat.
- Active debuffs triggered by the player on the current target are displayed to the right of the resource display
- Active buffs on the player are displayed to the left of the resource display

#### Bags
- All bags open automatically with the "B" key.
- You will see the container slots only when the main bag is open.
- We repositioned them to emphasize the main bag over the other bags in the layout.
- Items are now positioned from left to right by default.
- Sort Button added. This only affects the additional bags, not the main bag.

#### Micromenu
- Is now located at the bottom of the screen, between the action bars and the bags, with reduced opacity.
- Becomes more visible when hovering over it.

#### Minimap
- Is now rectangular
- Always shows the server time

#### Character Pane
- Experience-related properties are now displayed at the top of the character pane.
- Replaced default character stats with more relevant values for melee and spell properties.

#### Healthcheck Feature
- Every 20 minutes there is a raid warning with a task to keep you fit.
- You can toggle this feature through the /healthcheck command

#### Chat
- Position changed
- Textures removed
- Combat log removed
- Tab-click scrolls to bottom

#### Chat Commands
- /q: Leaves the current group or raid.
- /post MESSAGE: Broadcasts MESSAGE in all joined and active chat channels.
- /spam MESSAGE: Sends MESSAGE to all players currently visible in an active /who list.
- /filter KEYWORD: Starts searching all active chats for a specified KEYWORD and posts matches to the main chat tab.
- /filter clear: Clears or stops the /filter feature.

#### Auto Looting
- Autolooting is enabled by default
- Makes autolooting instant

#### Auto Sell and Repair
- Automatically sells gray items and performs repairs (if funds are available) when interacting with merchants.