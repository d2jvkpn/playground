# Title
---


#### 1. 
```
git worktree add ../project-agent-api -b agent/api
git worktree add ../project-agent-storage -b agent/storage
git worktree add ../project-agent-tests -b agent/testss
```

#### 2. 
```
cd ../project-agent-api
codex

cd ../project-agent-storage
claude

cd ../project-agent-tests
opencode
```

#### 3. 
```
git merge agent/storage
git merge agent/api
git merge agent/tests
```

#### 4. 
- Planner
- Implementer
- Test
- Reviewer
- Integrator

#### 5. 
理解任务 → 探索代码库 → 制定计划 → 修改代码 → 验证 → 审查 → 交付

1. Read       阅读任务和相关代码
2. Search     查找已有模式
3. Plan       制定小范围计划
4. Implement  小步修改
5. Test       运行测试和构建
6. Review     审查最终 diff
7. Report     汇报结果和风险

## 6. Development Workflow

For every development task:

1. Read the task and identify explicit acceptance criteria.
2. Inspect relevant code, tests, configuration, and existing patterns.
3. Check `git status` and establish the current test baseline.
4. Create a concise implementation plan for non-trivial changes.
5. Make the smallest necessary changes.
6. Add or update tests for changed behavior.
7. Run formatting, linting, relevant tests, and the full test suite when practical.
8. Review the final diff for unrelated or accidental changes.
9. Report:
   - what changed
   - files changed
   - tests run
   - unresolved risks or limitations

Do not perform unrelated refactoring unless required by the task.
Do not use destructive Git commands.
