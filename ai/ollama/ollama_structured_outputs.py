#!/usr/bin/env python3
# https://docs.ollama.com/capabilities/structured-outputs#python-2
from typing import Optional

from ollama import chat
from pydantic import BaseModel, Field


class Country(BaseModel):
    name: str = "Foo"
    capital: str
    languages: list[str]

class Item(BaseModel):
    name: Optional[str] = Field("Foo", description="商品名称", example="Foo")
    price: float = Field(..., gt=0, description="价格必须大于零", example=35.4)

response = chat(
    model='gpt-oss',
    messages=[{'role': 'user', 'content': 'Tell me about Canada.'}],
    format=Country.model_json_schema(),
)

country = Country.model_validate_json(response.message.content)
print(country)
