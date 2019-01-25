FROM centos:7

# Prerequisites
RUN    yum -y update \
    && yum -y install git wget \
    && yum clean all \
    && rm -rvf /var/cache/yum

# Copy assets
COPY RELEASE /
COPY assets/ /assets/

ENV GOGS_CUSTOM /data/gogs

# Configure LibC Name Service
COPY nsswitch.conf /etc/nsswitch.conf

RUN /assets/setup.sh

USER git

VOLUME ["/data"]
EXPOSE 3000
ENTRYPOINT ["/assets/start.sh"]
CMD ["/app/gogs/gogs", "web"]
