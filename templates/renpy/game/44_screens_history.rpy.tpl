screen history_log():
    tag menu

    add Solid("#020617")

    frame:
        xalign 0.5
        yalign 0.5
        padding (24, 22)
        xsize 1200
        ysize 700

        has vbox
        spacing 18

        text _("History") size 36

        viewport:
            mousewheel True
            draggable True
            scrollbars "vertical"

            vbox:
                spacing 12

                for entry in _history_list:
                    if entry.what:
                        $ speaker = entry.who if entry.who else "Narrator"
                        text "[speaker]: [entry.what]"

        textbutton _("Back") action [Function(safe_play_ui_sound), Return()]
