#!/usr/bin/env python3
from typing import TypedDict, Literal
from langgraph.graph import StateGraph, START, END


class InventoryState(TypedDict):
    sku: str
    current_stock: int
    threshold: int
    risk_level: str
    action: str


def check_stock(state: InventoryState):
    if state["current_stock"] < state["threshold"]:
        return {"risk_level": "high"}
    else:
        return {"risk_level": "normal"}


def decide_next(state: InventoryState) -> Literal["alert", "archive"]:
    if state["risk_level"] == "high":
        return "alert"
    return "archive"


def alert(state: InventoryState):
    return {
        "action": f"SKU {state['sku']} 库存不足，需要补货"
    }


def archive(state: InventoryState):
    return {
        "action": f"SKU {state['sku']} 库存正常，无需处理"
    }


builder = StateGraph(InventoryState)

builder.add_node("check_stock", check_stock)
builder.add_node("alert", alert)
builder.add_node("archive", archive)

builder.add_edge(START, "check_stock")

builder.add_conditional_edges(
    "check_stock",
    decide_next,
    {
        "alert": "alert",
        "archive": "archive",
    }
)

builder.add_edge("alert", END)
builder.add_edge("archive", END)

graph = builder.compile()

print(graph.invoke({
    "sku": "VEG-001",
    "current_stock": 30,
    "threshold": 50,
    "risk_level": "",
    "action": "",
}))
