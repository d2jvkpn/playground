#!/usr/bin/env python3
from ollama import Client as OllamaClient
import weaviate
import weaviate.classes as wvc
from weaviate.classes.config import Property, DataType


ollama = OllamaClient(host='http://127.0.0.1:11434')
client = weaviate.connect_to_local(host='localhost', port=8080, grpc_port=50051)
# additional_headers={"X-API-KEY":"my-dev-key"}

documents = [
    "Llamas are members of the camelid family meaning they're pretty closely related to vicuñas and camels",
    "Llamas were first domesticated and used as pack animals 4,000 to 5,000 years ago in the Peruvian highlands",
    "Llamas can grow as much as 6 feet tall though the average llama between 5 feet 6 inches and 5 feet 9 inches tall",
    "Llamas weigh between 280 and 450 pounds and can carry 25 to 30 percent of their body weight",
    "Llamas are vegetarians and have very efficient digestive systems",
    "Llamas live to be about 20 years old, though some only live for 15 years and others live to be 30 years old",
]

collection = client.collections.create(
    name = "docs", # Name of the data collection
    properties=[
        Property(name="text", data_type=DataType.TEXT), # Name and data type of the property
    ],
)

# Store each document in a vector embedding database
with collection.batch.fixed_size(batch_size=200) as batch:
    for i, d in enumerate(documents): # Generate embeddings
        response = ollama.embeddings(model = "all-minilm", prompt = d)

    # doc_id, chunk_index, chunk_hash, source, page, tags
    props = { "text" : d }
    # Add data object with text and embedding
    batch.add_object(properties = props, vector = response["embedding"])

# An example prompt
prompt = "What animals are llamas related to?"

# Generate an embedding for the prompt and retrieve the most relevant doc
response = ollama.embeddings(model = "all-minilm", prompt = prompt)
results = collection.query.near_vector(near_vector = response["embedding"], limit = 1)
data = results.objects[0].properties['text']
