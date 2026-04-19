screen confirm_exit():
    modal True

    add Solid("#000000AA")

    frame:
        xalign 0.5
        yalign 0.5
        padding (22, 20)

        has vbox
        spacing 16

        text _("Exit the game?") size 30

        hbox:
            spacing 12
            textbutton _("Cancel") action [Function(safe_play_ui_sound), Hide("confirm_exit")]
            textbutton _("Exit") action [Function(safe_play_ui_sound), Quit(confirm=False)]

screen confirm_save_overwrite(slot_name):
    modal True

    add Solid("#000000AA")

    frame:
        xalign 0.5
        yalign 0.5
        padding (22, 20)

        has vbox
        spacing 16

        text _("Overwrite save [slot_name]?") size 30

        hbox:
            spacing 12
            textbutton _("Cancel") action [Function(safe_play_ui_sound), Hide("confirm_save_overwrite")]
            textbutton _("Overwrite") action [Function(safe_play_ui_sound), Function(force_save_to_slot, slot_name)]
