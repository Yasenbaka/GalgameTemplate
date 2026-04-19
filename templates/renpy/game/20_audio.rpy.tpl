define audio.ui_click = "audio/sfx/ui_click.wav"
define audio.ui_hover = "audio/sfx/ui_hover.wav"

init python:
    def safe_play(channel, filename, loop=False, fadein=0.0):
        if filename and renpy.loadable(filename):
            renpy.music.play(filename, channel=channel, loop=loop, fadein=fadein)

    def safe_play_music(filename, fadein=0.0):
        safe_play("music", filename, loop=True, fadein=fadein)

    def safe_stop_music(fadeout=0.0):
        renpy.music.stop(channel="music", fadeout=fadeout)

    def safe_play_voice(filename):
        safe_play("voice", filename, loop=False)

    def stop_voice():
        renpy.music.stop(channel="voice")

    def safe_play_ui_sound(filename=audio.ui_click):
        safe_play("sound", filename, loop=False)
