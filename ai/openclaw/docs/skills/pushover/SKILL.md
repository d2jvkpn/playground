---
name: pushover_notify
description: 使用 Pushover 发送简短通知到用户设备。适合在任务完成、关键失败、需要用户注意时推送提醒。
allowed-tools:
  - Bash
---

# Pushover Notify

## 用途

当需要把一条**简短、明确、值得打断用户**的消息推送到用户手机或桌面设备时，使用此 skill。

适用场景：
- 长任务完成
- 关键步骤失败
- 外部操作成功或异常
- 需要用户尽快注意的提醒

不适用场景：
- 普通聊天回复
- 冗长总结
- 高频、重复、低价值通知
- 包含大量敏感信息的内容

## 行为规则

调用此 skill 时，应生成两段内容并传给脚本：

- `title`：通知标题，尽量简短，建议不超过 60 个字符
- `message`：通知正文，1～3 句，建议不超过 200 个字符

通知内容要求：
1. 简洁直接，先说结果，再说必要上下文。
2. 只保留最重要的信息，不要粘贴长日志。
3. 不要包含密钥、令牌、密码、Cookie、完整报文等敏感信息。
4. 若是失败通知，应写明失败点和下一步建议。
5. 若是成功通知，应写明“什么事完成了”。

## 何时使用

以下情况**优先考虑**发送 Pushover 通知：
- 用户明确要求“完成后提醒我”“推送到手机”“发通知”
- 执行耗时较长的任务，且结果已经产生
- 任务在无人值守场景下运行，需要把结果主动通知用户
- 发生关键错误，用户可能不会一直盯着终端

以下情况**不要使用**：
- 用户没有要求通知，且任务很短
- 同一轮操作里频繁多次通知
- 只是普通中间进度
- 信息价值不高，例如“开始执行了”“还在执行”

## 输入模板

生成通知时，使用以下风格：

### 成功类
- title: `任务完成`
- message: `XX 已完成。结果已生成到 XX。`

### 失败类
- title: `任务失败`
- message: `XX 在 YY 步骤失败。请检查 ZZ。`

### 需关注类
- title: `需要确认`
- message: `XX 已准备好，但需要你确认 YY。`

## 执行方式

本 skill 通过以下脚本发送通知：

- `scripts/run.sh`

脚本依赖：
- `curl`
- `yq`

配置文件默认路径：

- `~/.config/pushover_notify/local.yaml`

也可通过环境变量覆盖：

- `config_yaml`
- `yq_bin`
- `curl_bin`

## 配置文件格式

配置文件示例：

```yaml
pushover:
  app_token: "YOUR_APP_TOKEN"
  user_key: "YOUR_USER_KEY"
  device: "iphone"   # 可选
````

字段说明：

* `pushover.app_token`：Pushover application token
* `pushover.user_key`：Pushover user key
* `pushover.device`：可选，指定推送到某个设备

## 调用约定

在调用 `scripts/run.sh` 前，需将 `title` 和 `message` 作为环境变量传入。

示例：

```bash
title="任务完成" \
message="日报已生成，并保存到 /tmp/report.md" \
scripts/run.sh
```

由于脚本内部最终执行的是：

```bash
send_pushover "OpenClaw: $title" "$message"
```

因此：

* 实际收到的标题会自动带上前缀 `OpenClaw: `
* 传入的 `title` 不需要再重复写 `OpenClaw`

## 输出与失败处理

正常情况下：

* 脚本退出码为 0
* stderr 会输出：

  * `[pushover] pushover sent notification`

如果缺少配置：

* 脚本会输出：

  * `[pushover] pushover credentials missing in ...; skipping notification`
* 并返回非 0

处理原则：

1. 若通知发送失败，不应影响主任务结果的真实性判断。
2. 可以在主回复中提一句“通知发送失败”，但不要伪称已通知成功。
3. 不要因为通知失败而重复重试很多次，避免骚扰。

## 内容风格建议

推荐：

* `任务完成`
* `抓取完成，共 42 条记录，结果已写入 output.json`
* `部署失败，卡在镜像拉取阶段，请检查 registry 凭证`

不推荐：

* `你好呀这是一个超级详细的通知`
* 粘贴整段日志
* 把机密配置发到通知里
* 高频刷屏式提醒

## 安全注意事项

绝不要在通知中发送以下信息：

* API key
* access token
* 密码
* 会话 cookie
* 私人地址、手机号、身份证号
* 大段原始错误堆栈

如需提醒错误，只发送：

* 错误摘要
* 失败步骤
* 建议检查项

## 典型使用示例

### 示例 1：任务完成

* title: `任务完成`
* message: `供应商名单整理完成，结果已保存到 data/suppliers.csv。`

### 示例 2：关键失败

* title: `任务失败`
* message: `企查查抓取在登录阶段失败，请检查 cookie 是否过期。`

### 示例 3：等待用户处理

* title: `需要确认`
* message: `合同草稿已生成，请审阅第 3 条付款条款。`

## 给代理的最终指令

当且仅当这条通知值得主动打断用户时，调用本 skill。

输出通知时：

* 标题短
* 正文更短
* 结果优先
* 不泄露敏感信息
* 不刷屏
