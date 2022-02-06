FROM golang:1.17
LABEL "repository"="https://github.com/sugerio/go-lambda-s3-action"
LABEL "maintainer"="Suger Inc"

RUN apt update \
	&& apt -y upgrade \
    && apt install -y zip \
    && apt install -y awscli \
    && apt autoremove \
	&& apt autoclean \
	&& apt clean

ADD entrypoint.sh /entrypoint.sh

#Make entrypoint file executable
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]