# Phase 1 Scope

## 定位

Phase 1 的交付物是一个 **Ren'Py-first 的模板/脚手架**，用于快速产出符合团队约定的视觉小说项目。

这不是一个 GUI 编辑器，也不是自研视觉小说引擎。

## 目标

1. 把 `docs/项目程序需求.txt` 中的核心运行时要求映射为模板约束。
2. 输出标准 Ren'Py 项目结构，便于后续直接在 Ren'Py SDK 中运行、lint 和打包。
3. 用一个轻量 Python CLI 根据清单文件生成项目骨架。
4. 提供一个带占位资源与示例剧情的最小垂直切片。

## In Scope

- Python 生成器 CLI
- TOML manifest 输入
- Ren'Py 项目模板文件
- 菜单、HUD、配置、存档/读档、历史记录、自动播放的 screen 骨架
- 文本速度 / 自动播放速度 / 音量的配置钩子
- 角色入场、抖动、缩放、轻微上下浮动等动画预设
- 背景淡入淡出等转场预设
- SDK-aware lint / build 脚本

## Out of Scope

- GUI 编辑器
- 云端协作
- 数据库 / 后端
- 自研渲染引擎
- 把 Ren'Py 源码直接并入仓库
- 真正的美术、配音、图标资产制作

## 交付标准

Phase 1 完成时，本仓库应至少能够：

1. 通过一个 manifest 生成标准化项目树。
2. 生成的项目中包含符合需求文档的主要 screen 与示例脚本文件。
3. 在没有 Ren'Py SDK 的情况下完成静态测试。
4. 在有 Ren'Py SDK 的情况下可走 lint / Windows 打包流程。
