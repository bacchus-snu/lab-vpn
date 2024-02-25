#!/usr/bin/env bash
set -euo pipefail

CLIENTS="$1"
KEY="$2"

cat <<-EOF
	[Interface]
	Address = 10.90.0.1/16
	PrivateKey = $(<"$KEY")
	PostUp = iptables -t nat -A POSTROUTING -s 10.90.0.0/16 ! -o %i -j MASQUERADE; iptables -A FORWARD -i %i -d 10.89.0.11,10.89.0.12,10.89.0.13 -p tcp -m multiport --dports 3300,6789,6800:7300 -j ACCEPT; iptables -A FORWARD -i %i -j DROP
	ListenPort = 51820
EOF

yq -r .[].name "$CLIENTS" | while IFS= read -r client; do
	cat <<-EOF

		[Peer]
		PublicKey = $(<"keys/clients/$client.pub")
		PresharedKey = $(<"keys/clients/$client.psk")
		AllowedIPs = $(yq -r ".[] | select(.name == \"$client\").address" "$CLIENTS")/32
	EOF
done
