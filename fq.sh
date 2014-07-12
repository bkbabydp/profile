#!/usr/bin/env bash

case $1 in
    init)
        yum install pptp pptp-setup

        read -p "username: " username
        if [ -z $username ]; then
            echo "username passed"
        else
            read -ps "password: " password
            if [ -z $password ]; then
                echo "password passed"
            else
                #pptpsetup --create fq --server 107.170.234.24 --username david --password abc --encrypt
                pptpsetup --create fq --server 107.170.234.24 --username $username --password $password --encrypt
            fi
        fi


        file=/etc/ppp/peers/fq
        # check $file
        if [ -w $file ]; then
            echo "editing $file"
            # set [defaultroute]
            if [ `sed "s/#.*$//g" $file|grep defaultroute` ]; then
                echo "[defaultroute] existed."
            else
                echo "# 使用本连接作为默认路由,本文单网卡没意义，可以不添加，说明见附录" >> $file
                echo "defaultroute  " >> $file
            fi
            # set [persist]
            if [ `sed "s/#.*$//g" $file|grep persist` ]; then
                echo "[persist] existed."
            else
                echo "# 当连接丢失时让pppd再次拨号，已验证" >> $file
                echo "persist" >> $file
            fi
        else
            echo "cannot find $file!"
            exit 1
        fi
        echo "fq vpn inited."
        exit 0
        ;;
    on | start)
        pppd call fq
        sleep 10s
        ip route replace default dev ppp0
        route
        echo "fq vpn starting."
        exit 0
        ;;
    off| stop)
        ip route replace default dev eth0
        killall pppd
        sleep 10s
        route
        echo "fq vpn stopped."
        exit 0
        ;;
    *)
        cat <<!EOF!
usage: $0 <command>
command:
    init            init the vpn.
    on | start      starting the vpn.
    off | stop      stopping the vpn.

fq means go through the GFW.
!EOF!
        exit 0
        ;;
esac
