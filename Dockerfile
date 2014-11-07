# cognitivescale/neo4j

FROM debian:jessie
MAINTAINER Indy Beck indy@c12e.com

RUN wget -q -O /tmp/neo4j-community-2.1.5-unix.tar.gz http://dist.neo4j.org/neo4j-community-2.1.5-unix.tar.gz && \
   tar -zxf /tmp/neo4j-community-2.1.5-unix.tar.gz -C /opt && \
   ln -s /opt/neo4j-community-2.1.5 /opt/neo4j && \
   wget -q -O /opt/neo4j/lib/gson-2.2.4.jar http://search.maven.org/remotecontent?filepath=com/google/code/gson/gson/2.2.4/gson-2.2.4.jar && \
   wget -q -O /opt/neo4j/lib/c12e-plugin-0.1.6-SNAPSHOT.jar http://ops.c1.io/downloads/c12e-plugin-0.1.6-SNAPSHOT.jar

ADD neo4j-server.properties /opt/neo4j/conf/neo4j-server.properties
ADD neo4j-wrapper.conf /opt/neo4j/conf/neo4j-wrapper.conf
ADD neo4j.properties /opt/neo4j/conf/neo4j.properties
RUN mkdir -p /data

RUN apt-get update && \
   apt-get install supervisor

# supervisord
ADD neo4j_supervisor.conf /etc/supervisor/supervisord.conf

# Ports
EXPOSE 7474

CMD ["/usr/bin/supervisord"]
