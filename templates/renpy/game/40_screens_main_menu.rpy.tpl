screen main_menu():
    tag menu

    if renpy.loadable("images/ui/main_menu_bg.png"):
        add "images/ui/main_menu_bg.png"
    else:
        add Solid("#020617")

    frame:
        xalign 0.5
        yalign 0.5
        padding (36, 30)

        has vbox
        spacing 16

        text "{{ window_title }}" size 46 color "#F8FAFC"
        text "Phase 1 Ren'Py template vertical slice" size 22 color "#CBD5E1"

        imagebutton:
            idle "images/ui/start_game.png"
            hover "images/ui/start_game.png"
            action [Function(safe_play_ui_sound), Start()]
        imagebutton:
            idle "images/ui/load_game.png"
            hover "images/ui/load_game.png"
            action [Function(safe_play_ui_sound), ShowMenu("load")]
        imagebutton:
            idle "images/ui/settings.png"
            hover "images/ui/settings.png"
            action [Function(safe_play_ui_sound), ShowMenu("preferences")]
        imagebutton:
            idle "images/ui/exit_game.png"
            hover "images/ui/exit_game.png"
            action [Function(safe_play_ui_sound), Show("confirm_exit")]
