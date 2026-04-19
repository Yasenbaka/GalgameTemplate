default ui_hidden = False
default current_save_page = 1
default custom_auto_forward_seconds = {{ default_auto_forward_seconds }}
default custom_seconds_per_char = {{ default_seconds_per_char }}
default custom_text_cps = {{ default_text_cps }}

init python:
    if "game_hud" not in config.overlay_screens:
        config.overlay_screens.append("game_hud")

    if "game_menu" in config.keymap and "mouseup_3" in config.keymap["game_menu"]:
        config.keymap["game_menu"].remove("mouseup_3")

    def toggle_interface():
        store.ui_hidden = not store.ui_hidden
        renpy.restart_interaction()

    def set_auto_forward_seconds(value):
        value = max(0.5, float(value))
        store.custom_auto_forward_seconds = value
        if hasattr(store, "_preferences"):
            store._preferences.afm_time = value
        renpy.restart_interaction()

    def set_text_seconds_per_char(value):
        value = max(0.01, float(value))
        store.custom_seconds_per_char = value
        store.custom_text_cps = max(1, int(round(1.0 / value)))
        if hasattr(store, "_preferences"):
            store._preferences.text_cps = store.custom_text_cps
        renpy.restart_interaction()

    def save_slot_name(page, slot_index):
        return f"{page}-{slot_index}"

    def slot_is_occupied(slot_name):
        try:
            return renpy.slot_json(slot_name) is not None
        except Exception as error:
            renpy.notify(f"Save inspection failed: {error}")
            return False

    def force_save_to_slot(slot_name):
        renpy.save(slot_name)
        renpy.hide_screen("confirm_save_overwrite")
        renpy.restart_interaction()

    def save_or_confirm(slot_name):
        if slot_is_occupied(slot_name):
            renpy.show_screen("confirm_save_overwrite", slot_name=slot_name)
        else:
            renpy.save(slot_name)

    def toggle_auto_mode():
        if hasattr(store, "_preferences"):
            store._preferences.afm_enable = not store._preferences.afm_enable
        renpy.restart_interaction()

label apply_default_preferences:
    $ set_auto_forward_seconds(custom_auto_forward_seconds)
    $ set_text_seconds_per_char(custom_seconds_per_char)
    return

label before_main_menu:
    call apply_default_preferences
    return
