#! /usr/bin/env bash

# david_inittool <name> <url>
david_inittool(){
    local name=$1
    local url=$2
    if [ -d ./tools/$name ]; then
        echo "upgrading: $name"
        if [[ -d ./tools/$name/.git && -w ./tools/$name/.git ]]; then
            cd ./tools/$name
            git pull
            cd ../../
        else
            echo "cannot upgrade $name, please check."
        fi
    else
        echo "downloading: $name"
        git clone $url ./tools/$name
    fi
}

if [[ -d ./tools/ && -w ./tools/ ]]; then
    david_inittool "chnroutes" "https://github.com/fivesheep/chnroutes.git"
fi
