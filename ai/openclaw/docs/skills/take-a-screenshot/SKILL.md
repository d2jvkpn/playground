---
name: take-a-screenshot
description: Take a screenshot on Ubuntu GNOME using gnome-screenshot. Use this skill when the user asks to take a screenshot, capture the screen, capture the current window, or capture a specific area by coordinates such as x, y, width, and height. Also use for Chinese requests like 截图, 截屏, 全屏截图, 截取当前窗口, 截取窗口, 截取区域, or 按坐标截图.
metadata:
  {
    "openclaw": {
      "requires": ["gnome-screenshot","imagemagick"],
      "install": {
        "ubuntu":{"apt":["gnome-screenshot","imagemagick"]}
      },
      "entrypoint":"scripts/run.sh",
      "output":"json"
    }
  }

modes:
- fullscreen
- window
- area

area_parameters:
- x
- y
- width
- height
---

# Take a Screenshot
Take a screenshot on Ubuntu GNOME using `gnome-screenshot`.

This skill supports:
- full screen capture
- current window capture
- non-interactive area capture by coordinates

## When to use
Use this skill when the user wants to:
- take a screenshot
- capture the screen
- capture the full screen
- capture the current window
- capture a specific area by coordinates
- 截图
- 截屏
- 全屏截图
- 截取当前窗口
- 截取窗口
- 截取区域
- 按坐标截图

## When not to use
Do not use this skill when the user wants to:
- record the screen
- edit an image beyond simple area cropping
- annotate a screenshot
- capture a webpage using browser tools
- take a screenshot in a headless environment without GNOME access

## Backend
This skill uses:
- `gnome-screenshot` for full screen and current window capture
- ImageMagick (`magick` or `convert`) for coordinate-based area cropping after a full-screen capture

Do not use `grim`, `slurp`, `scrot`, or other screenshot backends.

## Modes

### 1. Full screen
Use when the user asks for:
- screenshot
- take a screenshot
- capture the screen
- full screen screenshot
- 全屏截图
- 截图

Command:
```bash
scripts/run.sh fullscreen
````

### 2. Current window
Use when the user asks for:

* current window
* active window
* screenshot this window
* capture current window
* 截取当前窗口
* 截图当前窗口
* 截取窗口

Command:

```bash
scripts/run.sh window
```

### 3. Area by coordinates
Use when the user provides a rectangular region using:

* x
* y
* width
* height

Examples:

* `x=100 y=200 width=800 height=600`
* `100 200 800 600`
* `从 x=100 y=200 开始，宽 800，高 600`

Command:

```bash
scripts/run.sh area <x> <y> <width> <height>
```

This mode is non-interactive. Do not use `gnome-screenshot -a`.

## Output behavior
Unless the user specifies otherwise:

* save the screenshot under `~/Pictures/`
* use a timestamped filename such as `screenshot.YYYY-MM-DD-%s.png`

Example:

```text
~/Pictures/screenshot.2026-03-10-142530.png
```

## Script entrypoint
Recommended script path:

```text
scripts/run.sh
```

Expected usage:

```bash
scripts/run.sh fullscreen
scripts/run.sh window
scripts/run.sh area <x> <y> <width> <height>
```

## Chat behavior
When this skill is used:

1. infer the mode from the user's request
2. if the request is ambiguous, default to `fullscreen`
3. if the user asks for the current window, use `window`
4. if the user provides coordinates, use `area`
5. return the saved file path after success

## Inference guidance
Map user requests like this:

* "take a screenshot" -> `fullscreen`
* "capture the screen" -> `fullscreen`
* "full screen screenshot" -> `fullscreen`
* "capture the current window" -> `window`
* "screenshot the active window" -> `window`
* "capture area x=100 y=200 width=800 height=600" -> `area 100 200 800 600`
* "截图" -> `fullscreen`
* "全屏截图" -> `fullscreen`
* "截取当前窗口" -> `window`
* "截取区域 x=100 y=200 宽800 高600" -> `area 100 200 800 600`

## Examples of user requests
These should trigger this skill:

* take a screenshot
* capture the screen
* take a full screen screenshot
* capture the current window
* screenshot the active window
* capture area x=100 y=200 width=800 height=600
* 截图
* 截屏
* 全屏截图
* 截取当前窗口
* 截取窗口
* 截取区域 x=100 y=200 宽800 高600
* 按坐标截图

## Guardrails
* Do not claim success unless the screenshot file was actually created
* If `gnome-screenshot` is not installed or not available, report that clearly
* If area mode is requested without valid coordinates, report that clearly
* If ImageMagick is missing for area mode, report that clearly
* Do not fabricate output paths
* Do not pretend screenshots work in a headless session with no graphical environment
* Do not switch to another screenshot backend

## Output contract
The script returns JSON with these fields:
- `code`
- `msg`
- `name`
- `path`

The final assistant response MUST be valid raw JSON only.
Do not add explanation.
Do not add markdown code fences.
Do not add any text before or after the JSON.

If the script succeeds, return the script JSON as-is.
If the script fails, return the script JSON as-is.

Example:
{"code":0,"msg":"Captured area screenshot successfully","name":"screenshot","path":"Pictures/screenshot.2026-03-10-153000.png"}

## Directory layout
```text
take-a-screenshot/
├── SKILL.md
└── scripts/
    └── run.sh
```

## Notes
* This skill is only for screenshots
* Full screen and window capture use `gnome-screenshot`
* Area capture is implemented by taking a full-screen screenshot and cropping it with ImageMagick
* Default mode is full screen if the request is not specific
