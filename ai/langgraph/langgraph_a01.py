#!/usr/bin/env python3
from typing import TypedDict
from langgraph.graph import StateGraph, START, END


class State(TypedDict):
    user_input: str
    result: str


def analyze(state: State):
    text = state["user_input"]
    return {
        "result": f"已分析：{text}"
    }


builder = StateGraph(State)

builder.add_node("analyze", analyze)

builder.add_edge(START, "analyze")
builder.add_edge("analyze", END)

graph = builder.compile()

output = graph.invoke({
    "user_input": "检查今天的订单异常"
})

print(output)
