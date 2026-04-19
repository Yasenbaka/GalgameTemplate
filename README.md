# GalgameTemplate

GalgameTemplate 是一个面向小团队创作的 **Ren'Py-first galgame 模板/生成器** 仓库。

它会把一个小型 TOML 清单转换成标准化的 Ren'Py 风格项目树，默认输出到 `out/<project_name>/`。当前 phase 1 的目标不是做 GUI 编辑器，也不是重写视觉小说引擎，而是把 `docs/项目程序需求.txt` 中的主要运行时体验固化为可复用模板与脚手架。

## Phase 1 已包含的内容

- Python 3.11+ 生成器包：`src/galgame_template/`
- TOML manifest 读取与校验
- Ren'Py 运行时模板文件：`templates/renpy/game/`
- 主菜单、HUD、存档/读档、设置、历史记录、确认弹窗、示例剧情的 `.rpy` 输出
- 占位资源目录与音频调用约定
- PowerShell 生成 / lint / Windows 构建辅助脚本
- 静态契约测试与生成结果测试

## 当前不做的内容

- GUI 编辑器
- 自研 VN 运行时
- 把 Ren'Py SDK 直接 vendoring 到仓库中
- 正式美术、配音、图标资源

## 快速开始

### 1. 运行测试

```powershell
python -m unittest discover -s tests -v
```

### 2. 生成一个示例项目

```powershell
$env:PYTHONPATH = "src"
python -m galgame_template.cli generate examples/minimal.project.toml --output-root out
```

默认输出位置：

```text
out/Phase1Demo/
```

### 3. 使用脚本封装

```powershell
powershell -ExecutionPolicy Bypass -File scripts/generate.ps1 -ManifestPath examples/minimal.project.toml -OutputRoot out
```

### 4. 一键启动本地预览

最省事的方式不是每次手动设置环境变量，而是在仓库根目录创建一个本地配置文件：

```text
renpy-sdk-path.txt
```

这个文件是**本地私有配置**，已经被 `.gitignore` 忽略，**不应该提交到仓库**。

你可以直接复制仓库里的模板文件：

```text
renpy-sdk-path.example.txt
```

然后改名为 `renpy-sdk-path.txt`，里面只保留一行你自己机器上的 SDK 路径，例如：

```text
D:\path\to\renpy-8.5.2-sdk
```

如果你更习惯环境变量，也可以继续使用：

```powershell
$env:RENPY_SDK_PATH = "D:\path\to\renpy-8.5.2-sdk"
```

然后直接运行：

```powershell
powershell -ExecutionPolicy Bypass -File scripts/run_with_sdk.ps1
```

如果你想要**真正双击就启动**，现在可以直接双击仓库根目录里的：

```text
双击启动预览.bat
```

这个批处理会调用 `scripts/run_with_sdk.ps1`，并且在失败时把窗口停住，不会一闪而过。

完整启动链路是：

1. 双击 `双击启动预览.bat`
2. 它调用 `scripts/run_with_sdk.ps1`
3. `scripts/run_with_sdk.ps1` 先解析 Ren'Py SDK 路径
4. 如果 `out/Phase1Demo` 不存在，就自动调用 `scripts/generate.ps1` 生成示例项目
5. 最后启动 Ren'Py 预览窗口

这个脚本的默认行为是：

- 如果 `out/Phase1Demo` 不存在，会先自动生成示例项目。
- 如果 `out/Phase1Demo` 已经存在，会直接启动，不会默认覆盖它。
- 如果你传入一个自定义 `-ProjectPath`，而那个目录不存在，脚本会直接报错，避免替你误生成错误项目。

为了让“双击启动”更省事，`scripts/run_with_sdk.ps1` 会按下面顺序寻找 Ren'Py SDK：

1. `RENPY_SDK_PATH` 环境变量
2. 仓库根目录下的 `renpy-sdk-path.txt`
3. 常见目录自动扫描，例如 `D:\RenPy`、`C:\RenPy`、`Downloads`

推荐协作者都使用 `renpy-sdk-path.txt` 这条路径，因为它最适合“克隆仓库后直接本地运行”的场景。

如果你不想每次手动设置环境变量，可以：

1. 把仓库根目录里的 `renpy-sdk-path.example.txt` 复制一份
2. 改名为 `renpy-sdk-path.txt`
3. 把里面的路径改成你自己的 Ren'Py SDK 路径

这样以后直接双击 `双击启动预览.bat` 就可以了。

## 示例输出结构

```text
out/Phase1Demo/
└── game/
    ├── options.rpy
    ├── gui.rpy
    ├── 00_bootstrap.rpy
    ├── 10_characters.rpy
    ├── 20_audio.rpy
    ├── 30_transforms.rpy
    ├── 40_screens_main_menu.rpy
    ├── 41_screens_hud.rpy
    ├── 42_screens_save_load.rpy
    ├── 43_screens_preferences.rpy
    ├── 44_screens_history.rpy
    ├── 45_screens_confirm.rpy
    ├── 50_script_prologue.rpy
    ├── audio/
    │   ├── music/.gitkeep
    │   ├── sfx/.gitkeep
    │   └── voice/.gitkeep
    └── images/
        ├── backgrounds/.gitkeep
        └── characters/.gitkeep
```

## Manifest 结构

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

## Ren'Py SDK 说明

本仓库自身不依赖本机已安装的 Ren'Py SDK 就能完成生成与测试，但真正的 lint 与 Windows 构建需要本地 SDK。

本地预览脚本 `scripts/run_with_sdk.ps1` 支持两种 SDK 配置方式：

1. `RENPY_SDK_PATH` 环境变量
2. 仓库根目录的 `renpy-sdk-path.txt`

推荐协作者使用 `renpy-sdk-path.txt`，因为它是本地文件、已被 `.gitignore` 忽略，而且适合直接配合 `双击启动预览.bat` 使用。

环境变量示例：

```powershell
$env:RENPY_SDK_PATH = "D:\path\to\renpy-8.5.2-sdk"
```

然后执行：

```powershell
powershell -ExecutionPolicy Bypass -File scripts/run_with_sdk.ps1
powershell -ExecutionPolicy Bypass -File scripts/lint_with_sdk.ps1 -ProjectPath out/Phase1Demo
powershell -ExecutionPolicy Bypass -File scripts/build_windows.ps1 -ProjectPath out/Phase1Demo
```

注意：

- `scripts/run_with_sdk.ps1` 会优先尝试 `renpy-sdk-path.txt`，所以适合双击预览。
- `scripts/lint_with_sdk.ps1` 和 `scripts/build_windows.ps1` 目前仍然依赖 `RENPY_SDK_PATH` 环境变量。
- 这三个脚本都会检查 `renpy.py` 与 SDK 自带 Python 是否存在；如果缺失，会给出明确报错。

## 仓库内主要文档

- `docs/phase-1-scope.md`：phase 1 边界
- `docs/template-contract.md`：输入 / 输出契约
- `docs/vertical-slice.md`：最小垂直切片说明
