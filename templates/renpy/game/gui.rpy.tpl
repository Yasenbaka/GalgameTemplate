define gui.accent_color = "#7DD3FC"
define gui.idle_color = "#F8FAFC"
define gui.hover_color = "#BAE6FD"
define gui.interface_text_size = 24
define gui.dialogue_text_size = 32
define gui.name_text_size = 34

style default:
    color "#F8FAFC"

style button:
    background Frame(Solid("#1E293B"), 12, 12)
    hover_background Frame(Solid("#334155"), 12, 12)
    xpadding 18
    ypadding 12
    activate_sound "audio/sfx/ui_click.wav"
    hover_sound "audio/sfx/ui_hover.wav"

style button_text:
    size gui.interface_text_size
    idle_color gui.idle_color
    hover_color gui.hover_color

style say_window:
    background Frame(Solid("#0F172ACC"), 18, 18)
    xfill True
    ysize 260

style say_dialogue:
    size gui.dialogue_text_size
    color "#F8FAFC"
    xalign 0.0

style say_label:
    size gui.name_text_size
    color gui.accent_color
