define bg_fade = Dissolve(0.4)

define bg_dissolve = Dissolve(0.25)

transform char_move_in_left:
    xalign -0.2
    yalign 1.0
    linear 0.4 xalign 0.25

transform char_move_in_right:
    xalign 1.2
    yalign 1.0
    linear 0.4 xalign 0.75

transform char_shake:
    linear 0.05 xoffset -12
    linear 0.05 xoffset 12
    linear 0.05 xoffset -8
    linear 0.05 xoffset 8
    linear 0.05 xoffset 0

transform char_zoom_pulse:
    zoom 1.0
    linear 0.2 zoom 1.06
    linear 0.2 zoom 1.0

transform char_bob:
    yoffset 0
    linear 0.3 yoffset -10
    linear 0.3 yoffset 0
    repeat
