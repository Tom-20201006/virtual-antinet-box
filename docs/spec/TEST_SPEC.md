# Test Spec

## 自动检查要求

Codex 每轮应根据任务运行必要的自动检查。最低文档或结构变更检查通常包括：

- `git status -sb`
- `git diff --stat`
- 任务指定的文件清单检查
- Godot headless 加载检查

Godot headless 示例：

```powershell
& 'D:\Godot\Godot_v4.6.3-stable_win64_console.exe' --headless --path 'D:\codex project\VirtualAntinetBox\project\virtual-antinet-box' --quit-after 1
```

## 人工验收要求

当前项目是 3D 交互 Demo，拖拽、视角、抽屉开合、卡片翻面、图片导入、保存加载等体验必须由用户人工验收。

详细逐步验收附录仍为：

- `docs/validation.md`

后续新增或修改验收步骤，必须按 `docs/validation.md` 的标准写明前置条件、逐步操作和可观察通过标准。

## 自动检查和人工验收的区别

- Codex 自动检查只能证明项目可加载、文件结构符合预期或脚本没有明显解析错误。
- 用户人工验收才能确认 3D 操作手感、视角、拖拽、抽屉和卡片交互是否符合预期。
- 不得把 Godot headless 通过写成用户人工验收通过。

## Bug 记录入口

正式 Bug 记录入口：

- `docs/history/BUG_LOG.md`

旧入口 `docs/BUG_REPORT.md` 已作为兼容文档保留，原文已归档。

## 当前验收事实

- 2026-06-18 用户通过 UU 远程完成首版 Demo 人工验收。
- 用户反馈一切正常。
- 当前暂无用户报告的运行 Bug。
