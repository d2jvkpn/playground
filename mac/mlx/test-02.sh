#!/usr/bin/env python3

curl -s \
  http://192.168.1.3:11234/tokenize \
  -H 'Content-Type: application/json' \
  -d '{"content": "The quick brown fox jumps over the lazy dog. "}' |
  jq '.tokens | length'

# 11

python3 - <<'PY'
import json

sentence = "The quick brown fox jumps over the lazy dog. "

#targets = {
#    "100k": 9091,
#    "128k": 11636,
#    "150k": 13636,
#}

targets = {
    "100k": 10000,
    "128k": 12800,
    "150k": 14500,
}

for name, n in targets.items():
    text = sentence * n

    req = {
        "model": "mlx-community/Qwen3.6-35B-A3B-8bit",
        "input": f"{n} {text}\nReply exactly: OK",
        "max_output_tokens": 2,
        "temperature": 0
    }

    path = f"data/request{name}.json"
    with open(path, "w") as f:
        json.dump(req, f)

    print(name, n, "repetitions,", n * 11, "tokens")
PY


time curl -s http://192.168.1.3:11234/v1/responses \
  -H 'Content-Type: application/json' --data-binary @data/request100k.json

#{"id":"resp_1790902059127_0","object":"response","created_at":1790902095,"completed_at":1790902095,"status":"completed","incomplete_details":null,"model":"mlx-community/Qwen3.6-35B-A3B-8bit","previous_response_id":null,"instructions":null,"output":[{"type":"message","id":"msg_1790902095283_1","role":"assistant","status":"completed","content":[{"type":"output_text","text":"OK","annotations":[]}]}],"error":null,"tools":[],"tool_choice":"auto","truncation":"disabled","parallel_tool_calls":true,"text":{"format":{"type":"text"}},"top_p":0.95,"presence_penalty":0,"frequency_penalty":0,"top_logprobs":0,"temperature":0,"reasoning":{"effort":null,"summary":null},"usage":{"input_tokens":100022,"output_tokens":1,"total_tokens":100023,"input_tokens_details":{"cached_tokens":0},"output_tokens_details":{"reasoning_tokens":0}},"max_output_tokens":2,"max_tool_calls":null,"store":true,"background":false,"service_tier":"default","metadata":{},"safety_identifier":null,"prompt_cache_key":null,"timings":{"prompt_n":100022,"cached_n":0,"prompt_ms":36084.989,"prompt_per_second":2771.845,"predicted_n":1,"predicted_ms":14.543,"predicted_per_second":68.763,"tokenize_ms":25.723}}
#real	0m41.103s
#user	0m0.007s
#sys	0m0.016s


time curl -s http://192.168.1.3:11234/v1/responses \
  -H 'Content-Type: application/json' --data-binary @data/request128k.json

#{"id":"resp_1790902140535_2","object":"response","created_at":1790902194,"completed_at":1790902194,"status":"completed","incomplete_details":null,"model":"mlx-community/Qwen3.6-35B-A3B-8bit","previous_response_id":null,"instructions":null,"output":[{"type":"message","id":"msg_1790902194015_3","role":"assistant","status":"completed","content":[{"type":"output_text","text":"OK","annotations":[]}]}],"error":null,"tools":[],"tool_choice":"auto","truncation":"disabled","parallel_tool_calls":true,"text":{"format":{"type":"text"}},"top_p":0.95,"presence_penalty":0,"frequency_penalty":0,"top_logprobs":0,"temperature":0,"reasoning":{"effort":null,"summary":null},"usage":{"input_tokens":128022,"output_tokens":1,"total_tokens":128023,"input_tokens_details":{"cached_tokens":0},"output_tokens_details":{"reasoning_tokens":0}},"max_output_tokens":2,"max_tool_calls":null,"store":true,"background":false,"service_tier":"default","metadata":{},"safety_identifier":null,"prompt_cache_key":null,"timings":{"prompt_n":128022,"cached_n":0,"prompt_ms":53409.152,"prompt_per_second":2397.005,"predicted_n":1,"predicted_ms":14.294,"predicted_per_second":69.960,"tokenize_ms":62.994}}
#real	0m53.729s
#user	0m0.010s
#sys	0m0.016


time curl -s http://192.168.1.3:11234/v1/responses \
  -H 'Content-Type: application/json' --data-binary @data/request150k.json

#{"id":"resp_1790902463216_0","object":"response","created_at":1790902528,"completed_at":1790902528,"status":"completed","incomplete_details":null,"model":"mlx-community/Qwen3.6-35B-A3B-8bit","previous_response_id":null,"instructions":null,"output":[{"type":"message","id":"msg_1790902528685_1","role":"assistant","status":"completed","content":[{"type":"output_text","text":"OK","annotations":[]}]}],"error":null,"tools":[],"tool_choice":"auto","truncation":"disabled","parallel_tool_calls":true,"text":{"format":{"type":"text"}},"top_p":0.95,"presence_penalty":0,"frequency_penalty":0,"top_logprobs":0,"temperature":0,"reasoning":{"effort":null,"summary":null},"usage":{"input_tokens":145022,"output_tokens":1,"total_tokens":145023,"input_tokens_details":{"cached_tokens":0},"output_tokens_details":{"reasoning_tokens":0}},"max_output_tokens":2,"max_tool_calls":null,"store":true,"background":false,"service_tier":"default","metadata":{},"safety_identifier":null,"prompt_cache_key":null,"timings":{"prompt_n":145022,"cached_n":0,"prompt_ms":65395.284,"prompt_per_second":2217.622,"predicted_n":1,"predicted_ms":16.503,"predicted_per_second":60.594,"tokenize_ms":36.710}}
#real	1m10.516s
#user	0m0.011s
#sys	0m0.015s
