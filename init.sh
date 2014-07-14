#! /usr/bin/env bash

david_show_version(){
    echo "[DOING] show version"
    cat /etc/redhat-release
    uname -r
}

david_system_init(){
    echo "[DOING] update system..."
    yum update
    yum install bash-completion.noarch git nginx python-pip m2crypto screen
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

echo "Installing gitlab..."
if [ ! -f tools/gitlab-7.0.0_omnibus-1.el6.x86_64.rpm ]; then
    yum install openssh-server postfix
    rpm -i gitlab-7.0.0_omnibus-1.el6.x86_64.rpm
else
    echo "download: https://downloads-packages.s3.amazonaws.com/centos-6.5/gitlab-7.0.0_omnibus-1.el6.x86_64.rpm first"
    exit 1
fi
read -sp "Editing gitlab.rb. (ex:http://lzw.name:8081) press any key continue."
echo -e "\n"
vim /etc/gitlab/gitlab.rb
gitlab-ctl reconfigure
gitlab-ctl restart
gitlab-ctl help
echo "if any problem with firewall, try: lokkit -s http -s ssh"
gitlab-ctl status

echo "Installing jenkins..."
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
yum install java-1.7.0-openjdk jenkins
read -sp "Editing jenkins config file. (find 8080 change into 8082) press any key continue."
echo -e "\n"
vim /etc/sysconfig/jenkins
service jenkins restart
service jenkins status
echo "service jenkins status|start|stop|restart..."

echo "Installing ajenti..."
if [ ! -f tools/ajenti-repo-1.0-1.noarch.rpm ]; then
    rpm -i ajenti-repo-1.0-1.noarch.rpm
    yum install ajenti
else
    echo "download: http://repo.ajenti.org/ajenti-repo-1.0-1.noarch.rpm first"
    exit 1
fi
service ajenti restart
