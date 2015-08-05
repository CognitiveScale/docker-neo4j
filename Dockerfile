# cognitivescale/neo4j

FROM c12e/debian
MAINTAINER CogntiveScale.com

ADD supervisor.conf /etc/supervisor/conf.d/neo4j.conf

RUN apt-get update && \
  apt-get install -y supervisor wget && \
  mkdir -p /data /logs && \
  rm -rf /var/cache/apt/* /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*
   
ENV NEO4j_VERSION 2.0.2

RUN wget -q -O /tmp/neo4j-community-$NEO4j_VERSION-unix.tar.gz http://dist.neo4j.org/neo4j-community-$NEO4j_VERSION-unix.tar.gz && \
   tar -zxf /tmp/neo4j-community-$NEO4j_VERSION-unix.tar.gz -C /opt && \
   ln -s /opt/neo4j-community-$NEO4j_VERSION /opt/neo4j && \
   wget -q -O /opt/neo4j/lib/gson-2.2.4.jar http://search.maven.org/remotecontent?filepath=com/google/code/gson/gson/2.2.4/gson-2.2.4.jar && \
   wget -q -O /opt/neo4j/lib/c12e-plugin-0.1.6-SNAPSHOT.jar https://s3.amazonaws.com/c1sandbox/downloads/neo4j-ext/${NEO4j_VERSION}/c12e-plugin-0.1.6-SNAPSHOT.jar

ADD neo4j-server.properties /opt/neo4j/conf/neo4j-server.properties
ADD neo4j-wrapper.conf /opt/neo4j/conf/neo4j-wrapper.conf
ADD neo4j.properties /opt/neo4j/conf/neo4j.properties

# Ports
EXPOSE 7474

CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
