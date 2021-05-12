FROM ubuntu
LABEL maintainer "David Blankenship <dtblankenship@gmail.com>"

RUN apt update -y && \
    apt install -y software-properties-common && \
    add-apt-repository ppa:git-core/ppa && \
    apt update -y && apt install -y git sudo curl

COPY Dockerfile installers/entrypoint /

ENTRYPOINT ["sh","/entrypoint"]
