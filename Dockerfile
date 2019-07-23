FROM debian:jessie

WORKDIR /root

RUN apt-get update \
  && apt-get install -y wget lsb curl \
  && wget https://repo.percona.com/apt/percona-release_0.1-4.$(lsb_release -sc)_all.deb \
  && dpkg -i percona-release_0.1-4.$(lsb_release -sc)_all.deb \
  && rm -f percona-release_0.1-4.$(lsb_release -sc)_all.deb \
  && apt-get update \
  && apt-get install -y pmm-client

COPY "./entrypoint.sh" /root

RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
