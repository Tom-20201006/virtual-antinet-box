# AGENTS.md

本文件是 VirtualAntinetBox 仓库的 Codex 协作主规范。若存在 `AGENT.md`，也只能作为兼容入口；主规范始终以 `AGENTS.md` 为准。

## 协作原则

GitHub 仓库是项目唯一事实来源。Codex 桌面端不能把聊天窗口当作唯一交付结果，所有重要状态必须写入仓库文档。

iOS ChatGPT 负责与用户讨论、读取 GitHub 最新文档、生成编号化命令，并直接写入 `docs/COMMAND_QUEUE.md`。Codex 桌面端负责在 Windows 本地执行用户指定的一个 CMD 编号命令。

## 每轮开始前必须执行

1. 确认当前目录是仓库根目录。
2. 执行 `git status -sb`，检查工作区是否有未提交修改。
3. 执行 `git branch --show-current`，确认当前分支。
4. 执行 `git remote -v`，确认是否连接 GitHub remote。
5. 如果已有 remote，先同步最新内容；若 pull 冲突，停止并记录 `BLOCKED`，不得强行覆盖。
6. 读取本文件 `AGENTS.md`。
7. 读取 `docs/COMMAND_QUEUE.md`。
8. 读取 `docs/PROJECT_STATE.md`。
9. 读取 `docs/MOBILE_REPORT.md`。
10. 读取 `docs/EXECUTION_LOG.md` 最近记录。
11. 按任务需要读取 `docs/BUG_REPORT.md`、`docs/TESTING.md`、`docs/ACCEPTANCE.md`、`docs/NEXT_REVIEW.md`。
12. 确认本轮只执行用户指定的一个 CMD 编号命令。

## 执行任务时必须遵守

1. 不自行选择其他命令。
2. 不自行扩大任务范围。
3. 不跳过命令中的禁止修改范围。
4. 不把未验证的结果写成已完成。
5. 如果命令与当前项目状态冲突，应停止并记录 `BLOCKED`。
6. 修改代码前必须先理解相关文件。
7. 修改文档前必须保留已有有效信息。
8. 对 Godot 项目，涉及功能或交互变化时必须同步更新测试说明和验收说明。
9. 验收步骤必须按 `docs/validation.md` 的详细逐步标准编写。
10. 不引入 OCR、搜索、标签、自动分类、自动链接、AI 摘要、知识图谱等违背项目原则的功能。

## 执行完成后必须更新

默认每轮完成后至少更新：

- `docs/MOBILE_REPORT.md`
- `docs/EXECUTION_LOG.md`
- `docs/PROJECT_STATE.md`
- `docs/COMMAND_QUEUE.md`

视任务情况还应更新：

- `docs/BUG_REPORT.md`
- `docs/TESTING.md`
- `docs/ACCEPTANCE.md`
- `docs/DECISION_LOG.md`
- `docs/NEXT_REVIEW.md`
- `README.md`

## 执行完成后必须记录

每轮记录至少包含：

- 本轮执行的 CMD 编号。
- 命令状态：`DONE`、`BLOCKED`、`FAILED`、`CANCELLED`。
- 修改了哪些文件。
- 运行了哪些命令或测试。
- 测试结果。
- 未解决问题。
- 需要用户人工验收的内容。
- 下一步建议。
- 是否已经 commit。
- 是否已经 push。
- 如果 push 失败，失败原因是什么。

## Git 提交与推送规则

1. 每轮执行完成后，除非命令明确禁止，否则必须 commit。
2. commit message 应包含 CMD 编号；协作结构初始化可使用描述性初始化消息。
3. commit 前必须检查 `git diff` 或 `git status`。
4. push 前必须确认没有提交临时文件、无关大文件或敏感信息。
5. push 成功后必须在 `docs/MOBILE_REPORT.md` 写明最新 commit 和远程仓库地址。
6. 如果无法 push，必须把失败原因写入 `docs/MOBILE_REPORT.md` 和 `docs/EXECUTION_LOG.md`。

## 与 iOS ChatGPT 的衔接

1. iOS ChatGPT 会通过 GitHub 读取项目状态。
2. iOS ChatGPT 可能直接写入 `docs/COMMAND_QUEUE.md`。
3. Codex 每轮执行前必须同步 GitHub 并读取最新命令文档。
4. Codex 执行期间如果发现命令文档被其他提交更新，应重新确认本轮命令状态。
5. Codex 不应依赖当前聊天窗口保存结果，所有重要结论必须写入仓库文件。

## 后续 UU 远程触发模板

请先同步 GitHub 最新内容，然后读取 `AGENTS.md` 和 `docs/COMMAND_QUEUE.md`，执行 `CMD-YYYY-MM-DD-001`。只执行该编号命令，不要扩展任务范围。完成后更新 `docs/MOBILE_REPORT.md`、`docs/EXECUTION_LOG.md`、`docs/PROJECT_STATE.md`、`docs/COMMAND_QUEUE.md`，并提交推送 GitHub。
