# poe-flasker 

Simple and lightweight autoflasking utility for Path of Exile.

## Disclaimer

**NO** claims are made as to the permissibility of using this tool. You **are** breaking GGG's terms of service, they **may** terminate your account. I have not witnessed accounts terminated
for this or similar tools, but be aware that you are in breach of their rules and they may punish you at any time. I am not accountable for your actions.

## Features

* Automatically uses flasks as they expire
* Any selection of flasks can be used, including life flasks
* Flask hotkeys can be configured
* All configuration available in a GUI
* Flasks can be configured to always be used, or only used in combat


## Downloading and Running

Download and install the current version of AutoHotKey from [their website](https://www.autohotkey.com/).
Then, either clone the repo, direct download as raw, or <a id="raw-url" href="https://raw.githubusercontent.com/github-username/project/master/filename">click here to download flasker.ahk</a>.
Then simply run `flasker.ahk`. No window will pop up until you're in Path of Exile and press the configuration key.

I will not distribute pre-built executables. You are using an external tool to break the rules of a video game, you ought not trust random `.exe`s enough to download them off GitHub.

## Configuration

**Default Keybinds:**
| Function       | Keybind              |
|----------------|----------------------|
| F6 | Open Config GUI|
| F2             | Toggle Script On/Off |
| Q    | Primary Attack       |
| Flask 1        | 1                    |
| Flask 2        | 2                    |
| Flask 3        | 3                    |
| Flask 4        | 4                    |

Press **F6** by default to open the configuration GUI.

![Configuration GUI](https://i.imgur.com/wttec4F.png)

In the **Flask Config** tab of the GUI:

* The **checkboxes** indicate which flasks will be used when expiring
* The **hotkeys** below the checkboxes are the keys which will be pressed to use this flask
  * If your flask hotkey is unusual, for example "Left Shift", enclose this in `{curly braces}`, i.e. `{LShift}`
* The **require combat** checkbox indicates whether the script will automatically use flask at all times, or will require you to have pressed your assigned attack key within some time window
* The **combat delay** is this time window. If **require combat** is checked, and you've pressed your attack key within this window (in milliseconds), your flasks will be automatic
  * This is to save flasks during, for example, travel time in maps when you are not attacking
* The **flask origin** is the location, in pixels, on your screen where the flask bars are
  * This should be roughly the center of the left-most yellow duration bar
  * To change this value, either enter it directly or click the *Set Origin* button
  * After pressing this button, press F7 in the appropriate location indicated in the below image
  * Once the red bars look correct, press F8 to save the location
  
![Flask origin with arrow](https://i.imgur.com/cVTXyuA.png?1)

In the **Application Hotkeys** tab of the GUI:

You can adjust the keys required to trigger certain events.

* The **attack key** is the keystroke that triggers you being in combat, if require combat is enabled.
* The **toggle flasking** key simply enables or disables auto-flasking.
* The **open GUI** key is responsible for opening this configuration window.

## Troubleshooting

### A flask isn't being used

Make sure that:

1. The flask is enabled in the GUI. The checkbox should have a tick under the appropriate index.
2. The flask hotkey is correct.
3. Auto-flasking is enabled (press F2 by default).
4. Either you are in combat, or require combat is unchecked.

### Flasks are being used before they expire

1. Make sure that the origin is in the right location. Refer to the section under [Configuration](#configuration).
