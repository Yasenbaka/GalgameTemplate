# 生成器同步记录：out/ → render.py

> 记录日期：2026-04-19  
> 同步方式：方案 A（把 `out/Phase1Demo/game/` 中的手动修改回写到 `src/galgame_template/render.py`）

---

## 背景

Phase 1 项目的 `out/` 目录是生成器的临时输出目录，默认被 `.gitignore` 排除。  
在开发过程中，为了快速验证 Ren'Py 运行效果，大量 UI 修复和体验优化直接在 `out/Phase1Demo/game/` 下的 `.rpy` 文件中进行。  
这些修改需要回写到生成器源码（`src/galgame_template/render.py`），才能保证：

1. 重新生成项目时不会丢失修复
2. 团队其他成员使用生成器时获得相同的改进
3. 修改可以被 git 跟踪和版本管理

---

## 修改总览

| `render.py` 函数 | 对应原文件 | 修改类型 | 说明 |
|------------------|-----------|---------|------|
| `_render_options()` | `options.rpy` | 新增 | 添加分辨率配置 `1920×1080` |
| `_render_gui()` | `gui.rpy` | 重写 | 添加 `gui.init()`、中文字体、对话框样式 |
| `_render_bootstrap()` | `00_bootstrap.rpy` | 增强 | 设置值绑定到 Ren'Py 全局偏好配置 |
| `_render_characters()` | `10_characters.rpy` | 注释 | 保留占位符，增加使用说明注释 |
| `_render_transforms()` | `30_transforms.rpy` | 新增 | 添加 `pos_left/center/right` 等位置 transform |
| `_render_main_menu()` | `40_screens_main_menu.rpy` | 重写 | 背景图回退、标题、中文按钮 |
| `_render_hud()` | `41_screens_hud.rpy` | 修改 | LOAD 按钮支持 `imagebutton` 图片替换 |
| `_render_save_load()` | `42_screens_save_load.rpy` | 重写 | 添加背景遮罩、面板尺寸、按钮样式、返回按钮 |
| `_render_preferences()` | `43_screens_preferences.rpy` | 重写 | 添加背景遮罩、滑块标签、数值显示、返回按钮 |
| `_render_history()` | `44_screens_history.rpy` | 重写 | 添加背景遮罩、说话者名字、空记录提示、返回按钮 |
| `_render_prologue()` | `50_script_prologue.rpy` | 修改 | 开场自动 `show screen game_hud` |

---

## 详细修改内容

### 1. `_render_options()` — 分辨率配置

**变更**：在 `config.name/version/build` 之后，新增：

```renpy
define config.screen_width = 1920
define config.screen_height = 1080
```

**原因**：原模板没有定义分辨率，Ren'Py 默认使用 `1280×720`。项目使用 `1920×1080` 素材，需要显式指定分辨率。

---

### 2. `_render_gui()` — GUI 系统初始化 + 中文字体 + 对话框样式

**变更**：

1. **添加 `gui.init(1920, 1080)`**  
   这是修复主菜单不显示的关键。Ren'Py 8.x 的 GUI 系统必须显式初始化，否则 `main_menu` screen 可能无法正确加载。

2. **全局中文字体**  
   `style default / say_label / say_dialogue / button_text / text` 全部指向 `fonts/msyh.ttc`。

3. **对话框样式（`say_window`）**  
   - 底部黑色半透明条：`Solid("#000000cc")`
   - 高度：`yminimum 220`
   - 内边距：`padding (60, 30)`

4. **角色名框（`say_namebox` / `namebox`）**  
   - 深蓝色背景：`Solid("#2a3040")`
   - 注意：`namebox` 是 Ren'Py 默认 `say` screen 内层 window 使用的样式名，必须同时定义。

5. **文字颜色**  
   - `say_who`：蓝色 `#88ccff`、加粗、26px（角色名）
   - `say_what`：白色 `#ffffff`、28px、行距 8px（对话内容）

---

### 3. `_render_bootstrap()` — 偏好配置绑定

**变更**：两个 setter 函数增加了对 Ren'Py 全局偏好的写入：

```python
def set_auto_forward_seconds(value):
    renpy.store.custom_auto_forward_seconds = float(value)
    renpy.game.preferences.afm_time = float(value)          # 新增

def set_text_seconds_per_char(value):
    ...
    renpy.game.preferences.text_cps = renpy.store.custom_text_cps  # 新增
```

**原因**：设置界面的滑块虽然能拖动并更新变量，但如果不写入 `renpy.game.preferences`，实际游戏运行时的文本速度和自动播放延迟不会生效。

---

### 4. `_render_characters()` — 占位符说明

**变更**：保留原来的 `narrator` 和 `hero` 占位符，新增注释说明如何接入真实素材：

```renpy
# Example: define your characters and map them to images in images/characters/
# define protagonist = Character("主角")
# image protagonist = "images/characters/柊春雪.png"
```

> 注意：具体的角色名和图片路径（如 `柊春雪.png`、`夏百咲.png`）属于项目特定资产，**不应硬编码到生成器中**。每个游戏项目应自行修改 `10_characters.rpy` 或生成后手动覆盖。

---

### 5. `_render_transforms()` — 人物位置预设

**新增 transform**：

| transform | xalign | yalign | 用途 |
|-----------|--------|--------|------|
| `pos_left` | 0.15 | -0.02 | 双人场景偏左 |
| `pos_center` | 0.5 | -0.02 | 正中 |
| `pos_right` | 0.85 | -0.02 | 双人场景偏右 |
| `pos_far_left` | 0.0 | -0.02 | 最左边缘 |
| `pos_far_right` | 1.0 | -0.02 | 最右边缘 |
| `scale_small` | — | 1.0 | 缩放 80% |
| `scale_large` | — | 1.0 | 缩放 120% |

> `yalign -0.02` 是为了让角色底部与屏幕底部对齐（抵消 Ren'Py 默认的轻微偏移）。

---

### 6. `_render_main_menu()` — 开始界面美化

**变更**：

1. **背景图回退机制**  
   ```renpy
   if renpy.loadable("images/ui/main_menu_bg.png"):
       add "images/ui/main_menu_bg.png"
   else:
       add Solid("#10151c")
   ```
   有背景图时显示图片，没有时回退为深黑色。

2. **游戏标题**  
   屏幕中央偏上显示大字标题（72px、白色、黑色描边）。

3. **按钮中文化**  
   Start → 开始游戏，Load → 读取存档，Settings → 游戏设置，Exit → 退出游戏。

> 注意：标题文字（`"你的游戏标题"`）是占位符，每个项目应在生成后手动修改，或通过 manifest 变量驱动。

---

### 7. `_render_hud()` — LOAD 图片按钮

**变更**：LOAD 按钮从 `textbutton` 改为 `imagebutton`：

```renpy
imagebutton:
    idle "images/ui/LOAD.png"
    hover "images/ui/LOAD.png"
    action ShowMenu("load")
```

> 如果只有一张 `LOAD.png` 而没有 `LOAD_hover.png`，`idle` 和 `hover` 指向同一张图。后续可替换为带高亮状态的素材。

---

### 8. `_render_save_load()` — 存档/读档界面修复

**原问题**：`viewport` 没有尺寸、`frame` 没有背景、按钮没有高度，导致界面完全不可见。

**修复内容**：

1. 全屏半透明黑色遮罩（`#000000cc`）
2. 居中面板（`900×700`、深色背景、圆角感）
3. 标题根据模式显示"保存游戏"或"读取游戏"
4. 存档槽按钮：`yminimum 80`、背景色、悬停高亮
5. 每行显示"存档序号 + 保存时间（或空槽位）"
6. 底部添加"返回"按钮（`Return()` action）

---

### 9. `_render_preferences()` — 设置界面修复

**修复内容**：

1. 全屏半透明黑色遮罩 + 居中面板（`700×600`）
2. 每个滑块都有中文标签：
   - 背景音乐 / 人物配音 / 界面音效
   - 自动播放 / 文字显示
3. 滑块旁实时显示数值（如 `10.0 秒`、`0.10 秒/字`）
4. "应用"按钮：同步写入 Ren'Py 全局偏好
5. "返回"按钮：关闭设置界面

---

### 10. `_render_history()` — 历史记录界面修复

**修复内容**：

1. 全屏半透明黑色遮罩 + 居中面板（`900×700`）
2. 每条记录显示**说话者名字** + 对话内容：
   - 有名字时显示为蓝色（`#88ccff`）
   - 无名字（旁白）时显示"旁白"为灰色（`#888888`）
3. 空历史时提示"暂无历史记录"
4. 添加"返回"按钮

---

### 11. `_render_prologue()` — 开场显示 HUD

**变更**：在 `label start:` 第一行添加：

```renpy
show screen game_hud
```

**原因**：`game_hud` screen 定义了但从未被 `show screen` 调用，导致底部按钮栏完全不可见。

---

## 未被纳入生成器的用户自定义内容

以下内容**不应**硬编码到 `render.py`，因为它们属于项目特定资产或剧情：

| 文件/内容 | 原因 | 维护方式 |
|-----------|------|---------|
| `51_script_chapter1.rpy` | 项目特定剧情脚本 | 生成后手动复制到 `out/<project>/game/` |
| 角色定义（主角、夏百咲） | 项目特定角色名和立绘 | 生成后修改 `10_characters.rpy` 或自行维护 |
| 图片素材（`images/`、`fonts/`） | 美术资产 | 生成后手动复制到 `out/<project>/game/` |
| 主菜单标题文字 | 每个游戏不同 | 生成后修改 `40_screens_main_menu.rpy` |

---

## 重新生成验证步骤

```powershell
# 1. 删除旧输出
Remove-Item -Recurse -Force out/Phase1Demo

# 2. 重新生成
$env:PYTHONPATH = "src"
python -m galgame_template.cli generate examples/minimal.project.toml --output-root out

# 3. 复制自定义剧情和素材（如有）
copy 51_script_chapter1.rpy out/Phase1Demo/game/
xcopy /E /I asset\images out/Phase1Demo\game\images
xcopy /E /I asset\fonts out/Phase1Demo\game\fonts

# 4. 运行测试
powershell -ExecutionPolicy Bypass -File scripts/run_with_sdk.ps1
```

---

## 后续建议

1. **模板引擎化**：当前 `render.py` 使用硬编码 Python 字符串拼接。建议改用 Jinja2 读取 `templates/renpy/game/*.tpl`，减少维护成本。
2. **资产复制钩子**：生成器目前只输出 `.rpy` 脚本。可考虑在 `generate_project()` 中添加资产复制逻辑，自动把 `asset/` 目录的内容复制到输出目录。
3. **角色配置化**：把角色定义从 `10_characters.rpy` 移到 TOML manifest 中（如 `[[characters]] name = "主角" image = "xxx.png"`），让生成器自动输出角色声明。
