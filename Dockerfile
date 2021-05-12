FROM ubuntu
LABEL maintainer "David Blankenship <dtblankenship@gmail.com>"

RUN apt update -y && \
    apt install -y software-properties-common && \
    add-apt-repository ppa:git-core/ppa && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0 && \
    apt-add-repository https://cli.github.com/packages && \
    apt update -y && apt install -y git sudo curl gh

COPY Dockerfile installers/entrypoint /

ENTRYPOINT ["sh","/entrypoint"]
