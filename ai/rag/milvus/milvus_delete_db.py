#!/usr/bin/env python3
import os

from pymilvus import MilvusClient

db_name = os.sys.argv[1]

milvus_uri = os.environ.get("milvus_uri", "http://127.0.0.1:19530")
print("milvus_uri:", milvus_uri)

client = MilvusClient(
    uri=milvus_uri,
    db_name=db_name,
)

# 先删除所有 collection
for coll in client.list_collections():
    client.drop_collection(collection_name=coll)
    print("dropped collection:", coll)

# 再连接 default 或重新创建 client 删除 db
admin = MilvusClient(uri=milvus_uri)
admin.drop_database(db_name=db_name)
