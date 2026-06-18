# Next Review

## 下一轮 iOS ChatGPT 应优先查看

1. `docs/MOBILE_REPORT.md`
2. `docs/PROJECT_STATE.md`
3. `docs/COMMAND_QUEUE.md`
4. `AGENTS.md`
5. `docs/EXECUTION_LOG.md`
6. `docs/validation.md`
7. `docs/BUG_REPORT.md`
8. `docs/ACCEPTANCE.md`

## 当前最重要的问题

第一次正式协作闭环验证已完成，用户人工交互验收也已完成。当前状态：

- 仓库：`Tom-20201006/virtual-antinet-box`
- remote：`https://github.com/Tom-20201006/virtual-antinet-box.git`
- 本地分支：`main`
- 远程分支：`origin/main`
- `CMD-2026-06-18-001` 已完成。
- 自动检查通过。
- 用户已通过 UU 远程完成 Godot Demo 人工验收。
- 用户反馈：一切正常。
- 当前暂无用户报告的运行 Bug。

## 上一轮最重要变化

- 已建立协作结构文档。
- 已将 `docs/COMMAND_QUEUE.md` 设为主命令入口。
- 已创建 `AGENTS.md`，规定 Codex 每轮开始、执行、完成、提交、推送和记录规则。
- 已完成 GitHub 仓库首次同步。
- 已清理启动阶段过期的 `PUSH_BLOCKED_REPO_MISSING` 状态。
- 已明确 Godot headless 检查不等同于人工交互验收。
- 用户已完成真正的 UU 远程人工交互验收，结果正常。

## 下一步可能方向

1. 进入首版 Demo 后的体验细化：拖拽、选中、抽屉开合、摄像机、焦点切换。
2. 进入导入流程细化：背面图片导入、批量导入、资源路径管理。
3. 进入大量卡片性能结构：对象池、缩略图/高清贴图分层、抽屉深处静态表示。
4. 进入真实使用流程设计：用少量真实扫描卡片试用，记录第一批体验改进项。

## 不要重复讨论

- Issue 不是主命令入口。
- GitHub iOS App 不是长期手动输入命令的主工具。
- Codex 聊天窗口不是唯一状态记录。
- 本项目不做 OCR、搜索、标签、AI 摘要、自动分类、自动链接或知识图谱。
- Godot headless 检查不是人工验收；但当前用户人工验收已经完成并反馈正常。

## 需要用户确认的问题

1. 下一轮正式 CMD 优先做哪个方向：交互体验、导入流程、性能结构，还是真实使用流程？
2. 是否需要把仓库 visibility 从 public 调整为 private？
