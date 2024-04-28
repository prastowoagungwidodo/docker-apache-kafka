FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    vim \
    wget \
    iputils-ping \
    net-tools \
    curl \
    iproute2 \
    openjdk-21-jdk

RUN echo 'ubuntu ALL=(ALL) NOPASSWD: ALL' | tee -a /etc/sudoers
RUN mkdir -p /home/ubuntu
RUN mkdir -p /home/ubuntu/.ssh
RUN chown -R ubuntu:ubuntu /home/ubuntu/.ssh

RUN wget https://downloads.apache.org/kafka/3.7.0/kafka_2.13-3.7.0.tgz -O /home/ubuntu/kafka.tgz
RUN mkdir -p /home/ubuntu/kafka
RUN tar -xvzf /home/ubuntu/kafka.tgz -C /home/ubuntu/kafka --strip-components 1
ADD kafka/config /home/ubuntu/kafka/config
ADD kafka/plugins /home/ubuntu/kafka/plugins
ADD init.sh /home/ubuntu/init.sh

RUN mkdir -p /home/ubuntu/logs
RUN mkdir -p /home/ubuntu/config
RUN chown -R ubuntu:ubuntu /home/ubuntu
RUN chmod +x /home/ubuntu/init.sh

RUN echo 'ListenAddress 0.0.0.0' | tee -a /etc/ssh/sshd_config

RUN service ssh start

EXPOSE 22

CMD ["/home/ubuntu/init.sh"]
