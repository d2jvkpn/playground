#!/usr/bin/env python3

from pymilvus import MilvusClient, DataType

client = MilvusClient(uri="http://localhost:19530")

collection_name = "demo_docs"

# 如果已存在可先删掉
if client.has_collection(collection_name):
    client.drop_collection(collection_name)

schema = client.create_schema(auto_id=False, enable_dynamic_field=True)
schema.add_field(field_name="id", datatype=DataType.INT64, is_primary=True)
schema.add_field(field_name="text", datatype=DataType.VARCHAR, max_length=2000)
schema.add_field(field_name="source", datatype=DataType.VARCHAR, max_length=256)
schema.add_field(field_name="vector", datatype=DataType.FLOAT_VECTOR, dim=4)

index_params = client.prepare_index_params()
index_params.add_index(
    field_name="vector",
    index_type="AUTOINDEX",
    metric_type="COSINE"
)

client.create_collection(
    collection_name=collection_name,
    schema=schema,
    index_params=index_params
)

data = [
    {"id": 1, "text": "black walnut veneer premium grade", "source": "sheet_a", "vector": [0.12, 0.31, 0.44, 0.91]},
    {"id": 2, "text": "white oak straight grain", "source": "sheet_a", "vector": [0.11, 0.29, 0.40, 0.88]},
    {"id": 3, "text": "teak natural light tone", "source": "sheet_b", "vector": [0.80, 0.10, 0.21, 0.05]},
]

client.insert(collection_name=collection_name, data=data)

results = client.search(
    collection_name=collection_name,
    data=[[0.10, 0.30, 0.42, 0.90]],
    limit=2,
    output_fields=["text", "source"]
)

for hit in results[0]:
    print(hit)
