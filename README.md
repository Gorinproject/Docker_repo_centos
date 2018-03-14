# docker_repo_centos

Config Server
COPY nginx.conf /etc/nginx/nginx.conf
COPY repo.conf /etc/nginx/conf.d/repo.conf
COPY crontab /etc/

Config Client
COPY CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
COPY epel.repo /etc/yum-repos.d/epel.repo
yum clean all
yum repolist
yum check-update
