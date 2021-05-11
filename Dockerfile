FROM ubuntu
LABEL maintainer "David Blankenship <dtblankenship@gmail.com>"

ARG USERNAME=you
ARG RUBY_VERSION=2.7.3
ARG YARN_VERSION=1.22.10
ARG NODEJS_VERSION=16.1.0

RUN apt update && \
  apt install -y software-properties-common && \
  add-apt-repository ppa:git-core/ppa && \
  apt update && \
  apt install -y \
    vim \
    tmux \
    lynx \
    git \
    curl \
    gpg \
    dirmngr \
    original-awk \
    autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev \
  && \
  useradd -ms /bin/bash ${USERNAME}

COPY Dockerfile /etc/Dockerfile

RUN bash -c 'echo "${USERNAME}:docker" | chpasswd'

WORKDIR /home/$USERNAME
RUN git clone https://github.com/asdf-vm/asdf.git .asdf && cd .asdf && git checkout "$(git describe --abbrev=0 --tags)"
RUN chown -R ${USERNAME}:${USERNAME} .
USER $USERNAME
RUN bash -c ". /home/$USERNAME/.asdf/asdf.sh && \
. /home/$USERNAME/.asdf/completions/asdf.bash && \
asdf plugin-add ruby && asdf install ruby $RUBY_VERSION && \
asdf plugin-add yarn && asdf install yarn $YARN_VERSION && \
asdf plugin-add nodejs && asdf install nodejs $NODEJS_VERSION && \
asdf global ruby $RUBY_VERSION && \
  asdf global yarn $YARN_VERSION && \
  asdf global nodejs $NODEJS_VERSION"

CMD ["bash", "-c", "su - ${USERNAME}"]
