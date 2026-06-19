# Command Queue

`docs/COMMAND_QUEUE.md` 是当前旧文档结构中的主命令入口。Codex 桌面端每轮只执行用户指定的一个 CMD 编号命令，不自行选择其他命令。

> 兼容说明：本文件将在 `CMD-2026-06-19-002` 执行后被迁移为新结构中的 `docs/01_COMMANDS.md` 主入口；迁移完成前，Codex 仍应从本文件读取当前命令。

## 状态枚举

- `PENDING`：等待执行。
- `IN_PROGRESS`：正在执行。
- `DONE`：已完成并记录结果。
- `BLOCKED`：被外部条件阻塞，需要用户处理或确认。
- `FAILED`：执行失败。
- `CANCELLED`：已取消。

## 当前命令

以下命令等待 Codex 执行：

## CMD-2026-06-19-002

状态：IN_PROGRESS
优先级：HIGH
来源：iOS ChatGPT + 用户确认
执行者：Codex Desktop App
任务类型：文档结构重构 / 不修改 Godot 功能代码

### 任务目标

将当前已经开始膨胀的项目文档结构，重构为一套更适合长期 iOS ChatGPT + GitHub + Codex + UU 远程协作的分层文档体系。

本轮任务的核心不是开发新功能，不是调整 Godot 场景，也不是继续追加碎片化文档，而是：

1. 收敛项目文档入口。
2. 降低每轮 Codex 执行时的上下文读取成本。
3. 明确区分当前状态、当前命令、项目规格、研究材料、正式历史和冷归档。
4. 让未来的视频分析、Antinet 工作流反推、物理组件规格、D 盘存储策略等内容进入稳定容器，而不是不断新增平级文档。
5. 保留旧文档内容，不直接删除，以归档或兼容跳转方式迁移。

### 新文档结构的理论和设计哲学

当前项目文档出现了泛滥趋势。原有结构在搭建协作机制时有效，因为它把每个机制拆成独立文档，便于验证：项目状态、移动端报告、命令队列、执行日志、下一轮审查、验收记录、Bug 记录等分别存在。

但进入软件开发主线后，这种结构开始产生问题：

1. 入口过多：iOS ChatGPT 和 Codex 每轮都需要判断应该读哪些文件。
2. 职责重叠：`PROJECT_STATE.md`、`MOBILE_REPORT.md`、`NEXT_REVIEW.md` 都在描述当前状态和下一步。
3. 历史污染当前上下文：旧命令、旧日志、旧验收结果会被重复读入。
4. 规格和研究混杂：视频观察、交互规格、物理模型、存储策略如果继续平级新增，会让 docs 目录越来越难读。
5. 同步成本升高：每轮文档更新可能波及太多文件。

新的文档结构按“使用频率”和“文档职责”分层，而不是按每一次任务或每一个想法新建文件。

新结构遵循以下原则：

1. 越常读的文档越少、越短、越靠前。
2. 当前状态和历史记录分离。
3. 最终规格和研究材料分离。
4. 正式历史和冷归档分离。
5. Codex 每轮固定读取的文件应控制在 3 个左右，其他文件由命令按需指定。
6. 新增内容优先进入既有容器，不再随意新增平级文档。
7. 旧文件不直接删除，先归档或改为兼容跳转，避免丢失上下文。

### 新文档结构总览

请将项目文档重构为以下结构：

```text
repo/
├─ README.md
├─ PROJECT_CHARTER.md
├─ AGENTS.md
│
├─ docs/
│  ├─ 00_STATUS.md
│  ├─ 01_COMMANDS.md
│  ├─ 02_CURRENT_TASK_CONTEXT.md
│  │
│  ├─ spec/
│  │  ├─ PRODUCT_SPEC.md
│  │  ├─ INTERACTION_SPEC.md
│  │  ├─ PHYSICAL_MODEL_SPEC.md
│  │  ├─ STORAGE_SPEC.md
│  │  └─ TEST_SPEC.md
│  │
│  ├─ research/
│  │  └─ ANTINET_WORKFLOW_OBSERVATIONS.md
│  │
│  ├─ history/
│  │  ├─ HISTORY.md
│  │  ├─ DECISIONS.md
│  │  ├─ EXECUTION_LOG.md
│  │  ├─ ACCEPTANCE_LOG.md
│  │  └─ BUG_LOG.md
│  │
│  └─ archive/
│     ├─ old_docs/
│     ├─ old_commands/
│     ├─ old_reports/
│     ├─ deprecated_specs/
│     └─ raw_notes/
```

### 各组件的详细作用

#### 1. 根目录文档

根目录只保留长期稳定的最高入口。

##### `README.md`

作用：给人快速了解项目。

应包含：

- 项目一句话说明。
- 如何运行 Godot 项目。
- 当前 Demo 能做什么。
- 项目原则摘要。
- 新文档入口索引。

不应包含：

- 详细执行日志。
- 当前命令全文。
- 长期验收记录。
- 研究材料。
- 过长的历史。

##### `PROJECT_CHARTER.md`

作用：项目宪法。

应包含：

- 最高原则：计算机只模拟物理卡片盒，不替用户思考。
- 允许功能。
- 禁止功能。
- 保存边界。
- 对 OCR、搜索、标签、自动分类、自动链接、AI 摘要、知识图谱、内容理解等功能的禁止说明。

该文件应尽量稳定，不频繁更新。

##### `AGENTS.md`

作用：Codex 执行规则。

应更新为新结构下的轻量读取规则。

固定读取：

1. `AGENTS.md`
2. `docs/00_STATUS.md`
3. `docs/01_COMMANDS.md`

按任务类型追加读取：

- 当前任务背景：`docs/02_CURRENT_TASK_CONTEXT.md`
- 产品设计：`docs/spec/PRODUCT_SPEC.md`
- 交互设计：`docs/spec/INTERACTION_SPEC.md`
- 物理组件：`docs/spec/PHYSICAL_MODEL_SPEC.md`
- 存储路径：`docs/spec/STORAGE_SPEC.md`
- 测试验收：`docs/spec/TEST_SPEC.md` 和 `docs/validation.md`
- 历史追溯：`docs/history/*`

#### 2. `docs/00_STATUS.md`

作用：当前项目状态总览。

它替代旧结构中的：

- `docs/PROJECT_STATE.md`
- `docs/MOBILE_REPORT.md`
- `docs/NEXT_REVIEW.md`

应包含：

- 当前阶段。
- 当前事实。
- 当前阻塞或待确认问题。
- 最近 3 条关键变化。
- 下一步建议。
- 下一轮固定读取文件。

必须遵守：

- 只保留最近 3 条关键变化。
- 不写完整执行历史。
- 不写完整命令历史。
- 不写长篇研究材料。
- 控制篇幅，目标是不超过 150 行。

当前事实应反映：

- 首版 Godot Demo 已通过用户 UU 远程人工验收。
- 用户报告一切正常，暂无运行 Bug。
- CMD001 已完成协作闭环验证。
- 当前项目进入“文档结构收敛”和“Antinet 实体工作流反推准备”阶段。

#### 3. `docs/01_COMMANDS.md`

作用：新结构下的主命令入口。

它替代旧结构中的：

- `docs/COMMAND_QUEUE.md`

应包含：

- 状态枚举。
- 当前待执行命令。
- 命令模板。
- 最近 3 条命令摘要。

必须遵守：

- 当前命令全文可以保留。
- 最近已完成命令只保留摘要。
- 旧命令全文应归档到 `docs/archive/old_commands/` 或写入 `docs/history/EXECUTION_LOG.md`。
- 不要把所有历史命令全文长期堆在主命令文件中。

迁移完成后：

- `docs/COMMAND_QUEUE.md` 不应直接删除。
- 它应改为兼容跳转文件，说明新命令入口是 `docs/01_COMMANDS.md`。
- 兼容跳转文件中可以保留一句警告：旧入口已迁移，后续 iOS ChatGPT 应写入 `docs/01_COMMANDS.md`。

#### 4. `docs/02_CURRENT_TASK_CONTEXT.md`

作用：当前任务或当前阶段的临时上下文缓冲区。

应包含：

- 当前讨论主题。
- 用户最近提出的问题。
- 尚未定稿的临时结论。
- 待转化为正式规格或命令的内容。

该文件用于避免：

- 把临时讨论塞进 `00_STATUS.md`。
- 把未定稿内容塞进 `spec/`。
- 让 Codex 读取大量聊天上下文。

当前应写入：

- 用户指出项目文档有泛滥趋势。
- 新文档结构采用主控层、规格层、研究层、历史层、归档层。
- 视频分析和物理组件分析不应与当前状态、项目目标、协作规则同层。
- 当前状态文档最多保留最近 3 条关键变化。
- history 负责正式历史，archive 负责冷归档。

#### 5. `docs/spec/PRODUCT_SPEC.md`

作用：产品规格。

应包含：

- 产品定位。
- 核心用户目标。
- 核心对象。
- 当前阶段目标。
- 当前阶段不做什么。
- 与 `PROJECT_CHARTER.md` 的关系说明。

应根据现有项目状态整理出：

- VirtualAntinetBox 是虚拟实体卡片盒，不是数字笔记软件。
- 核心对象包括桌面、卡片盒、抽屉、卡片、分隔片、导入图片、本地状态文件。
- 下一阶段目标是根据真实 Antinet 工作流重建卡片盒交互。

#### 6. `docs/spec/INTERACTION_SPEC.md`

作用：交互规格。

应包含：

- 交互设计目标。
- 核心工作流。
- 实体动作到虚拟动作的映射。
- 必须模拟的动作。
- 可以简化的动作。
- 暂不实现的动作。
- 待视频分析补充的问题。

当前应先创建框架，不要编造视频结论。

可写入已知方向：

- 后续将根据 Scheper 视频中展示的 Antinet 工作流反推交互设计。
- 重点观察打开抽屉、浏览卡片、取出卡片、桌面摊开、插回卡片、使用分隔片等动作。

#### 7. `docs/spec/PHYSICAL_MODEL_SPEC.md`

作用：物理组件规格。

应包含：

- 组件层级。
- 桌面规格。
- 卡片盒规格。
- 抽屉规格。
- 卡片规格。
- 分隔片规格。
- 碰撞与选中规则。
- 卡片在抽屉中的排列关系。
- 后续待视频观察确认的问题。

当前应根据已有 Demo 状态整理，不要假装已经完成视频分析。

应明确：

- 系统物理状态分析属于 `spec/PHYSICAL_MODEL_SPEC.md`，不属于主控层。
- 后续视频分析会不断补充和修正这里。

#### 8. `docs/spec/STORAGE_SPEC.md`

作用：存储和本地数据策略。

必须包含用户明确要求：

- 项目的本地保存路径全部设在 D 盘项目文件路径下。
- 不要把过多数据存在 C 盘。
- 导入图片、世界状态、缩略图、缓存、备份等大量数据默认应存放在项目 D 盘目录内。

建议目录：

```text
local_data/
├─ world_state/
├─ imported_cards/
├─ thumbnails/
├─ cache/
└─ backups/
```

应明确：

- 当前如果仍使用 Godot `user://`，需要在后续实现任务中改造。
- 本轮只做文档结构重构，不改存储代码。

#### 9. `docs/spec/TEST_SPEC.md`

作用：测试和验收总入口。

应包含：

- 自动检查要求。
- 人工验收要求。
- Codex 自动检查和用户人工验收的区别。
- Bug 记录入口。
- `docs/validation.md` 的关系。

应保留 `docs/validation.md` 作为详细逐步验收附录，不必合并。

#### 10. `docs/research/ANTINET_WORKFLOW_OBSERVATIONS.md`

作用：研究材料，记录从 Scheper 视频或截图中观察到的 Antinet 工作流。

应包含：

- 观察记录模板。
- 视频来源字段。
- 时间段字段。
- 画面对象字段。
- 动作序列字段。
- 可推断的物理关系字段。
- 对软件设计的启发字段。
- 待确认字段。

当前只创建模板，不编造具体观察。

应明确：

- research 记录“观察到什么”。
- spec 记录“决定怎么做”。

#### 11. `docs/history/HISTORY.md`

作用：项目大事年表。

应包含：

- GitHub 协作结构建立。
- CMD001 协作闭环验证完成。
- 用户通过 UU 远程验收首版 Demo，结果正常。
- 开始讨论文档结构收敛。

不应写执行细节。

#### 12. `docs/history/DECISIONS.md`

作用：重要决策记录。

应包含已有重要决策：

- 使用 GitHub 作为事实来源。
- iOS ChatGPT 直接写命令。
- Codex 只执行指定 CMD。
- 本项目不做 OCR、搜索、标签、AI 摘要、知识图谱等内容理解功能。
- 新文档结构按使用频率和职责分层。
- history 与 archive 分离。

#### 13. `docs/history/EXECUTION_LOG.md`

作用：Codex 执行历史。

应从旧 `docs/EXECUTION_LOG.md` 迁移或整理内容。

应包含：

- BOOTSTRAP 阶段摘要。
- GitHub push 成功摘要。
- CMD001 执行摘要。
- CMD002 执行记录。

可以保留详细记录，但新主控文档不应默认读取它。

#### 14. `docs/history/ACCEPTANCE_LOG.md`

作用：用户人工验收历史。

应从 `docs/USER_ACCEPTANCE_LOG.md` 迁移内容。

应包含：

- 2026-06-18 首版 Demo 人工验收。
- 验收方式：用户通过 UU 远程打开 Godot。
- 结果：通过。
- 用户反馈：一切正常。
- 暂无需要记录的运行 Bug。

#### 15. `docs/history/BUG_LOG.md`

作用：Bug 历史和当前开放问题。

应从 `docs/BUG_REPORT.md` 迁移内容。

应包含：

- 当前开放 Bug：暂无。
- 已确认运行 Bug：暂无。
- 用户首版验收未报告 Bug。
- Bug 记录模板。

#### 16. `docs/archive/`

作用：冷归档。

应创建子目录：

- `docs/archive/old_docs/`
- `docs/archive/old_commands/`
- `docs/archive/old_reports/`
- `docs/archive/deprecated_specs/`
- `docs/archive/raw_notes/`

archive 不是正式历史记录。它保存旧文件原文、旧命令全文、过期报告、废弃规格、原始草稿。

### 执行范围

允许修改：

- `README.md`
- `AGENTS.md`
- `docs/COMMAND_QUEUE.md`
- `docs/PROJECT_STATE.md`
- `docs/MOBILE_REPORT.md`
- `docs/NEXT_REVIEW.md`
- `docs/EXECUTION_LOG.md`
- `docs/DECISION_LOG.md`
- `docs/TESTING.md`
- `docs/ACCEPTANCE.md`
- `docs/BUG_REPORT.md`
- `docs/USER_ACCEPTANCE_LOG.md`
- 新建 `docs/00_STATUS.md`
- 新建 `docs/01_COMMANDS.md`
- 新建 `docs/02_CURRENT_TASK_CONTEXT.md`
- 新建 `docs/spec/*`
- 新建 `docs/research/*`
- 新建 `docs/history/*`
- 新建 `docs/archive/*`

禁止修改：

- Godot 功能代码。
- Godot 场景文件。
- Godot 资源文件。
- 脚本交互逻辑。
- 物理逻辑。
- 保存/加载实现代码。
- 导入图片实现代码。
- 项目运行配置，除非只是文档链接更新且必须。

### 具体执行要求

1. 每轮开始前严格按照当前 `AGENTS.md` 执行准备动作。
2. 先执行 `git pull --ff-only origin main`，同步 GitHub 最新内容。
3. 读取当前命令文件 `docs/COMMAND_QUEUE.md`，确认只执行 `CMD-2026-06-19-002`。
4. 将本命令状态从 `PENDING` 更新为 `IN_PROGRESS`。
5. 读取并理解现有文档：
   - `README.md`
   - `PROJECT_CHARTER.md`
   - `AGENTS.md`
   - `docs/COMMAND_QUEUE.md`
   - `docs/PROJECT_STATE.md`
   - `docs/MOBILE_REPORT.md`
   - `docs/NEXT_REVIEW.md`
   - `docs/EXECUTION_LOG.md`
   - `docs/DECISION_LOG.md`
   - `docs/TESTING.md`
   - `docs/ACCEPTANCE.md`
   - `docs/validation.md`
   - `docs/BUG_REPORT.md`
   - `docs/USER_ACCEPTANCE_LOG.md`
6. 创建新目录结构：
   - `docs/spec/`
   - `docs/research/`
   - `docs/history/`
   - `docs/archive/old_docs/`
   - `docs/archive/old_commands/`
   - `docs/archive/old_reports/`
   - `docs/archive/deprecated_specs/`
   - `docs/archive/raw_notes/`
7. 创建并填充新主控文档：
   - `docs/00_STATUS.md`
   - `docs/01_COMMANDS.md`
   - `docs/02_CURRENT_TASK_CONTEXT.md`
8. 创建并填充规格文档：
   - `docs/spec/PRODUCT_SPEC.md`
   - `docs/spec/INTERACTION_SPEC.md`
   - `docs/spec/PHYSICAL_MODEL_SPEC.md`
   - `docs/spec/STORAGE_SPEC.md`
   - `docs/spec/TEST_SPEC.md`
9. 创建并填充研究文档：
   - `docs/research/ANTINET_WORKFLOW_OBSERVATIONS.md`
10. 创建并填充历史文档：
    - `docs/history/HISTORY.md`
    - `docs/history/DECISIONS.md`
    - `docs/history/EXECUTION_LOG.md`
    - `docs/history/ACCEPTANCE_LOG.md`
    - `docs/history/BUG_LOG.md`
11. 处理旧文档：
    - 不直接删除旧文档。
    - 将旧文档内容归档到 `docs/archive/old_docs/`、`docs/archive/old_reports/` 或 `docs/archive/old_commands/`。
    - 旧主入口文件可以改为简短兼容跳转说明。
    - 尤其 `docs/COMMAND_QUEUE.md` 应指向新入口 `docs/01_COMMANDS.md`。
12. 更新 `README.md` 的文档入口索引，使其指向新结构。
13. 更新 `AGENTS.md` 的每轮读取规则，使固定读取文件变为：
    - `AGENTS.md`
    - `docs/00_STATUS.md`
    - `docs/01_COMMANDS.md`
14. 在 `docs/01_COMMANDS.md` 中保留本命令执行结果，并将本命令状态最终更新为 `DONE`，除非发生阻塞或失败。
15. 在 `docs/history/EXECUTION_LOG.md` 记录本轮执行过程。
16. 不要新增未在本命令中列出的平级文档。
17. 不要编造 Scheper 视频观察结论。视频观察文档只创建模板，等待用户提供视频材料。
18. 不要把当前文档结构重构误写成 Godot 功能开发完成。

### 每个新文档应放什么内容

Codex 应根据上述设计理念和当前项目状态，自行整理内容，但必须遵守以下最低要求：

1. `docs/00_STATUS.md` 必须包含当前阶段、当前事实、当前阻塞、最近 3 条关键变化、下一步建议、下一轮固定读取文件。
2. `docs/01_COMMANDS.md` 必须包含状态枚举、当前命令、命令模板、最近 3 条命令摘要；本命令完成后状态应为 `DONE`。
3. `docs/02_CURRENT_TASK_CONTEXT.md` 必须记录本次文档结构收敛讨论的临时结论。
4. `docs/spec/PRODUCT_SPEC.md` 必须说明 VirtualAntinetBox 是虚拟实体卡片盒，不是数字笔记软件。
5. `docs/spec/INTERACTION_SPEC.md` 必须创建真实 Antinet 工作流反推的交互规格框架，但不得编造视频细节。
6. `docs/spec/PHYSICAL_MODEL_SPEC.md` 必须整理桌面、卡片盒、抽屉、卡片、分隔片的物理组件规格框架。
7. `docs/spec/STORAGE_SPEC.md` 必须写入 D 盘项目路径存储原则，并明确后续需要改造 Godot `user://` 默认存储策略。
8. `docs/spec/TEST_SPEC.md` 必须明确 Codex 自动检查不等同于用户人工验收，并指向 `docs/validation.md`。
9. `docs/research/ANTINET_WORKFLOW_OBSERVATIONS.md` 必须只放观察模板和待补材料，不得伪造观察内容。
10. `docs/history/HISTORY.md` 必须记录项目大事年表。
11. `docs/history/DECISIONS.md` 必须记录重要决策。
12. `docs/history/EXECUTION_LOG.md` 必须迁移或摘要现有执行记录，并加入本次 CMD002 执行记录。
13. `docs/history/ACCEPTANCE_LOG.md` 必须迁移用户人工验收记录。
14. `docs/history/BUG_LOG.md` 必须迁移当前 Bug 状态并记录当前暂无用户报告运行 Bug。
15. `docs/archive/` 中必须有旧文档和旧命令的归档或说明。

### 检查命令

执行完成后必须运行以下检查命令，并将结果写入 `docs/history/EXECUTION_LOG.md` 和 `docs/00_STATUS.md` 摘要区：

```powershell
git status -sb
```

```powershell
git diff --stat
```

```powershell
git ls-files docs
```

```powershell
git ls-files docs | Select-String "00_STATUS|01_COMMANDS|02_CURRENT_TASK_CONTEXT|spec/|research/|history/|archive/"
```

如果当前 shell 不支持 PowerShell 的 `Select-String`，可改用等价的 `findstr` 或手动检查。

还必须执行 Godot 自动预检查，确认文档重构未破坏项目加载：

```powershell
& 'D:\Godot\Godot_v4.6.3-stable_win64_console.exe' --headless --path 'D:\codex project\VirtualAntinetBox\project\virtual-antinet-box' --quit-after 1
```

如果本机 Godot 路径不同，应使用实际路径，并记录差异。

### 完成标准

本命令完成后必须满足：

1. 新文档结构已创建。
2. 旧文档内容已迁移、摘要或归档，没有直接丢失重要信息。
3. `README.md` 指向新文档入口。
4. `AGENTS.md` 改为轻量固定读取规则。
5. `docs/COMMAND_QUEUE.md` 作为旧入口，清楚指向 `docs/01_COMMANDS.md`。
6. `docs/01_COMMANDS.md` 成为新命令主入口。
7. `docs/00_STATUS.md` 能让 iOS ChatGPT 快速了解当前项目状态。
8. `docs/spec/` 能承载后续产品、交互、物理、存储、测试规格。
9. `docs/research/` 能承载后续 Scheper 视频观察。
10. `docs/history/` 能承载正式历史记录。
11. `docs/archive/` 能承载冷归档材料。
12. 当前没有为了文档重构而修改任何 Godot 功能代码。
13. 自动检查命令已执行并记录。
14. Godot headless 加载仍通过，或如失败，必须明确记录失败原因。
15. 本命令状态更新为 `DONE`，除非发生阻塞或失败。
16. 本轮修改已 commit。
17. 本轮修改已 push 到 GitHub。

### 输出要求

完成后必须更新：

- `README.md`
- `AGENTS.md`
- `docs/COMMAND_QUEUE.md`
- `docs/00_STATUS.md`
- `docs/01_COMMANDS.md`
- `docs/02_CURRENT_TASK_CONTEXT.md`
- `docs/spec/PRODUCT_SPEC.md`
- `docs/spec/INTERACTION_SPEC.md`
- `docs/spec/PHYSICAL_MODEL_SPEC.md`
- `docs/spec/STORAGE_SPEC.md`
- `docs/spec/TEST_SPEC.md`
- `docs/research/ANTINET_WORKFLOW_OBSERVATIONS.md`
- `docs/history/HISTORY.md`
- `docs/history/DECISIONS.md`
- `docs/history/EXECUTION_LOG.md`
- `docs/history/ACCEPTANCE_LOG.md`
- `docs/history/BUG_LOG.md`

并创建或更新：

- `docs/archive/old_docs/`
- `docs/archive/old_commands/`
- `docs/archive/old_reports/`
- `docs/archive/deprecated_specs/`
- `docs/archive/raw_notes/`

提交要求：

1. commit message 必须包含 `CMD-2026-06-19-002`。
2. commit 前检查 `git status -sb` 和 `git diff --stat`。
3. push 到 GitHub。
4. 如果 push 失败，必须将状态标记为 `BLOCKED` 并记录原因。

### Codex 完成后在聊天窗口中的简短汇报格式

请只简短汇报：

1. `CMD-2026-06-19-002` 当前状态。
2. 新建了哪些目录和文件。
3. 旧文档如何处理。
4. 固定读取规则是否已经改为新结构。
5. 检查命令是否通过。
6. Godot headless 是否通过。
7. 是否已 commit/push。
8. 用户下一步应让 iOS ChatGPT 读取哪些新入口文件。

## 最近命令摘要

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
