FROM java:7

MAINTAINER olivier.vanekem@gmail.com

ENV AMQ_VERSION 5.13.2

RUN curl http://archive.apache.org/dist/activemq/${AMQ_VERSION}/apache-activemq-${AMQ_VERSION}-bin.tar.gz | tar xzv

ADD ojdbc6.jar /apache-activemq-${AMQ_VERSION}/lib/optional/
ADD commons-dbcp2-2.1.1.jar /apache-activemq-${AMQ_VERSION}/lib/optional/
ADD activemq.xml /apache-activemq-${AMQ_VERSION}/conf/activemq.xml
ADD ./run.sh /run.sh
ADD ./wait-for-it.sh /wait-for-it.sh
RUN chmod 755 /run.sh
RUN chmod 755 /wait-for-it.sh

EXPOSE 61616 8161

CMD ["/bin/bash", "-c", "/run.sh"]

