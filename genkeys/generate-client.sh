#!/usr/bin/env bash
set -euo pipefail

ADDRESS="$1"
KEY="$2"
PSK="$3"
SERVER_PUB="$4"

cat <<-EOF
	[Interface]
	Address = $ADDRESS/32
	PrivateKey = $(<"$KEY")

	[Peer]
	PublicKey = $(<"$SERVER_PUB")
	PresharedKey = $(<"$PSK")
	AllowedIPs = 10.90.0.1/32, 10.89.0.11/32, 10.89.0.12/32, 10.89.0.13/32
	Endpoint = vpn.bacchus.io:51821
EOF
