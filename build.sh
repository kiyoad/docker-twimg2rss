#!/usr/bin/env bash
set -euo pipefail

tmpscript="$(mktemp)"
trap 'rm -f ${tmpscript}' EXIT
id=$(date '+%Y%m%d')

cat <<"EOF" > "${tmpscript}"
#!/usr/bin/env bash
set -euxo pipefail

source my_config

if [ ! -d twimg2rss ]; then
   git clone https://github.com/kiyoad/twimg2rss.git
fi

image_name=kiyoad/twimg2rss
docker build \
       --build-arg "INSTALL_USER=${LOGNAME}" \
       --build-arg "UID=$(id -u)" \
       --build-arg "CONFIGDIR=${CONFIGDIR}" \
       --build-arg "LOGDIR=${LOGDIR}" \
       --build-arg "TIMELINE=${TIMELINE}" \
       -t ${image_name} .

sed -e "s|CONFIGDIR|${CONFIGDIR}|" -e "s|HTMLDIR|${HTMLDIR}|" twimg2rss.docker-compose.yml > docker-compose.yml
sed -e "s|YOUR_DOMAIN|${YOUR_DOMAIN}|" \
    -e "s|CONFIGDIR|${CONFIGDIR}|" \
    -e "s|DBDIR|${DBDIR}|" \
    -e "s|HTMLDIR|${HTMLDIR}|" \
    -e "s|LOGDIR|${LOGDIR}|" \
    -e "s|TIMELINE|${TIMELINE}|" twimg2rss.config.ini > config.ini

EOF
script -ec "bash ${tmpscript}" "build_${id}.log"
