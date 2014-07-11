#!/usr/bin/env bash

yum install pptp pptp-setup
#pptpsetup --create fq --server 107.170.234.24 --username david --password abc --encrypt
pptpsetup --create fq --server 107.170.234.24 --username david --encrypt

#pppd call fq
#sleep 10s
#ip route replace default dev ppp0
