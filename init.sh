#!/usr/bin/bash
export LOG_DIR=/home/ubuntu/logs
export KAFKA_DIR=/home/ubuntu/kafka

if [ -f /home/ubuntu/ssh_key ]; then
	cat /home/ubuntu/ssh_key >>/home/ubuntu/.ssh/authorized_keys
fi

if [ ! -f /home/ubuntu/install.lock ]; then
	echo "Configuring Kafka"
	KAFKA_CLUSTER_ID="$($KAFKA_DIR/bin/kafka-storage.sh random-uuid)"
	echo $KAFA_CLUSTER_ID >/home/ubuntu/KAFKA_CLUSTER_ID
	$KAFKA_DIR/bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c $KAFKA_DIR/config/kraft/server.properties
	touch /home/ubuntu/install.lock
fi

# Start Kafka
$KAFKA_DIR/bin/kafka-server-start.sh -daemon $KAFKA_DIR/config/kraft/server.properties

# Start Kafka Connect
if [ ! -z "$(ls -A /home/ubuntu/config)" ]; then
	$KAFKA_DIR/bin/connect-standalone.sh -daemon $KAFKA_DIR/config/connect-standalone.properties /home/ubuntu/config/*.properties
fi

/usr/sbin/sshd -D -o ListenAddress=0.0.0.0
