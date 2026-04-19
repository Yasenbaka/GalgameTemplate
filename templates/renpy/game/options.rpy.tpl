define config.name = "{{ window_title }}"
define build.name = "{{ project_slug }}"
define config.version = "{{ project_version }}"
define config.save_directory = "{{ project_slug }}-{{ project_version }}"
define config.history_length = {{ history_length }}
define config.has_sound = True
define config.has_music = True
define config.has_voice = True
define gui.show_name = True

default quick_menu = True
