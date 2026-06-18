# VirtualAntinetBox

VirtualAntinetBox 是一个“最低限度数字化”的虚拟实体卡片盒 Demo。它把桌面、卡片盒、抽屉、分隔片和扫描卡片的物理占位搬到 Godot 3D 空间中，但不理解、不索引、不整理卡片内容。

## 如何运行

1. 打开 Godot 4.6 标准版。
2. 导入或打开本目录：`D:\codex project\VirtualAntinetBox\project\virtual-antinet-box`。
3. 主场景已经设置为 `res://scenes/Main.tscn`。
4. 点击运行项目即可进入 Demo。

也可以从命令行检查：

```powershell
& 'D:\Godot\Godot_v4.6.3-stable_win64_console.exe' --path 'D:\codex project\VirtualAntinetBox\project\virtual-antinet-box'
```

## 当前 Demo 功能

- 3D 桌面，包含卡片盒区域、桌面摊开区域、新导入卡片落点区域。
- 一个几何体卡片盒，包含 3 个可开合抽屉。
- 抽屉有外壳、地板、侧壁、前挡边、把手和碰撞体。
- 默认生成 3 张测试卡片和 1 张分隔片。
- 卡片是有厚度的 3D 薄长方体，带碰撞体和正反面材质。
- 可以选择、拖拽、旋转、翻面、放到桌面、放入打开的抽屉、从抽屉取出。
- 可以导入本地图片作为新卡片正面贴图。
- 可以保存和加载世界状态，保存内容只包含物理状态与资源路径。
- 包含基础性能策略：静止卡片标记为 sleeping，当前操作卡片激活，架构预留对象池、LOD、缩略图/高清贴图分层。

## 操作摘要

- 左键点击卡片或分隔片：选中并拖拽；松开后放下。
- 左键拖动抽屉：沿固定方向开合。
- `Q` / `E`：旋转当前选中的卡片或分隔片。
- `R`：翻面。
- `O`：切换选中抽屉的开合。
- 右键拖动：旋转摄像机。
- 中键拖动：平移摄像机。
- 鼠标滚轮：缩放。
- `1` / `Home`：桌面总览。
- `2`：抽屉视角。
- `3` / `Space`：聚焦当前选中对象。
- `I` 或界面“导入”：选择本地图片生成新卡片。
- `Ctrl+S` 或 `F5` 或界面“保存”：保存状态。
- `Ctrl+L` 或 `F9` 或界面“载入”：加载状态。

## 已知限制

- 当前模型为几何体 Demo，不追求真实木纹、纸张弯曲或复杂滑轨。
- 卡片放入抽屉时使用简化吸附排列，不模拟真实纸堆细节。
- 导入只使用图片作为贴图，不做裁切、纠偏、OCR、文字识别或内容处理。
- 保存路径使用 Godot 的 `user://world_state.json`；项目内 `user_data/world_state.json` 只是结构说明占位文件。

## 原则

本项目不做 OCR、搜索、标签、自动分类、自动链接、AI 摘要、知识图谱、Markdown 笔记编辑器、云同步、账号系统或任何基于卡片文字内容的智能处理。计算机只提供虚拟物理环境。

## 协作入口

本项目已建立面向手机端协作的文档结构：

- [项目状态](docs/PROJECT_STATE.md)
- [协作流程](docs/COLLABORATION_WORKFLOW.md)
- [命令队列](docs/COMMAND_QUEUE.md)
- [测试说明](docs/TESTING.md)
- [验收标准](docs/ACCEPTANCE.md)
- [详细逐步验收](docs/validation.md)
- [移动端报告](docs/MOBILE_REPORT.md)

后续 iOS ChatGPT 应通过 GitHub 读取这些文件，并把新任务直接写入 `docs/COMMAND_QUEUE.md`。Codex 桌面端每轮按 [AGENTS.md](AGENTS.md) 执行指定 CMD 编号。
