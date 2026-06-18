# Command Queue

`docs/COMMAND_QUEUE.md` 是 iOS ChatGPT 直接写入任务命令的主入口。Codex 桌面端每轮只执行用户指定的一个 CMD 编号命令，不自行选择其他命令。

## 状态枚举

- `PENDING`：等待执行。
- `IN_PROGRESS`：正在执行。
- `DONE`：已完成并记录结果。
- `BLOCKED`：被外部条件阻塞，需要用户处理或确认。
- `FAILED`：执行失败。
- `CANCELLED`：已取消。

## 当前命令

以下命令等待 Codex 执行：

## CMD-2026-06-18-001

状态：DONE
优先级：HIGH  
来源：iOS ChatGPT + 用户确认  
执行者：Codex Desktop App  
完成时间：2026-06-18 20:27 +08:00

### 任务目标

完成新协作结构的第一次正式闭环验证，并清理启动阶段遗留的文档状态不一致问题。

本轮任务的核心不是开发新功能，而是验证以下链路是否可稳定运行：

```text
iOS ChatGPT 写入 docs/COMMAND_QUEUE.md
→ 用户通过 UU 远程触发 Codex
→ Codex 同步 GitHub
→ Codex 读取指定 CMD
→ Codex 执行指定任务
→ Codex 更新文档
→ Codex commit 并 push
→ iOS ChatGPT 可再次从 GitHub 读取最新状态
```

### 执行范围

允许修改：

- `docs/COMMAND_QUEUE.md`
- `docs/MOBILE_REPORT.md`
- `docs/EXECUTION_LOG.md`
- `docs/PROJECT_STATE.md`
- `docs/NEXT_REVIEW.md`
- 必要时可小幅更新 `AGENTS.md`
- 必要时可小幅更新 `README.md`

禁止修改：

- Godot 功能代码
- Godot 场景文件
- 资源文件
- 交互逻辑
- 物理逻辑
- 保存/加载逻辑
- 导入图片逻辑
- 与本轮文档状态清理无关的文件

### 具体要求

1. 每轮开始前，严格按照 `AGENTS.md` 执行准备动作。
2. 先同步 GitHub 最新内容。
3. 读取以下文件：
   - `AGENTS.md`
   - `docs/COMMAND_QUEUE.md`
   - `docs/PROJECT_STATE.md`
   - `docs/MOBILE_REPORT.md`
   - `docs/EXECUTION_LOG.md`
   - `docs/NEXT_REVIEW.md`
   - `docs/TESTING.md`
   - `docs/ACCEPTANCE.md`
   - `docs/validation.md`
4. 确认当前只执行本命令：`CMD-2026-06-18-001`。
5. 将本命令状态从 `PENDING` 更新为 `IN_PROGRESS`。
6. 检查并修正 `docs/COMMAND_QUEUE.md` 中启动任务 `BOOTSTRAP-2026-06-18` 的过期状态。
7. 当前最新事实应统一为：
   - GitHub 仓库已创建。
   - 仓库为 `Tom-20201006/virtual-antinet-box`。
   - remote 为 `https://github.com/Tom-20201006/virtual-antinet-box.git`。
   - 本地 `main` 已成功 push 到 `origin/main`。
   - 当前没有 GitHub 同步阻塞。
8. 检查 `PROJECT_STATE.md`、`MOBILE_REPORT.md`、`EXECUTION_LOG.md`、`NEXT_REVIEW.md` 对 GitHub 同步状态的描述是否一致。
9. 如果发现文档之间存在冲突，以最新 GitHub 同步成功状态为准进行修正。
10. 不要把本轮任务扩展为功能开发任务。
11. 不要声明用户交互验收已经通过。
12. 明确区分：
    - Codex 可执行的自动检查；
    - 用户之后需要通过 UU 远程亲自执行的人工交互验收。

### 自动检查要求

Codex 需要执行基础自动检查，但不得把它等同于用户人工验收。

至少执行：

1. `git status -sb`
2. `git remote -v`
3. Godot headless 加载检查。

建议 Godot headless 命令参考 `docs/TESTING.md` 中已有命令。如果本机 Godot 路径不同，应根据实际路径调整，并在 `EXECUTION_LOG.md` 中记录。

自动检查的目标是确认：

1. 当前分支状态正常。
2. remote 指向正确。
3. 工作区状态可说明。
4. Godot 项目能加载。
5. 主场景没有明显脚本解析错误。

### 人工验收说明

本轮不要求 Codex 完成人工交互验收。

Codex 必须在 `MOBILE_REPORT.md` 和 `NEXT_REVIEW.md` 中明确写明：

1. Godot headless 检查只是自动预检查。
2. 真正的功能和交互验收需要用户通过 UU 远程打开 Godot。
3. 用户应按照 `docs/validation.md` 逐项测试：
   - 抽屉开合；
   - 卡片选中；
   - 卡片拿起和移动；
   - 卡片旋转和翻面；
   - 卡片放入抽屉；
   - 卡片从抽屉取出；
   - 本地图片导入；
   - 世界状态保存；
   - 世界状态加载；
   - 摄像机控制；
   - 最低限度数字化边界检查。
4. Codex 不得写“交互体验已通过人工验收”，除非用户明确提供验收结果。

### 完成标准

本轮完成后必须满足：

1. `docs/COMMAND_QUEUE.md` 中本命令状态更新为 `DONE`，除非发生阻塞或失败。
2. `BOOTSTRAP-2026-06-18` 的状态不再停留在过期的 `PUSH_BLOCKED_REPO_MISSING`。
3. 所有核心文档对 GitHub 同步状态的描述一致。
4. `docs/MOBILE_REPORT.md` 适合用户在手机上快速阅读。
5. `docs/EXECUTION_LOG.md` 记录本轮执行过程、检查命令、检查结果、修改文件和 commit 状态。
6. `docs/PROJECT_STATE.md` 反映当前真实状态。
7. `docs/NEXT_REVIEW.md` 写明下一轮 iOS ChatGPT 应优先查看的文件和下一步建议。
8. 自动检查结果已写入文档。
9. 文档明确说明人工交互验收尚需用户通过 UU 远程执行。
10. 本轮修改已 commit。
11. 本轮修改已 push 到 GitHub。
12. 如果 push 失败，必须将失败原因写入 `MOBILE_REPORT.md` 和 `EXECUTION_LOG.md`，并将本命令状态标记为 `BLOCKED` 或 `FAILED`。

### 输出要求

执行完成后必须更新：

- `docs/COMMAND_QUEUE.md`
- `docs/MOBILE_REPORT.md`
- `docs/EXECUTION_LOG.md`
- `docs/PROJECT_STATE.md`
- `docs/NEXT_REVIEW.md`

必要时更新：

- `AGENTS.md`
- `README.md`

提交要求：

1. commit message 必须包含 `CMD-2026-06-18-001`。
2. commit 前检查 `git status` 或 `git diff`。
3. push 到 GitHub。
4. 在 `MOBILE_REPORT.md` 中写明最新 commit 和 push 状态。

### Codex 完成后在聊天窗口中的简短汇报格式

请只简短汇报：

1. `CMD-2026-06-18-001` 当前状态。
2. 修改了哪些文件。
3. 自动检查是否通过。
4. 是否已 commit/push。
5. 用户下一步应如何通过 UU 远程进行人工验收。

### 执行结果

本命令已完成。Codex 已同步 GitHub 最新内容，读取指定文档，只执行本命令范围内的文档状态清理与闭环验证。

自动检查结果：

1. `git status -sb`：通过，输出 `## main...origin/main`。
2. `git remote -v`：通过，`origin` 指向 `https://github.com/Tom-20201006/virtual-antinet-box.git`。
3. Godot headless 加载检查：通过，Godot 4.6.3 能加载主场景，无脚本解析错误。

人工验收状态：

- 未由 Codex 执行人工交互验收。
- 用户仍需通过 UU 远程打开 Godot，按 `docs/validation.md` 逐项测试交互。

## 命令模板

```markdown
## CMD-YYYY-MM-DD-001

状态：PENDING
优先级：HIGH / MEDIUM / LOW
来源：iOS ChatGPT + 用户确认
执行者：Codex Desktop App

### 任务目标

...

### 执行范围

允许修改：
- ...

禁止修改：
- ...

### 具体要求

1. ...

### 验证要求

1. ...

### 完成标准

1. ...

### 输出要求

完成后必须更新：
- docs/MOBILE_REPORT.md
- docs/EXECUTION_LOG.md
- docs/PROJECT_STATE.md
- docs/COMMAND_QUEUE.md

并提交、推送 GitHub。
```

## 已执行的启动任务

### BOOTSTRAP-2026-06-18

状态：DONE / PUSHED

任务目标：

- 建立手机端决策、ChatGPT 直写命令、GitHub 状态中心、UU 远程触发、Codex 桌面端执行的协作结构。

结果：

- 本地协作文档结构已创建。
- 本地 Git 仓库已初始化并提交。
- GitHub 仓库已创建：`Tom-20201006/virtual-antinet-box`。
- remote 已设置为 `https://github.com/Tom-20201006/virtual-antinet-box.git`。
- 本地 `main` 已成功 push 到 `origin/main`。
- 当前没有 GitHub 同步阻塞。
