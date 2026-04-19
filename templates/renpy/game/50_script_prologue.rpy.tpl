label start:
    call apply_default_preferences

    scene bg demo_room with bg_fade
    $ safe_play_music("audio/music/demo_bgm.mp3", fadein=1.0)

    show char hero default at char_move_in_left
    hero "欢迎来到 {{ window_title }} 的 phase 1 演示。"

    $ safe_play_voice("audio/voice/hero_001.wav")
    hero "这一句用于验证逐字显示、左键补完当前句子，以及语音钩子的接入方式。"
    $ stop_voice()

    show char friend default at char_move_in_right
    friend "右下角提供 SAVE、LOAD、CONFIG、EXIT；右上角提供 History 和 Auto。"
    hide char friend default

    show char hero default at char_bob
    hero "现在切到另一个背景，并触发一个简单的角色动效。"

    scene bg evening with bg_dissolve
    show char hero default at char_zoom_pulse
    hero "等你们接入正式素材之后，这里就能替换成真实的背景图、立绘和配音。"

    menu:
        "继续查看系统说明":
            jump system_demo
        "结束示例":
            jump end_demo

label system_demo:
    hero "请手动测试：存档、读档、设置、历史记录、自动播放，以及右键隐藏 UI。"
    hero "模板已经创建了音频目录，支持 .mp3 和 .wav 的组织方式。"
    $ safe_stop_music(fadeout=1.0)
    jump end_demo

label end_demo:
    hero "Phase 1 示例到这里结束。"
    return
