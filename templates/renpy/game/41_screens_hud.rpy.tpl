screen say(who, what):
    style_prefix "say"

    key "mouseup_3" action Function(toggle_interface)

    if not ui_hidden:
        window:
            id "window"
            style "say_window"
            xfill True
            yalign 1.0
            padding (28, 24)

            has vbox
            spacing 12

            if who is not None:
                text who id "who" style "say_label"

            text what id "what" style "say_dialogue" slow_cps custom_text_cps

screen game_hud():
    if not main_menu and not ui_hidden:
        frame:
            xalign 0.5
            yalign 0.965
            padding (18, 14)

            has hbox
            spacing 10

            textbutton _("SAVE") action [Function(safe_play_ui_sound), ShowMenu("save")]
            textbutton _("LOAD") action [Function(safe_play_ui_sound), ShowMenu("load")]
            textbutton _("CONFIG") action [Function(safe_play_ui_sound), ShowMenu("preferences")]
            textbutton _("EXIT") action [Function(safe_play_ui_sound), Show("confirm_exit")]

        frame:
            xalign 0.985
            yalign 0.04
            padding (14, 10)

            has hbox
            spacing 10

            textbutton _("History") action [Function(safe_play_ui_sound), ShowMenu("history_log")]

            if _preferences.afm_enable:
                textbutton _("Pause") action [Function(safe_play_ui_sound), Function(toggle_auto_mode)]
            else:
                textbutton _("Auto") action [Function(safe_play_ui_sound), Function(toggle_auto_mode)]
