#! /usr/bin/env bash

david_show_version(){
    echo "[DOING] show version"
    cat /etc/redhat-release
    uname -r
}

david_system_init(){
    echo "[DOING] update system..."
    yum update
    rpm -q bash-completion || yum install bash-completion
    rpm -q git || yum install git
    rpm -q nginx || yum install nginx
    rpm -q python-pip || yum install python-pip
    rpm -q screen || yum install screen
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
rpm -q openssh-server || yum install openssh-server
rpm -q postfix || yum install postfix
rpm -q gitlab
if [ $? -eq 0 ]; then
    echo "gitlab has installed."
else
    if [ -f tools/gitlab-7.0.0_omnibus-1.el6.x86_64.rpm ]; then
        rpm -i gitlab-7.0.0_omnibus-1.el6.x86_64.rpm

        read -sp "Editing gitlab.rb. (ex:http://lzw.name:8081) press any key continue."
        echo -e "\n"
        vim /etc/gitlab/gitlab.rb
        gitlab-ctl reconfigure
        gitlab-ctl restart
        gitlab-ctl help
        echo "if any problem with firewall, try: lokkit -s http -s ssh"
    else
        echo "download: https://downloads-packages.s3.amazonaws.com/centos-6.5/gitlab-7.0.0_omnibus-1.el6.x86_64.rpm first"
    fi
fi
gitlab-ctl status

echo "Installing jenkins..."
rpm -q java-1.7.0-openjdk || yum install java-1.7.0-openjdk
rpm -q jenkins
if [ $? -eq 0 ]; then
    echo "jenkins has installed."
else
    wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
    rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
    yum install jenkins

    read -sp "Editing jenkins config file. (find 8080 change into 8082) press any key continue."
    echo -e "\n"
    vim /etc/sysconfig/jenkins
    service jenkins restart
    echo "service jenkins status|start|stop|restart..."
fi
service jenkins status

echo "Installing ajenti..."
rpm -q ajenti
if [ $? -eq 0 ]; then
    echo "ajenti has installed."
else
    if [ -f tools/ajenti-repo-1.0-1.noarch.rpm ]; then
        rpm -i ajenti-repo-1.0-1.noarch.rpm
        yum install ajenti
    else
        echo "download: http://repo.ajenti.org/ajenti-repo-1.0-1.noarch.rpm first"
    fi
fi
service ajenti status
