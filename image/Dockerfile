##Docker Image Base
FROM registry.access.redhat.com/rhel7
MAINTAINER Global PaaS Global_PaaS@produban.com

USER root

ENV NGINX_VERSION=1.14.2
ENV APP_HOME /etc/nginx
ENV IMAGE_SCRIPTS_HOME /opt/produban
ENV HOME /opt/app
ARG T_VERSION
ENV TEMPLATE_VERSION=${T_VERSION}

## Maintainer
#######################################################################
##### We have to expose image metada as label and ENV
#######################################################################
LABEL com.produban.imageowner="Products and Services"
LABEL com.produban.description="nginx webserver"
LABEL com.produban.components="nginx 1.14.2"

ENV com.produban.imageowner="Products and Services"
ENV com.produban.description="nginx webserver"
ENV com.produban.components="nginx 1.14.2"

ADD local.repo /etc/yum.repos.d/

RUN yum -y install openssl strace unzip tar ruby git gettext  && yum clean all


RUN mkdir /var/log/nginx && echo "" > /var/log/nginx/access.log && echo "" > /var/log/nginx/error.log \
&& ln -sf /dev/stdout /var/log/nginx/access.log \
&& ln -sf /dev/stderr /var/log/nginx/error.log \
&& rm -f /var/log/nginx/*

RUN mkdir $APP_HOME ; mkdir $IMAGE_SCRIPTS_HOME

#RUN yum -y install nginx && yum clean all
COPY nginx-gt-1.14.2-1.el7.ngx.x86_64.rpm /tmp
RUN cd /tmp && yum install -y ./nginx-gt-1.14.2-1.el7.ngx.x86_64.rpm && yum clean all

COPY Dockerfile $IMAGE_SCRIPTS_HOME/Dockerfile
COPY scripts $IMAGE_SCRIPTS_HOME
COPY status.conf /etc/nginx/conf.d/
COPY nginx.conf /etc/nginx/etc/systemd/system/
RUN rm -f /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/
COPY default.conf /etc/nginx/conf.d/
COPY 40x.html /usr/share/nginx/html/
COPY 50x.html /usr/share/nginx/html/
COPY index.html /usr/share/nginx/html/

RUN chmod -R 744 /var/log/nginx \
&& chmod -R 744 /var/run \
&& chmod -R 744 /usr/share/nginx \
&& chmod -R 744 /etc/nginx/* \
&& mkdir -p /opt/nginx/client_temp \
&& mkdir -p /opt/nginx/proxy_temp \
&& mkdir -p /opt/nginx/fastcgi_temp \
&& mkdir -p /opt/nginx/uwsgi_temp \
&& mkdir -p /opt/nginx/scgi_temp \
&& mkdir -p $HOME \
&& chmod -R 744 /opt/nginx \
&& chmod -R 744 /opt/app \
&& chown -R nginx.nginx $APP_HOME \
&& chown -R nginx.nginx $HOME \
&& chown -R nginx.nginx $IMAGE_SCRIPTS_HOME \
&& chown -R nginx.nginx /usr/share/nginx \
&& chown -R nginx.nginx /var/log/nginx \
&& chown -R nginx.nginx /var/run \
&& chown -R nginx.nginx /etc/nginx \
&& chown -h nginx:nginx /usr/sbin/nginx \
&& chown -R nginx:nginx /opt/nginx \
&& rm -fr /etc/yum.repos.d/ \
&& rm -f /tmp/nginx-gt-1.14.2-1.el7.ngx.x86_64.rpm

EXPOSE 8080 8081 8443

WORKDIR $IMAGE_SCRIPTS_HOME
USER 999

ENTRYPOINT [ "./control.sh" ]
CMD [ "start" ]
