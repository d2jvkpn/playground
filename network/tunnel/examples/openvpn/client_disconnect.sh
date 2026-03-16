#!/bin/bash

#### config
# client-disconnect /apps/target/client_disconnect.sh

# chmod +x /apps/target/client_disconnect.sh

echo "$(date +%FT%T%:z) client_disconnected: $common_name, $trusted_ip" >> /apps/logs/openvpn_connection.log
