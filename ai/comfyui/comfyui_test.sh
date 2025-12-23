#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#### 1. 
addr=$(yq .address configs/local.yaml)
workflow=$1

echo "==> comfyui_test.sh: addr=${addr}, workflow=${workflow}"
mkdir -p data

ws_addr=$(echo $addr | sed 's/^http:/ws:/; s/^https:/wss:/')
# jq '{prompt: .}' data/workflows/exported.api.json > data/workflows/workflow.json

#### 2. 
prompt=$(curl -X POST "$addr/prompt" -H "Content-Type: application/json" -d "@$workflow")
# {"prompt_id": "c482ff09-989a-41e8-9e6c-e8b4eb42b9c8", "number": 11, "node_errors": {}}

prompt_id=$(echo $prompt | jq -r '.prompt_id')
echo "--> prompt_id: $prompt_id"
echo "$prompt" | jq > data/$prompt_id.prompt.json
echo "--> saved data/$prompt_id.prompt.json"

#### 3. 
status=""
while true; do
    curl "$addr/history/$prompt_id" 2> /dev/null | jq > data/$prompt_id.execution.json
    status=$(jq -r '."'$prompt_id'".status.status_str' data/$prompt_id.execution.json)
    if [[ "$status" == "null" ]]; then
        echo -n "."
        sleep 1
        continue
    fi
    echo "."
    break
    echo "--> status: $status"
    echo "--> saved data/$prompt_id.execution.json"
done

if [[ "$status" == "success" ]]; then
    jq -r '."'$prompt_id'".outputs' data/$prompt_id.execution.json > data/$prompt_id.outputs.json
    echo "--> saved data/$prompt_id.outputs.json"
fi

#jq '."'$prompt_id'".prompt' data/$prompt_id.execution.json | jq '[.[] | select(type=="object")]'
#jq '[.[] | select((type=="object") and has("status"))]'


echo "<== exit"

####
exit
npm i -g wscat
wscat -c "$ws_addr/ws"

exit
curl "$addr/queue"
curl "$addr/history/$prompt_id" | jq  > data/history.json

jq '."'$prompt_id'".prompt | length' data/history.json

curl -L \
  "$addr/view?filename=ComfyUI_temp_zpbpv_00001_.flac&subfolder=&type=output" \
  -o data/ComfyUI_temp_zpbpv_00001_.flac

curl -L \
  "$addr/view?filename=ComfyUI_temp_qrkby_00001_.flac&subfolder=&type=temp" \
  -o data/ComfyUI_temp_qrkby_00001_.flac
