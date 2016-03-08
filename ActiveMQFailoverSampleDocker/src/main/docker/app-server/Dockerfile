FROM jboss/wildfly:8.2.0.Final
ADD activemq-failover-client.war /opt/jboss/wildfly/standalone/deployments/
ADD activemq-rar-5.13.2.rar /opt/jboss/wildfly/standalone/deployments/
ADD standalone.xml /opt/jboss/wildfly/standalone/configuration/
RUN /opt/jboss/wildfly/bin/add-user.sh admin knoware --silent

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "--debug", "8787", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]