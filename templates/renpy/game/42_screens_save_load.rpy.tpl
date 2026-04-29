screen slot_pages():
    hbox:
        spacing 8
        for page_number in range(1, {{ save_pages }} + 1):
            textbutton "[page_number]" action SetVariable("current_save_page", page_number)

screen file_slot_grid(mode):
    grid 2 5:
        spacing 16

        for slot_index in range(1, {{ slots_per_page }} + 1):
            $ slot_name = save_slot_name(current_save_page, slot_index)
            $ occupied = slot_is_occupied(slot_name)
            $ slot_action = [Function(safe_play_ui_sound), Function(save_or_confirm, slot_name)] if mode == "save" else ([Function(safe_play_ui_sound), FileLoad(slot_name)] if occupied else NullAction())

            button:
                action slot_action
                has vbox
                spacing 6

                text _("Slot [slot_name]")
                text ("Occupied" if occupied else "Empty")

screen file_manager(mode):
    tag menu

    add Solid("#0F172A")

    frame:
        xalign 0.5
        yalign 0.5
        padding (28, 24)

        has vbox
        spacing 18

        text ("Save" if mode == "save" else "Load") size 36
        text _("{{ save_slot_count }} slots available via {{ save_pages }} pages") size 20

        use slot_pages
        use file_slot_grid(mode)

        imagebutton:
            idle "images/ui/back.png"
            hover "images/ui/back.png"
            action [Function(safe_play_ui_sound), Return()]

screen save():
    use file_manager("save")

screen load():
    use file_manager("load")
