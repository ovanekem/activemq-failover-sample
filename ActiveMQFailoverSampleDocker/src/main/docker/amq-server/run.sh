#!/bin/bash

__run_broker() {
echo "Waiting for the database..."
/wait-for-it.sh db:1521
# Oracle takes some time to start ;-
sleep 5s
echo "Running the broker..."
/apache-activemq-${AMQ_VERSION}/bin/activemq console
}

# Run the broker once the db is up
__run_broker
