# VirtualAntinetBox

VirtualAntinetBox 是一个“最低限度数字化”的虚拟实体卡片盒 Demo。它把桌面、卡片盒、抽屉、分隔片和扫描卡片的物理占位搬到 Godot 3D 空间中，但不理解、不索引、不整理卡片内容。

## 如何运行

1. 打开 Godot 4.6 标准版。
2. 打开项目目录：`D:\codex project\VirtualAntinetBox\project\virtual-antinet-box`。
3. 主场景为 `res://scenes/Main.tscn`。
4. 点击运行项目进入 Demo。

命令行预检查：

```powershell
& 'D:\Godot\Godot_v4.6.3-stable_win64_console.exe' --headless --path 'D:\codex project\VirtualAntinetBox\project\virtual-antinet-box' --quit-after 1
```

## 当前 Demo 能做什么

- 显示 3D 桌面、卡片盒区域、桌面摊开区域和导入落点区域。
- 显示一个几何体卡片盒，包含 3 个可开合抽屉。
- 默认生成测试卡片和分隔片。
- 支持卡片或分隔片的选择、拖拽、旋转、翻面、放入抽屉和从抽屉取出。
- 支持导入本地图片作为新卡片正面贴图。
- 支持保存和加载世界状态，保存边界只包含物理状态与资源路径。
- 预留大量卡片性能策略：对象池、LOD、缩略图/高清贴图分层和静止对象冻结。

## 项目原则

计算机只模拟物理卡片盒，不替用户思考。本项目不做 OCR、搜索、标签、自动分类、自动链接、AI 摘要、知识图谱、Markdown 笔记编辑器、云同步、账号系统或任何基于卡片文字内容的智能处理。

## 新文档入口

长期协作入口已收敛为分层结构：

- [当前状态](docs/00_STATUS.md)
- [命令入口](docs/01_COMMANDS.md)
- [当前任务上下文](docs/02_CURRENT_TASK_CONTEXT.md)
- [产品规格](docs/spec/PRODUCT_SPEC.md)
- [交互规格](docs/spec/INTERACTION_SPEC.md)
- [物理组件规格](docs/spec/PHYSICAL_MODEL_SPEC.md)
- [存储策略规格](docs/spec/STORAGE_SPEC.md)
- [测试与验收规格](docs/spec/TEST_SPEC.md)
- [Antinet 工作流观察模板](docs/research/ANTINET_WORKFLOW_OBSERVATIONS.md)
- [正式历史](docs/history/HISTORY.md)
- [决策记录](docs/history/DECISIONS.md)
- [执行日志](docs/history/EXECUTION_LOG.md)
- [人工验收记录](docs/history/ACCEPTANCE_LOG.md)
- [Bug 记录](docs/history/BUG_LOG.md)
- [冷归档](docs/archive/README.md)

`docs/COMMAND_QUEUE.md` 保留为旧入口兼容跳转。后续 iOS ChatGPT 应写入 `docs/01_COMMANDS.md`，Codex 桌面端每轮按 [AGENTS.md](AGENTS.md) 执行指定 CMD 编号。
