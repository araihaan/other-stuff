#NoEnv
#Persistent
#MaxThreadsPerHotkey 2
#KeyHistory 0
ListLines Off
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
SendMode Input
CoordMode, Pixel, Screen

; HOTKEYS
key_hold_mode := "F1"     ; Self-explanatory
key_toggle_mode := "F2"     ; Key if not wanna use "key_hold" but actived
key_off_mode := "F3"        ; Key turn off hold mode and toggle mode
key_bhop_mode := "F4"       ; Bhop mode
key_hold := "XButton2"     ; Key that you hold to scan (example "XButton2")
key_gui_hide := "Home"          ; Hide-Gui
key_exit := "End"          ; Self-explanatory

; SETTINGS
global pixel_box := 2        ; Keep between min 2 and max 8
global pixel_sens := 40      ; Higher/lower = more/less color sensitive
global pixel_color := 0xFFFF55  ; Yellow="0xFEFE40", purple="0xA145A3"
global min_tap_time := 75   ; min_tap_time
global max_tap_time := 120   ; min_tap_time

global tap_time := minandmax_tap_time        ; Delay in ms between shots when triggered Humanized

bhop_mode := 0

Random, minandmax_tap_time, min_tap_time, max_tap_time

leftbound := A_ScreenWidth / 2 - pixel_box
rightbound := A_ScreenWidth / 2 + pixel_box
topbound := A_ScreenHeight / 2 - pixel_box
bottombound := A_ScreenHeight / 2 + pixel_box

Gui, +LastFound +AlwaysOnTop -Caption +Disabled
Gui, Color, 56BAFF
Gui, Font, s9, Verdana
Gui, Add, Text, x10 y10 w100 h20 Center, HanzUwU
Gui, Show, x0 y0 w120 h30, Caption GUI
Gui := 1

hotkey, %key_hold_mode%, holdmode
hotkey, %key_toggle_mode%, togglemode
hotkey, %key_off_mode%, offmode
hotkey, %key_bhop_mode%, bhopmode
hotkey, %key_gui_hide%, toggleGuiVisibility
hotkey, %key_exit%, terminate
return

start:
SoundBeep, 500, 1000
return

terminate:
SoundPlay off
SoundBeep, 500, 500
Gui, Color, 56BAFF
GuiControl, , HanzUwU, Goodbye
GuiControl, , Hold Mode, Goodbye
GuiControl, , Toggle Mode, Goodbye
GuiControl, , Off Mode, Goodbye
Sleep, 2000
ExitApp
return

toggleGuiVisibility:
    if (Gui = 1) {
        Gui, Hide
        Gui := 0
    } else if (Gui = 0) {
        Gui, Show
        Gui := 1
    }
return

holdmode:
SoundPlay, C:\Windows\Media\chimes.wav
SetTimer, loop3, Off ; Disable togglemode loop
SetTimer, loop2, 1
Gui, Color, 70FF56
GuiControl, , HanzUwU, Hold Mode
GuiControl, , Toggle Mode, Hold Mode
GuiControl, , Off Mode, Hold Mode
GuiControl, , Bhop Mode, Hold Mode
return

togglemode:
SoundPlay, C:\Windows\Media\ding.wav
SetTimer, loop2, Off ; Disable holdmode loop
SetTimer, loop3, 1
Gui, Color, 70FF56
GuiControl, , HanzUwU, Toggle Mode
GuiControl, , Hold Mode, Toggle Mode
GuiControl, , Off Mode, Toggle Mode
GuiControl, , Bhop Mode, Toggle Mode
return

offmode:
SoundPlay, C:\Windows\Media\chord.wav
SetTimer, loop2, Off ; Disable holdmode loop
SetTimer, loop3, Off ; Disable togglemode loop
Gui, Color, FF5656
GuiControl, , HanzUwU, Off Mode
GuiControl, , Hold Mode, Off Mode
GuiControl, , Toggle Mode, Off Mode
GuiControl, , Bhop Mode, Off Mode
return

bhopmode:
SoundPlay, C:\Windows\Media\chimes.wav
GuiControl, , HanzUwU, Bhop Mode
GuiControl, , Hold Mode, Bhop Mode
GuiControl, , Toggle Mode, Bhop Mode
GuiControl, , Off Mode, Bhop Mode
if (bhop_mode = 0) {
        SetTimer, loop4, 1  ; Enable bhop mode
        bhop_mode := 1
        Gui, Color, 70FF56
    } else if (bhop_mode = 1) {
        SetTimer, loop4, Off    ; Disable bhop mode
        bhop_mode := 0
        Gui, Color, FF5656
    }
return


loop2:
While GetKeyState(key_hold, "P")
{
    PixelSearchHold()
    Sleep, 1
}
return

loop3:
PixelSearchToggle()
Sleep, 1
return

loop4:
Bhop()
Sleep, 1
return

PixelSearchHold()
{
    global pixel_box, pixel_sens, pixel_color, tap_time
    global FoundX, FoundY, leftbound, topbound, rightbound, bottombound

    PixelSearch, FoundX, FoundY, leftbound, topbound, rightbound, bottombound, pixel_color, pixel_sens, Fast RGB
    If !(ErrorLevel)
    {
        if !GetKeyState("LButton")
        {
            Send, {LButton Down}
            Sleep, 1
            Send, {LButton Up}
            Sleep, %tap_time%
            Send, {LButton DownTemp}
            Sleep, 1
            Send, {LButton Up}
            Sleep, 1
        }
        else if GetKeyState("LButton")
        {
            Sleep, 1
        }
        Sleep, 1
    }
    return
}

PixelSearchToggle()
{
    global pixel_box, pixel_sens, pixel_color, tap_time
    global FoundX, FoundY, leftbound, topbound, rightbound, bottombound

    PixelSearch, FoundX, FoundY, leftbound, topbound, rightbound, bottombound, pixel_color, pixel_sens, Fast RGB
    if !(ErrorLevel) 
    {
        if GetKeyState("w") or GetKeyState("a") or GetKeyState("s") or GetKeyState("d") 
        {
            Sleep, 80
        }
        else if GetKeyState("LButton") or GetKeyState("LButton Down") or GetKeyState("LButton Up")
        {
            Sleep, 10
        }
        else if !GetKeyState("LButton") 
        {
            Send, {LButton Down}
            Sleep, 1
            Send, {LButton Up}
            Sleep, %tap_time%
            Send, {LButton Down}
            Sleep, 1
            Send, {LButton Up}
            Sleep, 1
        }
        Sleep, 1
    }
    return
}


; BHOP
Bhop()
{
    if GetKeyState("Space")
    Loop
    {
        GetKeyState, state, Space, P
        If state = U
            Break
        Send, {Space}
        Sleep, 20
    }
    Sleep, 1
    return
}