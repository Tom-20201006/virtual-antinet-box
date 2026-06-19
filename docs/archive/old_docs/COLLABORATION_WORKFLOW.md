# Collaboration Workflow

本文档描述 VirtualAntinetBox 的长期协作流程。

## 角色分工

### iOS ChatGPT

- 读取 GitHub 仓库中的文档、代码、日志和测试结果。
- 与用户讨论下一步方向。
- 生成清晰、编号化、可执行的任务命令。
- 直接通过 GitHub 连接器写入 `docs/COMMAND_QUEUE.md`。
- 不直接运行代码，不操作 Windows 桌面。

### GitHub

- 保存项目代码。
- 保存项目文档。
- 保存命令队列。
- 保存执行日志。
- 保存测试和验收结果。
- 保存 Bug 记录。
- 保存重要决策。
- 作为唯一项目事实来源。

### UU 远程控制

- 远程进入 Windows 桌面。
- 打开 Codex 桌面端。
- 给 Codex 输入极短触发指令。
- 必要时批准 Codex 操作。
- 必要时打开 Godot 做人工验收。

UU 远程不承担长文本输入、复杂代码编辑或大量阅读任务。

### Codex 桌面端

- 在 Windows 本地项目中执行任务。
- 每轮开始前同步 GitHub 最新内容。
- 读取 `AGENTS.md`、`docs/COMMAND_QUEUE.md` 和项目状态文档。
- 每轮只执行用户指定的一个 CMD 编号命令。
- 修改代码、文档、资源或配置。
- 运行必要验证。
- 把执行结果写回仓库文档。
- commit 并 push 到 GitHub。

## 标准循环

1. 用户在 iOS ChatGPT 中讨论项目。
2. iOS ChatGPT 读取 GitHub 项目状态。
3. iOS ChatGPT 生成新 CMD 命令。
4. iOS ChatGPT 直接写入 `docs/COMMAND_QUEUE.md`。
5. 用户用 UU 远程打开 Codex 桌面端。
6. 用户给 Codex 短指令：同步 GitHub，读取命令文档，执行指定 CMD。
7. Codex 执行任务。
8. Codex 更新文档。
9. Codex commit/push。
10. 用户远程验收。
11. iOS ChatGPT 再读取 GitHub 进入下一轮。

## 命令入口

`docs/COMMAND_QUEUE.md` 是主命令入口。GitHub Issue 不是主命令入口，只作为 Bug、讨论或备用记录入口。

GitHub iOS App 只作为查看、监督、备用记录工具，不是长期手动输入命令的主要工具。
