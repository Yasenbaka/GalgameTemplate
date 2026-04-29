screen game_hud():
    if not main_menu and not ui_hidden:
        frame:
            xalign 0.5
            yalign 1.0
            padding (18, 14)

            has hbox
            spacing 10

            imagebutton:
                idle "images/ui/SAVE.png"
                hover "images/ui/SAVE.png"
                action [Function(safe_play_ui_sound), ShowMenu("save")]
            imagebutton:
                idle "images/ui/LOAD.png"
                hover "images/ui/LOAD.png"
                action [Function(safe_play_ui_sound), ShowMenu("load")]
            imagebutton:
                idle "images/ui/config.png"
                hover "images/ui/config.png"
                action [Function(safe_play_ui_sound), ShowMenu("preferences")]
            imagebutton:
                idle "images/ui/EXIT.png"
                hover "images/ui/EXIT.png"
                action [Function(safe_play_ui_sound), Show("confirm_exit")]
            imagebutton:
                idle "images/ui/history.png"
                hover "images/ui/history.png"
                action [Function(safe_play_ui_sound), ShowMenu("history_log")]

            if _preferences.afm_enable:
                imagebutton:
                    idle "images/ui/pause.png"
                    hover "images/ui/pause.png"
                    action [Function(safe_play_ui_sound), Function(toggle_auto_mode)]
            else:
                imagebutton:
                    idle "images/ui/auto.png"
                    hover "images/ui/auto.png"
                    action [Function(safe_play_ui_sound), Function(toggle_auto_mode)]
