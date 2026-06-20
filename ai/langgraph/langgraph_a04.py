#!/usr/bin/env python3
from typing import TypedDict
from langgraph.graph import StateGraph, START, END
from langgraph.types import interrupt, Command
from langgraph.checkpoint.memory import InMemorySaver


class EmailState(TypedDict):
    customer_name: str
    issue: str
    draft: str
    approved: bool
    final_status: str


def draft_email(state: EmailState):
    draft = (
        f"{state['customer_name']} 您好，\n\n"
        f"关于您反馈的「{state['issue']}」，我们已经收到。"
        f"我们会在今天内完成初步排查，并给您更新处理进度。\n\n"
        f"谢谢。"
    )
    return {"draft": draft}


def human_approval(state: EmailState):
    decision = interrupt({
        "message": "请审核邮件草稿",
        "draft": state["draft"],
        "options": ["approve", "reject"]
    })

    if decision == "approve":
        return {"approved": True}
    else:
        return {"approved": False}


def send_or_cancel(state: EmailState):
    if state["approved"]:
        # 真实项目里这里才调用 Gmail / SMTP / CRM API
        return {"final_status": "邮件已发送"}
    else:
        return {"final_status": "邮件未发送，等待人工修改"}


builder = StateGraph(EmailState)

builder.add_node("draft_email", draft_email)
builder.add_node("human_approval", human_approval)
builder.add_node("send_or_cancel", send_or_cancel)

builder.add_edge(START, "draft_email")
builder.add_edge("draft_email", "human_approval")
builder.add_edge("human_approval", "send_or_cancel")
builder.add_edge("send_or_cancel", END)

checkpointer = InMemorySaver()
graph = builder.compile(checkpointer=checkpointer)

config = {
    "configurable": {
        "thread_id": "email-thread-001"
    }
}

# 第一次运行：会停在 interrupt
first_result = graph.invoke({
    "customer_name": "吴总",
    "issue": "订单排产延迟",
    "draft": "",
    "approved": False,
    "final_status": "",
}, config=config)

print(first_result)
