FROM alpine:latest

RUN apk add --no-cache git maven openjdk17-jdk openssh openrc && \
    mkdir -p /run/openrc && \
    rc-update add sshd && \
    ssh-keygen -A && \
    adduser -D jenkins && \
    mkdir -p /home/jenkins/.ssh && \
    chown -R jenkins:jenkins /home/jenkins

COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys
RUN chown jenkins:jenkins /home/jenkins/.ssh/authorized_keys && \
    chmod 600 /home/jenkins/.ssh/authorized_keys

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
