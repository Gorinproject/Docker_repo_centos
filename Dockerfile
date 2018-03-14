FROM centos:latest
MAINTAINER Gorin Dmitry <dgorin@ukrtelecom.ua>
LABEL Vendor="CentOS" \
      License=GPLv2 

EXPOSE 80


COPY nginx.conf /etc/nginx/nginx.conf
COPY repo.conf /etc/nginx/conf.d/repo.conf
COPY crontab /etc/

RUN yum -y update --setopt=tsflags=nodocs \
    && yum -y --setopt=tsflags=nodocs install createrepo epel-release rsync \
    && yum -y --setopt=tsflags=nodocs install nginx  
RUN mkdir -p /var/www/html/repos/centos/7/os/x86_64 
RUN mkdir -p /var/www/html/repos/centos/7/updates/x86_64 
RUN mkdir -p /var/www/html/repos/epel/7/x86_64 
RUN createrepo /var/www/html/repos/centos/7/os/x86_64
RUN createrepo /var/www/html/repos/centos/7/updates/x86_64
RUN createrepo /var/www/html/repos/epel/7/x86_64
	#Clone Centos Mirrors https://www.centos.org/download/mirrors/
RUN rsync -avz --exclude='repo*' rsync://mirror.cisp.com/CentOS/7/os/x86_64/ /var/www/html/repos/centos/7/os/x86_64/ \
    && rsync -avz --exclude='repo*' rsync://mirror.cisp.com/CentOS/7/updates/x86_64/ /var/www/html/repos/centos/7/updates/x86_64/  \
    && rsync -avz --exclude='repo*' --exclude='debug' rsync://mirrors.rit.edu/epel/7/x86_64/ /var/www/html/repos/epel/7/x86_64/ \
    && createrepo --update /var/www/html/repos/centos/7/os/x86_64/ \
    && createrepo --update /var/www/html/repos/centos/7/updates/x86_64/ \
    && createrepo --update /var/www/html/repos/epel/7/x86_64/ 
USER 997
ENTRYPOINT ["container-entrypoint"]
CMD [ "nginx" ]
