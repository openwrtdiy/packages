#!/bin/sh
#
# Copyright (C) 2018 rosysong@rosinson.com
#

qosdef_pppoe_get_ip_handle() { # <family> <chain> <ip>
	echo $(nft -a list chain $1 nft-qos-pppoe $2 2>/dev/null | grep $3 | awk '{print $11}')
}

qosdef_pppoe_delete_handle() { # <family> <chain> <handle>
	nft delete rule $1 nft-qos-pppoe $2 handle $3
}

qosdef_pppoe_add() { # <mac> <ip> <hostname>
	handle_dl=$(qosdef_pppoe_get_ip_handle $NFT_QOS_INET_FAMILY download $2)
	[ -z "$handle_dl" ] && nft add rule $NFT_QOS_INET_FAMILY nft-qos-pppoe download ip daddr $2 counter
	handle_ul=$(qosdef_pppoe_get_ip_handle $NFT_QOS_INET_FAMILY upload $2)
	[ -z "$handle_ul" ] && nft add rule $NFT_QOS_INET_FAMILY nft-qos-pppoe upload ip saddr $2 counter
}

qosdef_pppoe_del() { # <mac> <ip> <hostname>
	local handle_dl handle_ul
	handle_dl=$(qosdef_pppoe_get_ip_handle $NFT_QOS_INET_FAMILY download $2)
	handle_ul=$(qosdef_pppoe_get_ip_handle $NFT_QOS_INET_FAMILY upload $2)
	[ -n "$handle_dl" ] && qosdef_pppoe_delete_handle $NFT_QOS_INET_FAMILY download $handle_dl
	[ -n "$handle_ul" ] && qosdef_pppoe_delete_handle $NFT_QOS_INET_FAMILY upload $handle_ul
}

# init qos pppoe
qosdef_init_pppoe() {
	local hook_ul="prerouting" hook_dl="postrouting"

	[ -z "$NFT_QOS_HAS_BRIDGE" ] && {
		hook_ul="postrouting"
		hook_dl="prerouting"
	}

	nft add table $NFT_QOS_INET_FAMILY nft-qos-pppoe
	nft add chain $NFT_QOS_INET_FAMILY nft-qos-pppoe upload { type filter hook $hook_ul priority 0\; }
	nft add chain $NFT_QOS_INET_FAMILY nft-qos-pppoe download { type filter hook $hook_dl priority 0\; }
}
