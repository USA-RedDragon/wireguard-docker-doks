FROM debian:9

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y procps dirmngr gpg iptables curl iproute2 && \
    echo resolvconf resolvconf/linkify-resolvconf boolean false | debconf-set-selections && \
    echo "REPORT_ABSENT_SYMLINK=no" >> /etc/default/resolvconf && \
    apt-get install --no-install-recommends -y resolvconf && \
    # Install stretch-backports gpg keys and source
    # for Digital Ocean Kubernetes' OS
    gpg --keyserver keys.gnupg.net --recv-keys 7638D0442B90D010 04EE7237B7D453EC AE33835F504A1A25 && \
    gpg --armor --export 7638D0442B90D010 | apt-key add - && \
    gpg --armor --export 04EE7237B7D453EC | apt-key add - && \
    gpg --armor --export AE33835F504A1A25 | apt-key add - && \
    echo 'deb http://deb.debian.org/debian sid main' >> /etc/apt/sources.list && \
    echo 'deb http://deb.debian.org/debian stretch-backports main' >> /etc/apt/sources.list && \
    apt update && \
    apt-get install -t sid -y --no-install-recommends wireguard-tools && \
    apt-get remove --purge -y dirmngr gpg && \
    rm -rf /var/lib/apt/lists/*

COPY scripts /scripts

CMD ["/scripts/run.sh"]
