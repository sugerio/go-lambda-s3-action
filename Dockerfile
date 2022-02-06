FROM ubuntu:22.04

# install packages
RUN apt-get update && \ 
    apt-get install zip && \
    apt-get install awscli -y 

ADD entrypoint.sh /entrypoint.sh

#Make entrypoint file executable
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]