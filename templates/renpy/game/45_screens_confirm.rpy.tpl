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
            imagebutton:
                idle "images/ui/cancel.png"
                hover "images/ui/cancel.png"
                action [Function(safe_play_ui_sound), Hide("confirm_exit")]
            imagebutton:
                idle "images/ui/confirm.png"
                hover "images/ui/confirm.png"
                action [Function(safe_play_ui_sound), Quit(confirm=False)]

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
            imagebutton:
                idle "images/ui/cancel.png"
                hover "images/ui/cancel.png"
                action [Function(safe_play_ui_sound), Hide("confirm_save_overwrite")]
            imagebutton:
                idle "images/ui/overwrite.png"
                hover "images/ui/overwrite.png"
                action [Function(safe_play_ui_sound), Function(force_save_to_slot, slot_name)]
