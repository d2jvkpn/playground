#!/usr/bin/env python3
from typing import TypedDict
from langgraph.graph import StateGraph, START, END


class DailyReportState(TypedDict):
    date: str
    orders: dict
    complaints: dict
    inventory_risks: list
    report: str


def load_orders(state: DailyReportState):
    # 模拟订单系统
    return {
        "orders": {
            "total": 1280,
            "pending": 37,
            "delayed": 9,
        }
    }


def load_complaints(state: DailyReportState):
    # 模拟客服系统
    return {
        "complaints": {
            "total": 12,
            "high_risk": 2,
            "main_topics": ["配送延迟", "分量争议"]
        }
    }


def load_inventory_risks(state: DailyReportState):
    # 模拟库存系统
    return {
        "inventory_risks": [
            {"sku": "VEG-001", "name": "土豆", "stock": 30, "threshold": 50},
            {"sku": "MEAT-003", "name": "鸡胸肉", "stock": 15, "threshold": 40},
        ]
    }


def generate_daily_report(state: DailyReportState):
    orders = state["orders"]
    complaints = state["complaints"]
    risks = state["inventory_risks"]

    risk_lines = "\n".join([
        f"- {item['name']}：当前 {item['stock']}，安全线 {item['threshold']}"
        for item in risks
    ])

    report = f"""
# {state['date']} 经营日报

## 订单情况
- 总订单数：{orders['total']}
- 待处理订单：{orders['pending']}
- 延迟订单：{orders['delayed']}

## 客诉情况
- 客诉总数：{complaints['total']}
- 高风险客诉：{complaints['high_risk']}
- 主要问题：{", ".join(complaints['main_topics'])}

## 库存风险
{risk_lines}

## 建议
1. 优先处理延迟订单。
2. 高风险客诉建议人工跟进。
3. 土豆、鸡胸肉需要尽快补货。
""".strip()

    return {"report": report}


builder = StateGraph(DailyReportState)

builder.add_node("load_orders", load_orders)
builder.add_node("load_complaints", load_complaints)
builder.add_node("load_inventory_risks", load_inventory_risks)
builder.add_node("generate_daily_report", generate_daily_report)

builder.add_edge(START, "load_orders")
builder.add_edge("load_orders", "load_complaints")
builder.add_edge("load_complaints", "load_inventory_risks")
builder.add_edge("load_inventory_risks", "generate_daily_report")
builder.add_edge("generate_daily_report", END)

daily_report_graph = builder.compile()

result = daily_report_graph.invoke({
    "date": "2026-06-18",
    "orders": {},
    "complaints": {},
    "inventory_risks": [],
    "report": "",
})

print(result["report"])
