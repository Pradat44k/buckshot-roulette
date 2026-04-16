#Requires AutoHotkey v2.0
#SingleInstance Force
CoordMode("Mouse", "Screen")
CoordMode("ToolTip", "Screen")

; ============================================================
;  BUCKSHOT ROULETTE - CUSTOM KEYBINDS v2.0
;  Avec Menu de Calibration GUI
; ============================================================

; --- CONFIG FILE ---
configFile := A_ScriptDir "\BuckshotKeys.ini"

; --- POSITIONS (chargées depuis le fichier INI ou par défaut) ---
positions := Map()
positions["shoot_self"]  := {name: "🔫 Tirer sur SOI (Q)",    x: 960,  y: 750, key: "q"}
positions["shoot_dealer"] := {name: "🎯 Tirer sur DEALER (E)", x: 960,  y: 350, key: "e"}
positions["item_1"]      := {name: "📦 Item 1",                x: 500,  y: 850, key: "1"}
positions["item_2"]      := {name: "📦 Item 2",                x: 580,  y: 850, key: "2"}
positions["item_3"]      := {name: "📦 Item 3",                x: 660,  y: 850, key: "3"}
positions["item_4"]      := {name: "📦 Item 4",                x: 740,  y: 850, key: "4"}
positions["item_5"]      := {name: "📦 Item 5",                x: 820,  y: 850, key: "5"}
positions["item_6"]      := {name: "📦 Item 6",                x: 900,  y: 850, key: "6"}
positions["item_7"]      := {name: "📦 Item 7",                x: 980,  y: 850, key: "7"}
positions["item_8"]      := {name: "📦 Item 8",                x: 1060, y: 850, key: "8"}

; --- ÉTAT ---
calibrating := ""
scriptActive := true

; --- CHARGER CONFIG ---
LoadConfig()

; --- CRÉER LE MENU GUI ---
CreateMainGUI()

; ============================================================
;  FONCTIONS
; ============================================================

LoadConfig() {
    global positions, configFile
    if !FileExist(configFile)
        return
    for id, pos in positions {
        x := IniRead(configFile, "Positions", id "_x", pos.x)
        y := IniRead(configFile, "Positions", id "_y", pos.y)
        positions[id] := {name: pos.name, x: Integer(x), y: Integer(y), key: pos.key}
    }
}

SaveConfig() {
    global positions, configFile
    for id, pos in positions {
        IniWrite(pos.x, configFile, "Positions", id "_x")
        IniWrite(pos.y, configFile, "Positions", id "_y")
    }
}

CreateMainGUI() {
    global positions, mainGui, statusText, btnMap

    btnMap := Map()

    mainGui := Gui("+AlwaysOnTop +ToolWindow", "🎮 BuckshotKeys v2.0")
    mainGui.BackColor := "0x1a1a2e"
    mainGui.SetFont("s11 c0xeaeaea", "Segoe UI")

    ; --- Titre ---
    mainGui.SetFont("s16 Bold c0xe94560")
    mainGui.Add("Text", "x20 y10 w360 Center", "🎯 BUCKSHOT ROULETTE")
    mainGui.SetFont("s9 Norm c0x888888")
    mainGui.Add("Text", "x20 y40 w360 Center", "Clique sur un bouton, puis clique dans le jeu")

    ; --- Separator ---
    mainGui.SetFont("s1")
    mainGui.Add("Text", "x20 y60 w360 h2 Background0x333355")

    ; --- Section TIR ---
    mainGui.SetFont("s12 Bold c0xe94560")
    mainGui.Add("Text", "x20 y70 w360", "⚔️ TIR")
    mainGui.SetFont("s10 Norm c0xeaeaea")

    yPos := 95
    for id, pos in positions {
        if (id != "shoot_self" && id != "shoot_dealer")
            continue
        btn := mainGui.Add("Button", "x20 y" yPos " w240 h32", pos.name)
        btn.OnEvent("Click", MakeCalibHandler(id))
        coordLabel := mainGui.Add("Text", "x270 y" (yPos + 6) " w120 c0x53a653", "X:" pos.x " Y:" pos.y)
        btnMap[id] := coordLabel
        yPos += 38
    }

    ; --- Separator ---
    mainGui.SetFont("s1")
    mainGui.Add("Text", "x20 y" yPos " w360 h2 Background0x333355")
    yPos += 8

    ; --- Section ITEMS ---
    mainGui.SetFont("s12 Bold c0xe94560")
    mainGui.Add("Text", "x20 y" yPos " w360", "📦 ITEMS")
    mainGui.SetFont("s10 Norm c0xeaeaea")
    yPos += 28

    for id, pos in positions {
        if (id = "shoot_self" || id = "shoot_dealer")
            continue
        btn := mainGui.Add("Button", "x20 y" yPos " w240 h30", pos.name)
        btn.OnEvent("Click", MakeCalibHandler(id))
        coordLabel := mainGui.Add("Text", "x270 y" (yPos + 6) " w120 c0x53a653", "X:" pos.x " Y:" pos.y)
        btnMap[id] := coordLabel
        yPos += 34
    }

    ; --- Separator ---
    yPos += 5
    mainGui.SetFont("s1")
    mainGui.Add("Text", "x20 y" yPos " w360 h2 Background0x333355")
    yPos += 10

    ; --- Status ---
    mainGui.SetFont("s10 Norm c0x53a653")
    statusText := mainGui.Add("Text", "x20 y" yPos " w360 h25 Center", "✅ Prêt - Lance le jeu et utilise les touches!")
    yPos += 30

    ; --- Boutons bas ---
    mainGui.SetFont("s10 Norm c0xeaeaea")
    btnReset := mainGui.Add("Button", "x20 y" yPos " w115 h35", "🔄 Reset")
    btnReset.OnEvent("Click", (*) => ResetAll())

    btnSave := mainGui.Add("Button", "x140 y" yPos " w120 h35", "💾 Sauvegarder")
    btnSave.OnEvent("Click", (*) => ManualSave())

    btnToggle := mainGui.Add("Button", "x265 y" yPos " w115 h35", "⏸️ Pause")
    btnToggle.OnEvent("Click", (*) => ToggleScript())

    yPos += 50
    mainGui.Show("w400 h" yPos)
    mainGui.OnEvent("Close", (*) => ExitApp())
}

MakeCalibHandler(targetId) {
    return (*) => StartCalibration(targetId)
}

StartCalibration(id) {
    global calibrating, statusText, positions
    calibrating := id
    pos := positions[id]
    statusText.Value := "🔴 CLIQUE dans le jeu pour: " pos.name
    statusText.Opt("c0xe94560")

    ; Afficher un tooltip qui suit la souris
    SetTimer(CalibTooltip, 30)

    ; Attendre le clic de l'utilisateur via Hotkey
    Hotkey("~LButton", CaptureClick, "On")
}

CalibTooltip() {
    global calibrating
    if (calibrating = "") {
        SetTimer(CalibTooltip, 0)
        ToolTip()
        return
    }
    MouseGetPos(&mx, &my)
    ToolTip("📐 X:" mx " Y:" my "`nClique pour définir la position`nEchap pour annuler", mx + 20, my + 20)
}

CaptureClick(thisHotkey) {
    global calibrating, positions, statusText, btnMap
    if (calibrating = "")
        return

    ; Désactiver le hotkey
    Hotkey("~LButton", CaptureClick, "Off")
    SetTimer(CalibTooltip, 0)
    ToolTip()

    ; Capturer la position
    MouseGetPos(&mx, &my)
    id := calibrating
    pos := positions[id]
    positions[id] := {name: pos.name, x: mx, y: my, key: pos.key}

    ; Mettre à jour le label
    if btnMap.Has(id) {
        btnMap[id].Value := "X:" mx " Y:" my
        btnMap[id].Opt("c0x53a653")
    }

    ; Sauvegarder automatiquement
    SaveConfig()

    calibrating := ""
    statusText.Value := "✅ " pos.name " → X:" mx " Y:" my " (Sauvegardé!)"
    statusText.Opt("c0x53a653")
}

; Echap pour annuler la calibration
Escape:: {
    global calibrating, statusText
    if (calibrating != "") {
        Hotkey("~LButton", CaptureClick, "Off")
        SetTimer(CalibTooltip, 0)
        ToolTip()
        calibrating := ""
        statusText.Value := "✅ Calibration annulée"
        statusText.Opt("c0x53a653")
    }
}

ResetAll() {
    global positions, configFile, statusText, btnMap
    positions["shoot_self"]   := {name: "🔫 Tirer sur SOI (Q)",    x: 960,  y: 750, key: "q"}
    positions["shoot_dealer"] := {name: "🎯 Tirer sur DEALER (E)", x: 960,  y: 350, key: "e"}
    positions["item_1"]       := {name: "📦 Item 1",                x: 500,  y: 850, key: "1"}
    positions["item_2"]       := {name: "📦 Item 2",                x: 580,  y: 850, key: "2"}
    positions["item_3"]       := {name: "📦 Item 3",                x: 660,  y: 850, key: "3"}
    positions["item_4"]       := {name: "📦 Item 4",                x: 740,  y: 850, key: "4"}
    positions["item_5"]       := {name: "📦 Item 5",                x: 820,  y: 850, key: "5"}
    positions["item_6"]       := {name: "📦 Item 6",                x: 900,  y: 850, key: "6"}
    positions["item_7"]       := {name: "📦 Item 7",                x: 980,  y: 850, key: "7"}
    positions["item_8"]       := {name: "📦 Item 8",                x: 1060, y: 850, key: "8"}
    SaveConfig()
    for id, pos in positions {
        if btnMap.Has(id)
            btnMap[id].Value := "X:" pos.x " Y:" pos.y
    }
    statusText.Value := "🔄 Positions réinitialisées!"
    statusText.Opt("c0xeaeaea")
}

ManualSave() {
    global statusText
    SaveConfig()
    statusText.Value := "💾 Configuration sauvegardée!"
    statusText.Opt("c0x53a653")
}

ToggleScript() {
    global scriptActive, statusText
    scriptActive := !scriptActive
    if (scriptActive) {
        statusText.Value := "✅ Script ACTIF"
        statusText.Opt("c0x53a653")
    } else {
        statusText.Value := "⏸️ Script en PAUSE"
        statusText.Opt("c0xe94560")
    }
}

; ============================================================
;  FONCTION DE CLIC
; ============================================================

ClickAt(x, y) {
    MouseMove(x, y, 2)
    Sleep(80)
    Click()
    Sleep(50)
}

; ============================================================
;  HOTKEYS DU JEU
; ============================================================

#HotIf WinActive("Buckshot Roulette") && scriptActive && calibrating = ""

q:: {
    global positions
    p := positions["shoot_self"]
    ClickAt(p.x, p.y)
}

e:: {
    global positions
    p := positions["shoot_dealer"]
    ClickAt(p.x, p.y)
}

1:: {
    global positions
    p := positions["item_1"]
    ClickAt(p.x, p.y)
}

2:: {
    global positions
    p := positions["item_2"]
    ClickAt(p.x, p.y)
}

3:: {
    global positions
    p := positions["item_3"]
    ClickAt(p.x, p.y)
}

4:: {
    global positions
    p := positions["item_4"]
    ClickAt(p.x, p.y)
}

5:: {
    global positions
    p := positions["item_5"]
    ClickAt(p.x, p.y)
}

6:: {
    global positions
    p := positions["item_6"]
    ClickAt(p.x, p.y)
}

7:: {
    global positions
    p := positions["item_7"]
    ClickAt(p.x, p.y)
}

8:: {
    global positions
    p := positions["item_8"]
    ClickAt(p.x, p.y)
}

#HotIf
