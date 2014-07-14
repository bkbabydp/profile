#! /usr/bin/env bash

david_show_version(){
    echo "[DOING] show version"
    cat /etc/redhat-release
    uname -r
}

david_system_init(){
    echo "[DOING] update system..."
    yum update
    yum install bash-completion.noarch git nginx
}

david_ssh_init(){
    if [ ! -f ~/.ssh/authorized_keys ]; then
        mkdir -p ~/.ssh/
        cat >> ~/.ssh/authorized_keys << !EOF!
ssh-dss AAAAB3NzaC1kc3MAAACBAJ7OkOZ1ZA3m82SNrmRC+F4DrnmPFMTT2SplSN2pmjWXSDdef2MaULmdG+ra/TOw5hlnBQiJpnoUf2LYQyC9T94I6ECC9qPt6Qv9VzGIiNE5IgIlNJXcWJkVsDxCAU645V5gQ73TW4qBJLAb7UsXq7fGy5Vy8QCQq5tFyU4xGB/dAAAAFQCC0k1RFqGT885Ra63w0ZQE4ggQswAAAIEAkPFyvQZftAEvBE8fqU60wKTD2o/KZIgg1viWQqJIY7W3aXGaxPAioRfR3SsURqyQbriPJfDIKWPESEX7xMCmNC/wlLFUFk0X2i2leqZv0uo9R0j0NgYnQ5YTTtM1+Q2ioScMdqrlP+7yeA72vyeAUpHoXK0elp1attl+oA8Y8zMAAACAQeYw7uYlH9G8ECS/70LM1UYU0pHx5Ps9MCDpRTKQFYuPkznZBXAhxOQetFohGRMaPe3fWrTdd5zefg2wJY219+C12bxfqBKjBn7q1pt+YsGhTcfxN442pTf8JKLoBXFkoqJGMCGVvj19qQCxMzvFLS2bah6WpUXZOh410CXbYKQ= bk@drs-AIR.local
!EOF!
    fi
}

david_show_version

david_ssh_init
david_system_init
git clone https://github.com/bkbabydp/profile.git ~/profile

david_show_version

