screen main_menu():
    tag menu

    add Solid("#020617")

    frame:
        xalign 0.5
        yalign 0.5
        padding (36, 30)

        has vbox
        spacing 16

        text "{{ window_title }}" size 46 color "#F8FAFC"
        text "Phase 1 Ren'Py template vertical slice" size 22 color "#CBD5E1"

        textbutton _("Start") action [Function(safe_play_ui_sound), Start()]
        textbutton _("Load") action [Function(safe_play_ui_sound), ShowMenu("load")]
        textbutton _("Settings") action [Function(safe_play_ui_sound), ShowMenu("preferences")]
        textbutton _("Exit") action [Function(safe_play_ui_sound), Show("confirm_exit")]
