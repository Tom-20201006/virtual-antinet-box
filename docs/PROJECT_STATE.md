# Project State

最近更新时间：2026-06-18 19:49 +08:00

## 项目名称

VirtualAntinetBox，中文暂名：虚拟实体卡片盒。

## 项目目标

建立一个“最低限度数字化”的虚拟实体卡片盒。计算机只模拟桌面、卡片盒、抽屉、分隔片、卡片、位置、碰撞、拿取、放置、翻面、旋转、插入、抽出和状态保存，不理解卡片内容。

## 当前阶段

功能性 Godot Demo 已完成首版；本轮正在建立长期远程协作结构。

## 当前技术栈

- Godot 4.6。
- GDScript。
- Godot 内置几何体。
- 本地 JSON 状态保存。
- Git/GitHub 作为协作和状态同步目标。

## 当前主要目录结构

- `project.godot`：Godot 项目配置。
- `scenes/`：主场景和组件场景骨架。
- `scripts/`：交互、卡片、抽屉、保存、导入等 GDScript。
- `docs/`：项目文档、协作流程、命令队列、状态、测试和验收。
- `assets/`：示例卡片、贴图、模型预留目录。
- `user_data/`：项目内运行数据结构说明；实际运行保存使用 Godot `user://`。

## 当前可运行入口

主场景：`res://scenes/Main.tscn`

Windows Godot 可执行文件：

```powershell
& 'D:\Godot\Godot_v4.6.3-stable_win64_console.exe' --path 'D:\codex project\VirtualAntinetBox\project\virtual-antinet-box'
```

## 已完成内容

- 3D 桌面。
- 卡片盒区域、桌面摊开区域、导入落点区域。
- 一个卡片盒。
- 至少 3 个抽屉。
- 抽屉开合。
- 默认测试卡片。
- 分隔片。
- 卡片选择、拖拽、旋转、翻面。
- 卡片放桌面、放入抽屉、从抽屉取出。
- 本地图片导入为卡片正面贴图。
- JSON 世界状态保存和加载。
- 基础大量卡片优化策略。
- 详细逐步验收文档 `docs/validation.md`。
- 协作结构文档。

## 未完成内容

- 背面图片的独立导入 UI。
- 大规模对象池的生产级实现。
- 缩略图和高清贴图分层缓存。
- 更精细模型和材质替换。
- 远程 GitHub 仓库创建与 push。

## 当前主要问题

- GitHub App 已能看到账号 `Tom-20201006`。
- GitHub App 当前可访问仓库列表为空。
- 当前工具集中没有“创建新仓库”的 GitHub 插件接口。
- 本机未检测到 GitHub CLI `gh`。
- 已设置 remote 为 `https://github.com/Tom-20201006/virtual-antinet-box.git`。
- push 失败，GitHub 返回 `Repository not found`。

## 最近一次有效状态

Godot 主场景曾通过命令行 headless 加载和 1 秒运行验证。后续功能修改仍需按 `docs/validation.md` 做人工验收。

## 下一步方向

1. 用户手动创建空仓库 `Tom-20201006/virtual-antinet-box`，或安装并登录 GitHub CLI。
2. Codex 重新执行 push。
3. iOS ChatGPT 后续通过 GitHub 读取 `docs/COMMAND_QUEUE.md` 并写入新任务。
