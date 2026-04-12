# OpenClaw Channel: Matrix
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```

#### ch01. 
1. docs

2. interactive config
- Matrix homeserver URL: https://matrix.example.com
- Enable end-to-end encryption (E2EE)?: Yes
- Configure Matrix rooms access? Yes
- Matrix rooms access: Allowlist (recommended)
- Matrix rooms allowlist (comma-separated): !roomId:matrix.example.com, #alias:server, Project Room
- Matrix invite auto-join: Allowlist (recommended)
- Matrix invite auto-join allowlist (comma-separated): !roomId:matrix.example.com

2. json config
```
{
  "channels": {
    "matrix": {
      "enabled": true,
      "homeserver": "https://matrix.example.com",
      "userId": "@<user_id>:matrix.example.com",
      "password": "<password>",
      "deviceName": "OpenClaw Gateway",
      "encryption": true,
      "groupPolicy": "allowlist",
      "autoJoin": "allowlist",
      "autoJoinAllowlist": [
        "!room_id:matrix.example.com"
      ],
      "groups": {
        "!room_id:matrix.example.com": {
          "enabled": true
        }
      }
    }
  }
}
```

3. pairing
- matrix chat: send a message to the bot account
- matrix message
```
OpenClaw: access not configured.

Your Matrix user id: <user_id>
Pairing code:
>>> <Pairing_Code>

Ask the bot owner to approve with:
>>> openclaw pairing approve matrix <paring_code>
```

- openclaw command
```
openclaw pairing approve matrix <paring_code>
```
