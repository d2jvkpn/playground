# Title
---


#### 1. 
git diff | delta --side-by-side

```
# ~/.gitconfig

[core]
    pager = delta

[interactive]
    diffFilter = delta --color-only

[delta]
    side-by-side = true
    line-numbers = true
    navigate = true
```
