#### 1. install playwright
```bash
apt -y install imagemagick ffmpeg net-tools xvfb fonts-noto-cjk

export PLAYWRIGHT_BROWSERS_PATH=/opt/ms-playwright

npm install -g playwright@latest "@playwright/cli@latest" \
  "@playwright/mcp@latest" chrome-devtools-mcp@latest

mkdir -p "${PLAYWRIGHT_BROWSERS_PATH}"
playwright install --with-deps chromium
chmod -R a+rX "${PLAYWRIGHT_BROWSERS_PATH}"

playwright install --with-deps chromium
#playwright install --with-deps chrome
#mv /root/.cache/ms-playwright /opt/ms-playwright

rm -rf ~/.cache ~/.npm /var/lib/apt/lists/*
npm cache clean --force
mkdir -p ~/.cache

playwright --version
playwright install --list

#@appuser
#playwright-cli install --skills
```

#### 2. docker
docker run -d \
  --name playwright-mcp \
  --init \
  -p 8931:8931 \
  --entrypoint node \
  mcr.microsoft.com/playwright/mcp \
  /app/cli.js \
  --headless \
  --browser chromium \
  --no-sandbox \
  --port 8931 \
  --host 0.0.0.0

#### 3. mcp servers
1. playwright
```json
{
  "mcpServers": {
    "playwright": { "url": "http://playwright-mcp:8931/mcp" }
  }
}
```

2. chrome-devtools
```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": [ "-y", "chrome-devtools-mcp@latest", "--headless" ]
    }
  }
}
```
