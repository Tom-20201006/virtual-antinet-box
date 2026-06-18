# DEVELOPMENT_LOG

## 2026-06-17

### 创建内容

- 在空 Godot 4.6 项目中创建 VirtualAntinetBox 功能性 Demo。
- 设置 `project.godot` 主场景为 `res://scenes/Main.tscn`。
- 新增 `scenes/` 下的主场景与组件场景骨架。
- 新增 `scripts/` 下的核心 GDScript。
- 新增 `docs/` 文档和项目根文档。
- 新增 `user_data/world_state.json` 作为项目内状态结构占位说明。

### 主要实现

- 程序化生成桌面、区域标识、卡片盒、抽屉、卡片、分隔片。
- 卡片和抽屉使用 `VisualRoot` 与 `CollisionRoot` 分离外观和碰撞。
- 交互逻辑通过 `InteractionController.gd` 统一处理。
- 摄像机通过 `CameraController.gd` 支持旋转、平移、缩放、总览、抽屉视角和聚焦。
- 保存系统只写入物理状态和资源路径。

### 当前限制

- 几何体模型较简洁，没有真实滑轨、木纹、纸张弯曲或手部模型。
- 抽屉内卡片使用简化吸附排列。
- 图片导入只支持正面贴图；背面图片字段已在状态结构中保留，但当前 UI 未提供单独选择背面图片。
- 大量卡片优化目前是基础结构和策略，不是 20000 张卡片的完整生产级实现。

### 验证记录

已使用 Godot 4.6.3 控制台执行头less 加载和 1 秒主场景运行，脚本解析和初始化通过。
