# AGENTS.md

本文件是 VirtualAntinetBox 仓库的 Codex 协作主规范。GitHub 仓库是项目唯一事实来源，Codex 桌面端不能把聊天窗口当作唯一交付结果，所有重要状态必须写入仓库文档。

## 固定读取规则

从 `CMD-2026-06-19-002` 完成后，Codex 每轮固定读取文件收敛为：

1. `AGENTS.md`
2. `docs/00_STATUS.md`
3. `docs/01_COMMANDS.md`

`docs/COMMAND_QUEUE.md` 仅作为旧入口兼容跳转，不再作为新命令主入口。

## 每轮开始前必须执行

1. 确认当前目录是仓库根目录。
2. 执行 `git status -sb`，检查工作区状态。
3. 执行 `git branch --show-current`，确认当前分支。
4. 执行 `git remote -v`，确认 GitHub remote。
5. 如果已有 remote，先执行快进同步；若 pull 冲突，停止并记录 `BLOCKED`，不得强行覆盖。
6. 读取 `AGENTS.md`、`docs/00_STATUS.md`、`docs/01_COMMANDS.md`。
7. 确认本轮只执行用户指定的一个 CMD 编号命令。
8. 按任务类型追加读取必要文档。

## 按任务追加读取

- 当前任务背景：`docs/02_CURRENT_TASK_CONTEXT.md`
- 产品设计：`docs/spec/PRODUCT_SPEC.md`
- 交互设计：`docs/spec/INTERACTION_SPEC.md`
- 物理组件：`docs/spec/PHYSICAL_MODEL_SPEC.md`
- 存储路径：`docs/spec/STORAGE_SPEC.md`
- 测试验收：`docs/spec/TEST_SPEC.md` 和 `docs/validation.md`
- 历史追溯：`docs/history/*`
- 冷归档查证：`docs/archive/*`

## 执行任务时必须遵守

1. 不自行选择其他命令。
2. 不自行扩大任务范围。
3. 不跳过命令中的禁止修改范围。
4. 不把未验证的结果写成已完成。
5. 如果命令与当前项目状态冲突，应停止并记录 `BLOCKED`。
6. 修改代码前必须先理解相关文件。
7. 修改文档前必须保留已有有效信息，旧内容应迁移、摘要或归档。
8. 涉及 Godot 功能或交互变化时，必须同步更新测试说明和验收说明。
9. 验收步骤必须按 `docs/validation.md` 的详细逐步标准编写。
10. 不引入 OCR、搜索、标签、自动分类、自动链接、AI 摘要、知识图谱等违背项目原则的功能。

## 执行完成后必须更新

默认每轮完成后至少更新：

- `docs/00_STATUS.md`
- `docs/01_COMMANDS.md`
- `docs/history/EXECUTION_LOG.md`

视任务情况追加更新：

- `docs/02_CURRENT_TASK_CONTEXT.md`
- `docs/spec/*`
- `docs/research/*`
- `docs/history/DECISIONS.md`
- `docs/history/ACCEPTANCE_LOG.md`
- `docs/history/BUG_LOG.md`
- `README.md`
- `docs/archive/*`

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
2. commit message 应包含 CMD 编号。
3. commit 前必须检查 `git status` 或 `git diff`。
4. push 前必须确认没有提交临时文件、无关大文件或敏感信息。
5. 如果无法 push，必须把失败原因写入 `docs/00_STATUS.md` 和 `docs/history/EXECUTION_LOG.md`。

## 与 iOS ChatGPT 的衔接

1. iOS ChatGPT 通过 GitHub 读取项目状态。
2. iOS ChatGPT 后续应直接写入 `docs/01_COMMANDS.md`。
3. Codex 每轮执行前必须同步 GitHub 并读取最新命令文档。
4. Codex 执行期间如果发现命令文档被其他提交更新，应重新确认本轮命令状态。
5. Codex 不应依赖当前聊天窗口保存结果，所有重要结论必须写入仓库文件。

## 后续 UU 远程触发模板

请先同步 GitHub 最新内容，然后读取 `AGENTS.md`、`docs/00_STATUS.md` 和 `docs/01_COMMANDS.md`，执行 `CMD-YYYY-MM-DD-001`。只执行该编号命令，不要扩展任务范围。完成后更新 `docs/00_STATUS.md`、`docs/01_COMMANDS.md`、`docs/history/EXECUTION_LOG.md`，并提交推送 GitHub。
