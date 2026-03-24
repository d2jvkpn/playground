# Title
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. docs
- ClawHub, the skill dock for sharp agents.
  https://clawhub.ai
- 3 Tools That Make OpenClaw Actually Useful
  https://www.youtube.com/watch?v=QvfqAMUJTT4
- OpenClaw + Agent Browser：省 93% 上下文的浏览器方案
  https://www.youtube.com/watch?v=uPTkxwwy-4I
- OpenClaw 你装错了！9个必备Skills + 正确模型搭配，一次搞定浏览器自动化！ | 零度解说
  https://www.youtube.com/watch?v=Sdf8fc9b0mI
- https://github.com/openclaw/openclaw
- https://github.com/openclaw/clawhub
- https://github.com/openclaw/skills

2. installation
- path: ~/.openclaw/skills, ~/.openclaw/<workspace>/skills
- openclaw skills list
  openclaw skills search find-skills
  openclaw skills install find-skills
- clawhub list
  clawhub install find-skills

3. structure
- ~/.openclaw/skills/my_skill
- ~/.openclaw/<workspace>/skills/my_skill
- 
```
.agents/
  skills/
    my-skill/
      SKILL.md
      scripts/
      examples/
    another-skill/
      SKILL.md
```

4. clawhub skills
install: clawhub --workdir ~/.openclaw install self-improving-agent

items
```
- name: self-improving-agent
  links:
  - https://clawhub.ai/pskoett/self-improving-agent
- name: ontology
  links:
  - https://clawhub.ai/oswalpalash/ontology
- name: summarize
  links:
  - https://clawhub.ai/steipete/summarize
- name: find-skills
  links:
  - https://clawhub.ai/JimLiuxinghai/find-skills
- gog

- name: QMD
  links:
  - https://clawhub.ai/steipete/qmd
- name: Agent Browser
  links:
  - https://clawhub.ai/TheSethRose/agent-browser
- name: GOG
  links:
  - https://clawhub.ai/steipete/gog
- name: Vetter
  links:
  - https://clawhub.ai/spclaudehome/skill-vetter
```
