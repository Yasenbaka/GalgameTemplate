screen preferences():
    tag menu

    add Solid("#111827")

    frame:
        xalign 0.5
        yalign 0.5
        padding (28, 24)

        has vbox
        spacing 18

        text _("Settings") size 36

        text _("Volume") size 26
        hbox:
            spacing 16
            text _("BGM")
            bar value Preference("music volume")
        hbox:
            spacing 16
            text _("Voice")
            bar value Preference("voice volume")
        hbox:
            spacing 16
            text _("UI SFX")
            bar value Preference("sound volume")

        text _("Timing") size 26
        hbox:
            spacing 16
            text _("Autoplay (sec)")
            bar value VariableValue("custom_auto_forward_seconds", 20.0, offset=0.5, step=0.5)
            text "[custom_auto_forward_seconds:.1f]"

        hbox:
            spacing 16
            text _("Text (sec/char)")
            bar value VariableValue("custom_seconds_per_char", 1.0, offset=0.01, step=0.01)
            text "[custom_seconds_per_char:.2f]"

        hbox:
            spacing 12
            xalign 0.5
            imagebutton:
                idle "images/ui/apply.png"
                hover "images/ui/apply.png"
                action [
                    Function(safe_play_ui_sound),
                    Function(set_auto_forward_seconds, custom_auto_forward_seconds),
                    Function(set_text_seconds_per_char, custom_seconds_per_char),
                ]
            imagebutton:
                idle "images/ui/back.png"
                hover "images/ui/back.png"
                action [Function(safe_play_ui_sound), Return()]
