# Template Contract

## 输入

Phase 1 使用一个 TOML 文件驱动项目生成。

示例：

```toml
[project]
name = "Phase1Demo"
version = "0.1.0"
window_title = "Phase 1 Demo"

[ui]
save_pages = 5
slots_per_page = 10
default_auto_forward_seconds = 10.0
default_seconds_per_char = 0.1
history_length = 250
```

## 输出

生成器输出一个标准 Ren'Py 风格项目目录：

```text
out/<project_name>/
├─ game/
│  ├─ options.rpy
│  ├─ gui.rpy
│  ├─ 00_bootstrap.rpy
│  ├─ 10_characters.rpy
│  ├─ 20_audio.rpy
│  ├─ 30_transforms.rpy
│  ├─ 40_screens_main_menu.rpy
│  ├─ 41_screens_hud.rpy
│  ├─ 42_screens_save_load.rpy
│  ├─ 43_screens_preferences.rpy
│  ├─ 44_screens_history.rpy
│  ├─ 45_screens_confirm.rpy
│  ├─ 50_script_prologue.rpy
│  ├─ images/
│  │  ├─ backgrounds/
│  │  └─ characters/
│  └─ audio/
│     ├─ music/
│     ├─ sfx/
│     └─ voice/
```

## 保证项

- 默认输出目录为 `out/<project_name>/`
- 生成器不依赖本地 Ren'Py SDK 才能执行
- 模板文件使用可替换占位符并保持确定性输出
- 运行时语义以 `docs/项目程序需求.txt` 为源头

## 暂不保证

- Phase 1 不保证提供真正可视化编辑体验
- Phase 1 不保证所有高级自定义转场已经针对指定 SDK 调优完毕
- Phase 1 只提供占位资源策略，不内置正式美术与音频资源
