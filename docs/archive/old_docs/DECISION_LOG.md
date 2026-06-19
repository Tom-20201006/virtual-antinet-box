# Decision Log

## 2026-06-18 协作结构决策

### 背景

用户希望建立一个适合手机端长期协作的项目结构：iOS ChatGPT 负责讨论和写入命令，Codex 桌面端负责本地执行，GitHub 作为唯一项目事实来源，UU 远程只负责最低限度触发。

### 选择

采用 iOS ChatGPT 直接写入 `docs/COMMAND_QUEUE.md`，GitHub 作为唯一事实来源，Codex 桌面端执行指定编号命令。

### 放弃方案

- 不把 GitHub Issue 作为主命令入口。
- 不让 GitHub iOS App 成为长期手动编辑命令的主工具。
- 不让 Codex 聊天窗口成为唯一状态记录。

### 理由

`docs/COMMAND_QUEUE.md` 可以被 iOS ChatGPT 直接读写，也能被 Codex 每轮固定读取，减少手机端长文本输入和远程桌面操作负担。

### 对后续影响

- 后续每轮任务必须有 CMD 编号。
- Codex 每轮只执行指定 CMD。
- 所有状态必须写入仓库文档。
- 重要验收步骤必须按 `docs/validation.md` 的详细标准编写。
