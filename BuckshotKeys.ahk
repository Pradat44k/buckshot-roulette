#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================
;  BUCKSHOT ROULETTE - CUSTOM KEYBINDS par Antigravity
;  Resolution: 1920x1080
; ============================================================
;
;  CONTROLES:
;    Q  = Tirer sur SOI-MEME
;    E  = Tirer sur le DEALER
;    1  = Item slot 1 (gauche)
;    2  = Item slot 2
;    3  = Item slot 3
;    4  = Item slot 4
;    5  = Item slot 5
;    6  = Item slot 6
;    7  = Item slot 7
;    8  = Item slot 8 (droite)
;
;  UTILITAIRES:
;    F1 = Mode Calibration ON/OFF (affiche les coordonnées)
;    F2 = Sauvegarder la position actuelle de la souris
;    F3 = Recharger le script
;    F4 = Quitter le script
;
;  COMMENT CALIBRER:
;    1. Lance le jeu
;    2. Appuie F1 pour activer le mode calibration
;    3. Place ta souris sur chaque item/position
;    4. Appuie F2 pour noter la position
;    5. Modifie les coordonnées ci-dessous
;    6. Appuie F3 pour recharger
; ============================================================

; --- POSITIONS A CALIBRER (x, y pour résolution 1920x1080) ---
; Ces positions sont des estimations. Utilise F1+F2 pour calibrer !

; Position pour tirer sur soi-même
SHOOT_SELF_X := 960
SHOOT_SELF_Y := 750

; Position pour tirer sur le dealer (adversaire)
SHOOT_DEALER_X := 960
SHOOT_DEALER_Y := 350

; Positions des 8 items (de gauche à droite sur la table)
; Les items sont généralement en bas de l'écran, côté joueur
ITEM_1_X := 500
ITEM_1_Y := 850

ITEM_2_X := 580
ITEM_2_Y := 850

ITEM_3_X := 660
ITEM_3_Y := 850

ITEM_4_X := 740
ITEM_4_Y := 850

ITEM_5_X := 820
ITEM_5_Y := 850

ITEM_6_X := 900
ITEM_6_Y := 850

ITEM_7_X := 980
ITEM_7_Y := 850

ITEM_8_X := 1060
ITEM_8_Y := 850

; --- VARIABLES GLOBALES ---
calibrationMode := false
savedPositions := []

; --- TOOLTIP DE BIENVENUE ---
ToolTip("🎯 BuckshotKeys actif!`nF1 = Calibration`nF3 = Recharger`nF4 = Quitter")
SetTimer(() => ToolTip(), -3000)

; --- FONCTIONS ---
ClickAt(x, y) {
    ; Sauvegarde la position actuelle
    MouseGetPos(&origX, &origY)
    ; Déplace, clique, et revient
    MouseMove(x, y, 2)
    Sleep(50)
    Click()
    Sleep(50)
}

; ============================================================
;  HOTKEYS - Actifs uniquement quand Buckshot Roulette est ouvert
; ============================================================

; Mode calibration (F1) - toujours actif
F1:: {
    global calibrationMode
    calibrationMode := !calibrationMode
    if (calibrationMode) {
        ToolTip("📐 MODE CALIBRATION ON`nBouge la souris et regarde les coordonnées`nF2 = Sauvegarder position`nF1 = Désactiver")
        SetTimer(ShowCoords, 50)
    } else {
        SetTimer(ShowCoords, 0)
        ToolTip()
    }
}

ShowCoords() {
    MouseGetPos(&mx, &my)
    ToolTip("📐 X: " mx "  Y: " my "`nF2 = Sauvegarder cette position")
}

; Sauvegarder position (F2) - toujours actif
F2:: {
    global savedPositions
    MouseGetPos(&mx, &my)
    savedPositions.Push({x: mx, y: my})
    count := savedPositions.Length
    ToolTip("💾 Position #" count " sauvegardée: X=" mx " Y=" my)
    SetTimer(() => ToolTip(), -2000)
}

; Recharger script (F3)
F3:: {
    Reload()
}

; Quitter script (F4)
F4:: {
    ExitApp()
}

; --- HOTKEYS DU JEU (actifs seulement dans Buckshot Roulette) ---
#HotIf WinActive("Buckshot Roulette")

q:: {
    global SHOOT_SELF_X, SHOOT_SELF_Y
    ClickAt(SHOOT_SELF_X, SHOOT_SELF_Y)
    ToolTip("💀 Tir sur SOI")
    SetTimer(() => ToolTip(), -1000)
}

e:: {
    global SHOOT_DEALER_X, SHOOT_DEALER_Y
    ClickAt(SHOOT_DEALER_X, SHOOT_DEALER_Y)
    ToolTip("🔫 Tir sur DEALER")
    SetTimer(() => ToolTip(), -1000)
}

1:: {
    global ITEM_1_X, ITEM_1_Y
    ClickAt(ITEM_1_X, ITEM_1_Y)
    ToolTip("📦 Item 1")
    SetTimer(() => ToolTip(), -800)
}

2:: {
    global ITEM_2_X, ITEM_2_Y
    ClickAt(ITEM_2_X, ITEM_2_Y)
    ToolTip("📦 Item 2")
    SetTimer(() => ToolTip(), -800)
}

3:: {
    global ITEM_3_X, ITEM_3_Y
    ClickAt(ITEM_3_X, ITEM_3_Y)
    ToolTip("📦 Item 3")
    SetTimer(() => ToolTip(), -800)
}

4:: {
    global ITEM_4_X, ITEM_4_Y
    ClickAt(ITEM_4_X, ITEM_4_Y)
    ToolTip("📦 Item 4")
    SetTimer(() => ToolTip(), -800)
}

5:: {
    global ITEM_5_X, ITEM_5_Y
    ClickAt(ITEM_5_X, ITEM_5_Y)
    ToolTip("📦 Item 5")
    SetTimer(() => ToolTip(), -800)
}

6:: {
    global ITEM_6_X, ITEM_6_Y
    ClickAt(ITEM_6_X, ITEM_6_Y)
    ToolTip("📦 Item 6")
    SetTimer(() => ToolTip(), -800)
}

7:: {
    global ITEM_7_X, ITEM_7_Y
    ClickAt(ITEM_7_X, ITEM_7_Y)
    ToolTip("📦 Item 7")
    SetTimer(() => ToolTip(), -800)
}

8:: {
    global ITEM_8_X, ITEM_8_Y
    ClickAt(ITEM_8_X, ITEM_8_Y)
    ToolTip("📦 Item 8")
    SetTimer(() => ToolTip(), -800)
}

#HotIf
