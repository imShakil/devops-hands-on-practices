#syntax=docker/dockerfile:1

FROM alpine:latest

LABEL maintainer="mh.ice.iu@gmail.com"

RUN apk add --no-cache openjdk-17-jdk openssh-server git maven

#     mkdir /var/run/sshd && \
#     useradd -m jenkins && \
#     echo 'jenkins:jenkins' | chpasswd && \
#     mkdir -p /home/jenkins/.ssh && \
#     chmod 700 /home/jenkins/.ssh
# EXPOSE 22
# Create Jenkins user 
RUN adduser -D jenkins && \
    echo "jenkins:jenkins" | chpasswd  

# Set up SSH RUN 
RUN mkdir -p /var/run/sshd && \
    echo "jenkins:jenkins" | chpasswd  

# Copy SSH authorized keys if you have them # Uncomment and adjust the path as needed # 

COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys  

# Ensure permissions are correct 
RUN chown -R jenkins:jenkins /home/jenkins && \
    chmod 700 /home/jenkins/.ssh && \
    chmod 600 /home/jenkins/.ssh/authorized_keys  
# Expose SSH port 

# Generate host keys at runtime
# COPY entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh

# RUN ssh-keygen -t rsa -N ''

EXPOSE 22  

# Start SSH service 
CMD ["/usr/sbin/sshd", "-D"]
