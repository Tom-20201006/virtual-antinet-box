# Testing

本文档记录 VirtualAntinetBox 的测试流程。详细逐步验收见 `docs/validation.md`，后续新增验收步骤必须按该文档的标准编写。

## 打开项目

1. 打开 Godot 4.6 标准版。
2. 打开项目目录：`D:\codex project\VirtualAntinetBox\project\virtual-antinet-box`。
3. 确认主场景为 `res://scenes/Main.tscn`。

## 运行主场景

在 Godot 编辑器中点击运行，或使用命令：

```powershell
& 'D:\Godot\Godot_v4.6.3-stable_win64_console.exe' --path 'D:\codex project\VirtualAntinetBox\project\virtual-antinet-box'
```

## 基础命令行检查

```powershell
& 'D:\Godot\Godot_v4.6.3-stable_win64_console.exe' --headless --path 'D:\codex project\VirtualAntinetBox\project\virtual-antinet-box' --quit-after 1
```

通过标准：

- Godot 能加载项目。
- 主场景初始化没有脚本解析错误。

## 核心交互测试

按 `docs/validation.md` 执行以下验收项：

- `VAB-VAL-002` 运行主场景。
- `VAB-VAL-003` 验证桌面与区域。
- `VAB-VAL-004` 验证卡片盒与抽屉建模。
- `VAB-VAL-005` 验证抽屉开合。
- `VAB-VAL-006` 验证默认卡片。
- `VAB-VAL-007` 验证卡片拿起和移动。
- `VAB-VAL-008` 验证旋转和翻面。
- `VAB-VAL-009` 验证卡片放入抽屉。
- `VAB-VAL-010` 验证从抽屉取出卡片。
- `VAB-VAL-011` 验证分隔片。
- `VAB-VAL-012` 验证本地图片导入。
- `VAB-VAL-013` 验证保存世界状态。
- `VAB-VAL-014` 验证加载世界状态。

## Godot Output / Debugger 检查点

- 没有 GDScript parse error。
- 没有主场景 `_ready()` 初始化错误。
- 导入图片失败时应只显示资源或格式问题，不应出现 OCR 或内容识别流程。

## 人工验收

当前项目是 3D 交互 Demo，拖拽、视角、抽屉开合、卡片翻面等需要人工验收。远程验收时应优先使用 `docs/validation.md` 的逐步流程。
