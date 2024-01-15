### Golang a03 Memory
---

#### 1. Golang 的 GC 原理
1. 三色标记
2. 当一个变量不再被引用时，执行 GC
3. Golang 启动单独的 goroutine 执行 GC, 减少 Stop The World 的现象
