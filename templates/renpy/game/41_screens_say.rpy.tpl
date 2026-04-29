screen say(who, what):
    style_prefix "say"

    key "mouseup_3" action Function(toggle_interface)

    if not ui_hidden:
        window:
            id "window"
            style "say_window"

            has vbox
            spacing 12

            if who is not None:
                window:
                    id "namebox"
                    style "namebox"
                    text who id "who" style "say_label"

            text what id "what" style "say_dialogue" slow_cps custom_text_cps
