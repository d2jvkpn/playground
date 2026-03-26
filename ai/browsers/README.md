# Title
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. browser-use
- https://github.com/browser-use/browser-use

2. lightpanda
- https://github.com/lightpanda-io/browser

3. playwright-mcp
- https://github.com/microsoft/playwright-mcp
```
npm install -g playwright @playwright/mcp@latest @playwright/test
npx playwright install chromium
```

4. agent-browser
- https://github.com/vercel-labs/agent-browser
```
npm install -g agent-browser
agent-browser install --with-deps
```

5. chrome-devtools-mcp
- https://github.com/ChromeDevTools/chrome-devtools-mcp
```
npm install -g chrome-devtools-mcp@latest

npx chrome-devtools-mcp@latest --browser-url=http://host_ip:9222
```

```
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": [
        "-y",
        "chrome-devtools-mcp@latest",
        "--browser-url=http://172.17.0.1:9222",
        "--no-performance-crux",
        "--no-usage-statistics"
      ]
    }
  }
}
```
