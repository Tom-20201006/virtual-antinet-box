# Commands

`docs/01_COMMANDS.md` 是新结构下的主命令入口。Codex 桌面端每轮只执行用户指定的一个 CMD 编号命令，不自行选择其他命令。

## 状态枚举

- `PENDING`：等待执行。
- `IN_PROGRESS`：正在执行。
- `DONE`：已完成并记录结果。
- `BLOCKED`：被外部条件阻塞，需要用户处理或确认。
- `FAILED`：执行失败。
- `CANCELLED`：已取消。

## 当前命令

当前没有新的 `PENDING` 命令。

## 最近 3 条命令摘要

### CMD-2026-06-19-002

状态：DONE
目标：将旧文档结构重构为根目录核心文档、docs 主控层、spec 规格层、research 研究层、history 正式历史层、archive 冷归档层。
结果：新分层结构已创建；旧命令全文和旧文档原文已归档；旧 `docs/COMMAND_QUEUE.md` 已改为兼容跳转；未修改 Godot 功能代码、场景、资源或运行配置；指定 Godot `--quit-after 1` headless 命令崩溃已记录，备用 `--quit` headless 加载通过。

### CMD-2026-06-18-001

状态：DONE
目标：完成第一次正式协作闭环验证，并清理启动阶段文档状态不一致问题。
结果：协作闭环验证通过；Godot headless 自动检查通过；用户随后通过 UU 远程完成人工验收并反馈一切正常。

### BOOTSTRAP-2026-06-18

状态：DONE / PUSHED
目标：建立手机端决策、ChatGPT 直写命令、GitHub 状态中心、UU 远程触发、Codex 桌面端执行的协作结构。
结果：GitHub 仓库已创建并完成首次 push，当前无同步阻塞。

## 命令模板

```markdown
## CMD-YYYY-MM-DD-001

状态：PENDING
优先级：HIGH / MEDIUM / LOW
来源：iOS ChatGPT + 用户确认
执行者：Codex Desktop App
任务类型：

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

完成后必须更新相关文档，并提交、推送 GitHub。
```

## 旧命令归档

旧 `docs/COMMAND_QUEUE.md` 的全文已归档到 `docs/archive/old_commands/COMMAND_QUEUE.md`。后续不要把完整历史命令长期堆在本文件中；最近命令只保留摘要，正式执行细节写入 `docs/history/EXECUTION_LOG.md`。
