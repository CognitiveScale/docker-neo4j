# cognitivescale/neo4j

FROM c12e/debian
MAINTAINER Indy Beck indy@c12e.com

RUN apt-get update && \
   apt-get install -y supervisor wget

ENV NEO4J_VERSION 2.2.0

RUN wget -q -O /tmp/neo4j-community-${NEO4J_VERSION}-unix.tar.gz http://dist.neo4j.org/neo4j-community-${NEO4J_VERSION}-unix.tar.gz && \
   tar -zxf /tmp/neo4j-community-${NEO4J_VERSION}-unix.tar.gz -C /opt && \
   ln -s /opt/neo4j-community-${NEO4J_VERSION} /opt/neo4j && \
   wget -q -O /opt/neo4j/lib/gson-2.2.4.jar http://search.maven.org/remotecontent?filepath=com/google/code/gson/gson/2.2.4/gson-2.2.4.jar && \
   wget -q -O /opt/neo4j/lib/c12e-plugin-0.1.6-SNAPSHOT.jar https://s3.amazonaws.com/c1sandbox/downloads/neo4j-ext/${NEO4J_VERSION}/c12e-plugin-0.1.6-SNAPSHOT.jar

ADD neo4j-server.properties /opt/neo4j/conf/neo4j-server.properties
ADD neo4j-wrapper.conf /opt/neo4j/conf/neo4j-wrapper.conf
ADD neo4j.properties /opt/neo4j/conf/neo4j.properties
RUN mkdir -p /data /logs

# supervisord
ADD neo4j_supervisor.conf /etc/supervisor/supervisord.conf

# Ports
EXPOSE 7474

CMD ["/usr/bin/supervisord"]
