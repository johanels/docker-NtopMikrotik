FROM debian:latest
MAINTAINER Johan Els <johan@who-els.co.za>

RUN  \
  apt-get update \
  && apt-get install -y wget lsb-release gnupg \
  && wget http://apt-stable.ntop.org/stretch/all/apt-ntop-stable.deb -O /tmp/apt-ntop-stable.deb \
  && apt-get install -y /tmp/apt-ntop-stable.deb \
  && apt-get update \
  && apt-get install -y pfring nprobe ntopng ntopng-data n2disk cento \
  && apt-get clean all \
  && rm -rf /tmp/* \
  && rm -rf /var/tmp/* \
  && rm -rf /var/lib/apt/lists/*

EXPOSE 1234
EXPOSE 2055/UDP
EXPOSE 3000

RUN echo '#!/bin/bash\nnprobe -i none -n none -3 2055 --zmq tcp://127.0.0.1:1234 &\nredis-server &\nntopng -i tcp://127.0.0.1:1234 "$@"' > /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
