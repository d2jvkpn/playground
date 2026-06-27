# hello-demo

A minimal OpenFang Python demo skill.

## Tools

### hello_user

Input:

```json
{
  "tool": "hello_user",
  "input": {
    "name": "Leonard",
    "language": "zh"
  }
}
```

Test:

```bash
echo '{"tool":"hello_user","input":{"name":"Leonard","language":"zh"}}' | ./src/main.py
```

### add_numbers

Input:

```json
{
  "tool": "add_numbers",
  "input": {
    "a": 3,
    "b": 5
  }
}
```

Test:

```bash
echo '{"tool":"add_numbers","input":{"a":3,"b":5}}' | ./src/main.py
```

## Install

```bash
openfang skill install ./hello-demo
openfang skill list
```

## Example agent.toml

```toml
name = "demo-agent"
version = "0.1.0"
description = "Demo agent using hello-demo skill"
author = "local"
module = "builtin:chat"

skills = ["hello-demo"]

[model]
provider = "groq"
model = "llama-3.3-70b-versatile"

[capabilities]
tools = ["hello_user", "add_numbers"]
memory_read = ["*"]
memory_write = ["self.*"]
```

Start:

```bash
openfang agent spawn ~/.openfang/agents/demo-agent/agent.toml
```
