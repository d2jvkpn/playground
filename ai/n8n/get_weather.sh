#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


output_dir=${1:-data}
tag=$(date +%F-%s)

mkdir -p "$output_dir"
prefix="$output_dir/${tag}"

curl -4 --fail https://ipinfo.io/json > "${prefix}_ipinfo.io.json"

timezone=$(jq -r .timezone "${prefix}_ipinfo.io.json")
loc=$(jq -r .loc "${prefix}_ipinfo.io.json")
location=$(echo "$loc" | awk 'BEGIN{FS=","; OFS="&"} {print "latitude="$1, "longitude="$2}')

curl --fail "https://api.open-meteo.com/v1/forecast?timezone=$timezone&$location&daily=temperature_2m_max,temperature_2m_min,precipitation_sum,windspeed_10m_max,winddirection_10m_dominant" > "${prefix}_api.open-meteo.com.json"

weather=$(
  jq -r '
  .daily as $d
  | [range(0; $d.time | length)]
  | map({
      date:                    $d.time[.],
      temperature_min:         $d.temperature_2m_min[.],
      temperature_max:         $d.temperature_2m_max[.],
      precipitation:           $d.precipitation_sum[.],
      windspeed_max:           $d.windspeed_10m_max[.],
      winddirection_dominant:  $d.winddirection_10m_dominant[.]
    })
' "${prefix}_api.open-meteo.com.json" |
  yq -p=json -o=yaml '.[:3] | {''"weather": .}'
)

cat > "${prefix}_result.yaml" <<EOF
datetime: $(echo $tag | awk -F "-" '{print $NF}' | xargs -i date -d @{} --rfc-3339=seconds)
timezone: $timezone
loc: $loc
$weather
EOF

cat "${prefix}_result.yaml"
