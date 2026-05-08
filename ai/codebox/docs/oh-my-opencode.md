# Title
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. docs
1) oh-my-opencode（oho）到底是什么
= 它本质是 opencode 的“配置+提示词（skills/agents）增强包”：帮你预设一组 agents（比如 Sisyphus/Hephaestus/Prometheus/Atlas），并把它们映射到常见工作流：计划/实现/评审/整理。
- 它不替代 opencode：opencode 仍然负责会话、工具调用、项目读写等；oho 主要负责“你怎么用更顺”。

2) 你在界面里看到那 4 个 Agent 是干嘛的（常见约定）
- 不同版本命名可能略有差异，但一般是这样的分工（你可以当成“默认 SOP”）：
- Sisyphus（Plan/Architect）：拆需求、定方案、列任务清单、风险点、接口/数据结构。
- Hephaestus（Builder/Coder）：写代码、改代码、跑通、补测试、修 bug。
- Prometheus（Reviewer/QA）：挑毛病、找边界条件、审安全/性能、提重构建议。
- Atlas（Librarian/Doc）：写 README/变更说明/ADR/使用指南，把项目“可交付化”。

你可以把它理解成：先 Sisyphus 出施工图 → Hephaestus 干活 → Prometheus 验收 → Atlas 写交付文档。

3) 最常用的工作流（强烈建议你就这么用）
A. 新功能/新模块（从 0 到 1）
- Sisyphus：把需求变成任务（含目录结构、接口、依赖、测试策略）。
- Hephaestus：按任务逐项实现（一次只做一小块，容易回滚）。
- Prometheus：做 code review（尤其是边界、异常、并发、权限、注入）。
- Atlas：补齐 README、配置说明、运行方式、FAQ。

B. 修 bug（从现象到修复）
- Prometheus：先做“定位计划”（复现步骤、可能原因、最小修复面）。
- Hephaestus：实现修复 + 回归测试。
- Atlas：写变更记录（为什么、怎么修、如何验证）。

C. 代码库“接手/熟悉”
- Atlas：让它先产出“项目导览”：入口、模块边界、关键脚本、运行方式。
- Sisyphus：输出一张“改动影响图”（改哪里会影响哪里）。
- 再开始写代码。

2. prompts
- ultrawork TASK: ... EXPECTED: ... CONTEXT: ... MUST DO: ... MUST NOT DO: ... VERIFY: ...
3. command
- /start-work
4. references
- https://github.com/code-yeongyu/oh-my-opencode/blob/dev/docs/reference/features.md
