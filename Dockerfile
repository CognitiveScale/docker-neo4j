# cognitivescale/neo4j
# base image: https://hub.docker.com/r/library/neo4j/

FROM neo4j:2.3.1
MAINTAINER CogntiveScale.com

RUN wget -q -O /var/lib/neo4j/lib/c12e-plugin-1.0.0.jar https://s3.amazonaws.com/c1sandbox/downloads/neo4j-ext/2.3.1/com.c12e.neo4j-ext-2.3.14-g88ebd03.jar && \
  wget -q -O /var/lib/neo4j/lib/gson-2.2.4.jar http://search.maven.org/remotecontent?filepath=com/google/code/gson/gson/2.2.4/gson-2.2.4.jar && \
  apt-get update --quiet --quiet && \
  apt-get install -y curl nfs-common && \
  rm -rf /var/cache/apt/* /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*

COPY run.sh /run.sh

EXPOSE 7474 7473

CMD ["/run.sh"]
