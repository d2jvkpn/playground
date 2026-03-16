#!/bin/bash

#### config
# client-connect /apps/target/client_connect.sh

# chmod +x /apps/target/client_connect.sh

echo "$(date +%FT%T%:z) client_connected: $common_name, $trusted_ip" >> /apps/logs/openvpn_connection.log
