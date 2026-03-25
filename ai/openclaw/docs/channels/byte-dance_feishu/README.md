# OpenClaw Channel: bytedance feishu
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
1. docs
- https://open.feishu.cn
- https://open.feishu.cn/document/server-docs/event-subscription-guide/event-subscription-configure-/request-url-configuration-case
- https://www.feishu.cn/content/article/7602519239445974205
- 开发者后台 - 权限管理: https://open.feishu.cn/app/<APP_ID>/baseinfo: 权限管理、事件回调、
- 开发者后台 - API 调试: https://open.feishu.cn/api-explorer/<APP_ID>
- Openclaw多Agent实践
  https://leochens.feishu.cn/wiki/TWyZwzJwAimqcMkpL7sce6zwneh
- 7分钟上手OpenClaw接入飞书
  https://www.bilibili.com/video/BV1puFLzaEGT
-【保姆级】OpenClaw 全网最细教学：安装→Skills实战→多Agent协作，1 小时全精通！
   https://www.youtube.com/watch?v=2ZZCyHzo9as
- 【闪客】名词诈骗！一口气拆穿Skill/MCP/RAG/Agent/OpenClaw底层逻辑
  https://www.youtube.com/watch?v=O9b8tLXCTYU
- 【保姆级】OpenClaw进阶全攻略：高级玩法+飞书+Skills+安全防护，1 小时变身“养虾高手”！
   https://www.bilibili.com/video/BV1uxcfzeEEu
- 飞书 OpenClaw https://docs.openclaw.ai/channels/feishu

2. open.feishu.cn 创建企业自建应用 https://open.feishu.cn/app?lang=zh-CN

3. open.feishu.cn 添加应用能力 https://open.feishu.cn/app/<APP_ID>/capability
- 机器人

3. open.feishu.cn 权限管理 https://open.feishu.cn/app/<APP_SECRET>/auth
参考 https://docs.openclaw.ai/channels/feishu，批量导入权限
```
{
  "scopes": {
    "tenant": [
      "aily:file:read",
      "aily:file:write",
      "application:application.app_message_stats.overview:readonly",
      "application:application:self_manage",
      "application:bot.menu:write",
      "cardkit:card:read",
      "cardkit:card:write",
      "contact:user.employee_id:readonly",
      "corehr:file:download",
      "event:ip_list",
      "im:chat.access_event.bot_p2p_chat:read",
      "im:chat.members:bot_access",
      "im:message",
      "im:message.group_at_msg:readonly",
      "im:message.p2p_msg:readonly",
      "im:message:readonly",
      "im:message:send_as_bot",
      "im:resource"
    ],
    "user": [
      "aily:file:read",
      "aily:file:write",
      "im:chat.access_event.bot_p2p_chat:read"
    ]
  }
}
```

开通权限
- contact:contact.base:readonly
- im:message.group_msg
- im:message.group_msg:get_as_user

4. open.feishu.cn 事件与回调 https://open.feishu.cn/app/<APP_SECRET>/event
- 配置事件/订阅方式: 使用长连接接收事件
- 添加事件/消息语群组
  - im.chat.access_event.bot_p2p_chat_entered_v1
  - im.message.message_read_v1
  - im.message.receive_v1
  - ...

5. open.feishu.cn 版本管理与发布 https://open.feishu.cn/app/cli_a22bc39f27a2900c/version

6. openclaw set channels
- openclaw channels add
- openclaw pairing approve feishu <code>
- openclaw config unset channels.feishu
- openclaw config set channels.feishu.enabled true
- openclaw config set channels.feishu.appId "AppID"
- openclaw config set channels.feishu.appSecret "AppSecret"

- openclaw-cli channels add --channel discord --token "<token>"

6. openclaw check
```
openclaw plugins list
openclaw channels list --json
openclaw agents bindings --json
```
