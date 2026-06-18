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

当前没有等待执行的后续命令。本次协作结构初始化是由用户直接提供的启动任务，不依赖既有 CMD 编号。

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

状态：DONE_LOCAL / PUSH_BLOCKED

任务目标：

- 建立手机端决策、ChatGPT 直写命令、GitHub 状态中心、UU 远程触发、Codex 桌面端执行的协作结构。

结果：

- 本地协作文档结构已创建。
- 本地 Git 仓库将初始化并提交。
- GitHub 创建远程仓库与 push 当前阻塞，原因见 `docs/MOBILE_REPORT.md` 和 `docs/EXECUTION_LOG.md`。
