#!/usr/bin/env bash

case $1 in
    init)
        yum install pptp pptp-setup
        #pptpsetup --create fq --server 107.170.234.24 --username david --password abc --encrypt
        pptpsetup --create fq --server 107.170.234.24 --username david --encrypt
        echo "fq vpn init."
        exit 0;;
    on | start)
        pppd call fq
        sleep 10s
        ip route replace default dev ppp0
        echo "fq vpn starting."
        exit 0;;
    off| stop)
        ip route replace default dev eth0
        killall pppd
        sleep 10s
        echo "fq vpn stopped."
        exit 0;;
    *)
        cat <<!EOF!
usage: $0 <command>
command:
    init            init the vpn.
    on | start      starting the vpn.
    off | stop      stopping the vpn.

fq means go through the GFW.
!EOF!
        exit 0;;
esac
