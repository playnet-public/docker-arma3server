##############################################################################
# Dockerfile to build ArmA 3 container images
# Based on ubuntu:18.04
##############################################################################

FROM ubuntu:18.04

LABEL maintainer "play-net.org  <docker@play-net.org>"
LABEL author "Finch"

ARG STEAM_USERNAME
ARG STEAM_PASSWORD

ENV ARMA_INST /opt/arma
ENV STEAM_INST /opt/steam
ENV SYSTEM_USER arma
ENV SYSTEM_GROUP arma
ENV SYSTEM_HOME /home/arma
ENV APPID 233780

RUN set -x \
  && apt-get update --yes && apt-get upgrade --yes \
  && apt-get install --yes lib32stdc++6 lib32gcc1 wget \
  && rm -rf /var/cache/apk/*

RUN set -x \
  && mkdir -p ${ARMA_INST}/config \
  && mkdir -p ${STEAM_INST}

RUN set -x \
  && mkdir -p ${SYSTEM_HOME} \
  && addgroup --system ${SYSTEM_GROUP} \
  && adduser --system --disabled-login --disabled-password --ingroup ${SYSTEM_GROUP} --home ${SYSTEM_HOME} --shell /bin/sh ${SYSTEM_USER} \
  && chown -R ${SYSTEM_USER}:${SYSTEM_GROUP} ${SYSTEM_HOME}

RUN set -x \
  && wget -nv -O /tmp/steamcmd.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
  && tar xfz /tmp/steamcmd.tar.gz --strip-components=1 -C ${STEAM_INST} \
  && rm /tmp/steamcmd.tar.gz \
  && chown -R ${SYSTEM_USER}:${SYSTEM_GROUP} ${STEAM_INST} \  
  && mkdir -p ${SYSTEM_HOME}/".local/share/Arma 3" \
  && mkdir -p ${SYSTEM_HOME}/".local/share/Arma 3 - Other Profiles" \
  && chown -R ${SYSTEM_USER}:${SYSTEM_GROUP} ${SYSTEM_HOME}/".local/share/Arma 3" \
  && chown -R ${SYSTEM_USER}:${SYSTEM_GROUP} ${SYSTEM_HOME}/".local/share/Arma 3 - Other Profiles"

RUN set -x \
  && ${STEAM_INST}/steamcmd +quit; exit 0

RUN set -x \
  && /opt/steamcmd.sh +login ${STEAM_USERNAME} ${STEAM_PASSWORD} +force_install_dir ${ARMA_INST} +app_update ${APPID} +quit; exit 0

# RUN ln -s ${ARMA_INST}/mpmissions ${ARMA_INST}/MPMissions

ADD files/service /usr/local/bin/service
ADD files/entrypoint /usr/local/bin/entrypoint

RUN set -x \
  && chown -R ${SYSTEM_USER}:${SYSTEM_GROUP} /usr/local/bin/service \
  && chown -R ${SYSTEM_USER}:${SYSTEM_GROUP} /usr/local/bin/entrypoint \
  && chown -R ${SYSTEM_USER}:${SYSTEM_GROUP} /opt/arma \
  && chmod +x /usr/local/bin/service \
  && chmod +x /usr/local/bin/entrypoint

EXPOSE 2302 2303 2304

USER ${SYSTEM_USER}

COPY files/server.cfg ${ARMA_INST}/config/server.cfg.template

VOLUME ${ARMA_INST}/mpmissions
VOLUME ${ARMA_INST}/mods
VOLUME ${ARMA_INST}/keys
VOLUME ${ARMA_INST}/config

WORKDIR ${ARMA_INST}

ENTRYPOINT ["/usr/local/bin/entrypoint"]

CMD ["/usr/local/bin/service"]
