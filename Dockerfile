FROM ubuntu:xenial

RUN DEBIAN_FRONTEND=noninteractive \
apt-get update && \
apt-get install --no-install-recommends -q -y cron logrotate python3-pip python3-setuptools language-pack-ja tzdata && \
rm -rf /var/lib/apt/lists/* && \
pip3 install wheel && \
pip3 install Jinja2 MarkupSafe oauthlib requests requests-oauthlib

COPY twimg2rss/*.py /opt/
COPY twimg2rss/twimg2rss.xml.j2 /opt/
COPY crontab /etc/cron.d/twimg2rss
RUN chmod 0644 /etc/cron.d/twimg2rss
COPY twimg2rss.logrotate /etc/logrotate.d/twimg2rss

ARG INSTALL_USER=developer
ARG UID=1000
ARG CONFIGDIR=/home/${INSTALL_USER}/.twimg2rss/conf
ARG LOGDIR=/home/${INSTALL_USER}/.twimg2rss/log
ARG TIMELINE=/home/${INSTALL_USER}/.twimg2rss/timeline

RUN \
update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja" && \
cp -p /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
echo "Asia/Tokyo" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata && \
adduser --disabled-password --gecos "Developer" --uid "${UID}" "${INSTALL_USER}" && \
chown -R "${INSTALL_USER}":"${INSTALL_USER}" "/home/${INSTALL_USER}" && \
sed -i -e "s/INSTALL_USER/${INSTALL_USER}/" -e "s|TIMELINE|${TIMELINE}|" -e "s|LOGDIR|${LOGDIR}|" /etc/cron.d/twimg2rss && \
sed -i -e "s|os\\.path\\.abspath(os\\.path\\.dirname(__file__))|\\'${CONFIGDIR}\\'|" /opt/common.py && \
rm /etc/cron.daily/apt-compat /etc/cron.daily/dpkg /etc/cron.daily/passwd && \
sed -i -e "s/^su root syslog/su root root/" /etc/logrotate.conf && \
rm /etc/logrotate.d/apt /etc/logrotate.d/dpkg && \
sed -i -e "s|LOGDIR|${LOGDIR}|" /etc/logrotate.d/twimg2rss

ENTRYPOINT [ "/usr/sbin/cron", "-f" ]

#USER ${INSTALL_USER}
#ENTRYPOINT [ "/opt/twimg2rss.py" ]
#ENTRYPOINT [ "/bin/bash" ]
