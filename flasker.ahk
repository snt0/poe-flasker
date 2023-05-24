#IfWinActive Path of Exile
#Persistent
#NoEnv
#SingleInstance force
#MaxHotkeysPerInterval 32767
#HotkeyInterval 32767
#KeyHistory 0
ListLines Off
Process, Priority, , L
SetBatchLines, -1
SetKeyDelay, -1, 25
SetMouseDelay, -1
SetWinDelay, -1
SetControlDelay, -1
SendMode Input

; DEFAULT CONFIGURATION
; ----------------------------------------------------
flask_hotkeys := {1:1, 2:2, 3:3, 4:4, 5:5} ; flask position to keybind mapping
flask_enabled := {1:True, 2:True, 3:True, 4:True, 5:True} ; active status of each flask

toggle_key := "F2" ; key to toggle autoflask script on/off
open_gui_key := "F6" ; key to open GUI to change flask settings
attack_key := "q" ; key used to determine if we're in combat 

require_combat := True ; only use flasks when in combat
combat_flask_timer := 1000 ; how long to wait before stopping flasking after attacking

flask_origin_x := 316 ; x-origin of flask bar
flask_origin_y := 1072 ; y-origin of flask bar

delay_lower := 57 ; lower bound of sleep duration
delay_upper := 114 ; upper bound of sleep duration

tooltip_duration := 500 ; how long to keep tooltip up

flask_dur_col := "0x99D7F9" ; duration bar colour

; ----------------------------------------------------

; 1920x1080 values
flask_dur_l = 46 ; length from start of 1 flask bar to start of next
flask_dur_h = 3 ; half height
flask_dur_w = 32 ; width of duration bar 

; load default values from config file if not done yet
config := "flasker_config.ini"

If !FileExist(config) {
	IniWrite, %toggle_key%, %config%, hotkeys, toggle_key
	IniWrite, %attack_key%, %config%, hotkeys, attack_key

	for k, v in flask_hotkeys
		IniWrite, %v%, %config%, flask_hotkeys, %k%
	for k, v in flask_enabled
		IniWrite, %v%, %config%, flask_enabled, %k%

} Else If FileExist(config) {
	IniRead, toggle_key, %config%, hotkeys, toggle_key, %toggle_key%
	IniRead, attack_key, %config%, hotkeys, attack_key, %attack_key%
	IniRead open_gui_key, %config%, user_config, open_gui_key, %open_gui_key%
	IniRead, require_combat, %config%, combat, enabled, %require_combat%
	IniRead, combat_flask_timer, %config%, combat, timer, %combat_flask_timer%
	IniRead, flask_origin_x, %config%, flask_origin, flask_origin_x, %flask_origin_x%
	IniRead, flask_origin_y, %config%, flask_origin, flask_origin_y, %flask_origin_y%


	IniRead, flask_str, %config%, flask_hotkeys
	flask_hotkeys := {}
	Loop, Parse, flask_str, `n 
	{
		arr := StrSplit(A_LoopField, "=")
		flask_hotkeys[arr[1]] := arr[2]
	}
	Loop, 5
	{
		IniRead, isActive, %config%, flask_enabled, %A_Index%, True
		flask_enabled[A_Index] := isActive ? True : False
	}
}

Hotkey %toggle_key%, toggle_flasking
Hotkey ~%attack_key%, attack
Hotkey %open_gui_key%, open_gui
Return

; toggle flasking behaviour
toggle_flasking:
	ToolTip, % "Autoflask " ((flasking := !flasking) ? "enabled" : "disabled"), 316, 968
	; If we're disabling autoflasking, turn off the timer 
	If (!flasking){
		SetTimer, flask_timer, % "Off"
	}

	Else if (!require_combat){
		SetTimer, flask_timer, % 1
	}

	SetTimer, remove_tooltip, -%tooltip_duration%
Return

attack:
    If (!flasking) {
        Return
    } Else {
        SetTimer, flask_timer, % 1
        ; Reset the attack_delay timer every time attack is called.
        SetTimer, attack_delay, %combat_flask_timer%
        Return
    }

attack_delay:
    ; This subroutine is called if attack hasn't been called for 1 second.
    SetTimer, flask_timer, % "Off"
    ; Turn off the attack_delay timer as we don't want it to keep firing.
    SetTimer, attack_delay, % "Off"
Return

; autoflasking subroutine
flask_timer:
	If !flasking
		Return
	For flask_pos, flask_bind in flask_hotkeys {
		If flask_enabled[flask_pos] { ; If the flask is set to be used
			x := flask_origin_x + flask_dur_l * (flask_pos - 1)
			PixelGetColor, flask_col, %x%, %flask_origin_y%

			If (flask_col != flask_dur_col) {
				Send %flask_bind%
				Random, delay, delay_lower, delay_upper
				Sleep %delay%
			}
		}
	}
Return


; GUI labels and elements
open_gui:
	; Stop flasking
	flasking := False
	SetTimer, flask_timer, % "Off"

	; Create GUI
	Gui, Autoflask_Config:New, , Flasker Configuration
	 ; Create tab control
    Gui, Autoflask_Config:Add, Tab, x2 y2 w350 h190 vTab, Flask Config|Application Hotkeys

	Gui, Autoflask_Config:Add, Text, x20 y30, Active Flasks:
	Loop, 5
	{
		xPos := 20 + 55 * (A_Index - 1)
		isChecked := flask_enabled[A_Index] ? "Checked" : ""
		Gui, Autoflask_Config:Add, Checkbox, x%xPos% y50 vActiveFlask%A_Index% %isChecked%, %A_Index%
		Gui, Autoflask_Config:Add, Text, x%xPos% y70 w50 r1, Hotkey %A_Index%:
		Gui, Autoflask_Config:Add, Edit, x%xPos% y90 w50 vFlaskHotkey%A_Index%, % flask_hotkeys[A_Index]
	}

	; Require combat toggle
	Gui, Autoflask_Config:Add, Checkbox, x20 y130 vRequireCombat, Require combat
	; Check if enabled
	If (require_combat) {
		GuiControl, , RequireCombat, 1
	}
	; Combat flask flask_timer
	Gui, Autoflask_Config:Add, Text, x150 y130, Combat delay(ms):
	Gui, Autoflask_Config:Add, Edit, x250 y130 w50 vCombatFlaskTimer, %combat_flask_timer%

	; Flask Origin
	Gui, Autoflask_Config:Add, Button, x250 y160 w80 h20 gset_flask_origin, Set Origin
	Gui, Autoflask_Config:Add, Text, x20 y160, Flask X,Y Origin:
	Gui, Autoflask_Config:Add, Edit, x100 y160 w50 vFlaskOriginX, %flask_origin_x%
	Gui, Autoflask_Config:Add, Edit, x170 y160 w50 vFlaskOriginY, %flask_origin_y%

	; Add content to Hotkeys tab
	Gui, Tab, Application Hotkeys
    Gui, Autoflask_Config:Add, Text, x20 y50, Attack Key:
    Gui, Autoflask_Config:Add, Edit, x120 y50 w80 vAttackKey, %attack_key%
    Gui, Autoflask_Config:Add, Text, x20 y80, Toggle Flasking Key:
    Gui, Autoflask_Config:Add, Edit, x120 y80 w80 vToggleKey, %toggle_key%
    Gui, Autoflask_Config:Add, Text, x20 y110, Open GUI Key:
    Gui, Autoflask_Config:Add, Edit, x120 y110 w80 vOpenGuiKey, %open_gui_key%

	Gui, Tab
	; Save button
	Gui, Autoflask_Config:Add, Button, x100 y200 w100 h30 gsave_config, Save

	; Close button
	Gui, Autoflask_Config:Add, Button, x200 y200 w100 h30 gClose_Config, Cancel

	Gui, Autoflask_Config:Tab, Flask Config ; set initial tab
	Gui, Autoflask_Config:Show, w350 h250, Flasker Configuration
Return

; Flask Origin button action
setting_origin := False

set_flask_origin:
	Gui, Autoflask_Config:Hide
	MsgBox, Press F7 to reposition the flask origin, press F8 to save the last location.
	setting_origin := True
return

#If setting_origin
F7::
	SetTimer, remove_tooltip, 1
	; Get mouse position
	CoordMode, Mouse, Screen
	MouseGetPos, x, y
	flask_origin_x := x
	flask_origin_y := y

	; Draw small squares for the 5 flasks
	Loop, 5 {
		x := flask_origin_x + flask_dur_l * (A_Index - 1)
		Gui, FlaskSquare%A_Index%:New, +AlwaysOnTop -Caption +ToolWindow
		Gui, FlaskSquare%A_Index%:Color, Red
		Gui, FlaskSquare%A_Index%:Add, Text, , %A_Space%
		Gui, FlaskSquare%A_Index%:Show, x%x% y%flask_origin_y% w%flask_dur_w% h%flask_dur_h%
	}

	Sleep 1000 ; Keep squares visible for 2 seconds

	; Destroy flask origin squares
	Loop, 5 {
		Gui, FlaskSquare%A_Index%:Destroy
	}
	Return

F8::
	; Lock and save flask origin
	; Update Edit controls in GUI
	Gui, Autoflask_Config:Show
	GuiControl,Autoflask_Config:, FlaskOriginX, %flask_origin_x%
	GuiControl,Autoflask_Config:, FlaskOriginY, %flask_origin_y%
	setting_origin := False
	Return
	
#If

; Save button action
save_config:
	Gui, Autoflask_Config:Submit, NoHide
	flask_origin_x := FlaskOriginX
	flask_origin_y := FlaskOriginY
	require_combat := RequireCombat
	combat_flask_timer := CombatFlaskTimer
	IniWrite, %flask_origin_x%, %config%, flask_origin, x
	IniWrite, %flask_origin_y%, %config%, flask_origin, y

	IniWrite, %require_combat%, %config%, combat, enabled
	IniWrite, %combat_flask_timer%, %config%, combat, timer

	Loop, 5
	{
		GuiControlGet, active, , ActiveFlask%A_Index%
		GuiControlGet, hotkey, , FlaskHotkey%A_Index%
		flask_enabled[A_Index] := active
		flask_hotkeys[A_Index] := hotkey
		IniWrite, %hotkey%, %config%, flask_hotkeys, %A_Index%
		IniWrite, %active%, %config%, flask_enabled, %A_Index%
	}

	old_toggle_key := toggle_key
    old_attack_key := attack_key
    old_gui_key := open_gui_key

    toggle_key := ToggleKey
    attack_key := AttackKey
    open_gui_key := OpenGuiKey

    assign_hotkeys(old_toggle_key, toggle_key, old_attack_key, attack_key, old_gui_key, open_gui_key)

	IniWrite, %toggle_key%, %config%, hotkeys, toggle_key
	IniWrite, %open_gui_key%, %config%, hotkeys, open_gui_key

	Gui, Autoflask_Config:Destroy

return

assign_hotkeys(old_toggle_key, new_toggle_key, old_attack_key, new_attack_key, old_gui_key, new_gui_key) {
	; Unassign old keys and assign new keys only if they have changed
    if (old_toggle_key != new_toggle_key) {
        Hotkey, %old_toggle_key%, Off
        Hotkey, %new_toggle_key%, toggle_flasking
    }
    if (old_attack_key != new_attack_key) {
        Hotkey, %old_attack_key%, Off
        Hotkey, ~%new_attack_key%, attack
    }
    if (old_gui_key != new_gui_key) {
        Hotkey, %old_gui_key%, Off
        Hotkey, %new_gui_key%, open_gui
    }
}

; Close button action
Close_Config:
	Gui, Autoflask_Config:Destroy
Return

; Clear any existing tooltips
remove_tooltip:
	ToolTip
Return

; Bind Ctrl F5 to reload the script for debugging
^F5::
	Reload