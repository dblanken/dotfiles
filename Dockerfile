FROM ubuntu
LABEL maintainer "David Blankenship <dtblankenship@gmail.com>"

RUN apt update && apt install -y vim tmux lynx git

RUN useradd -ms /bin/bash you
WORKDIR /home/you

RUN chown -R you:you .
USER you
CMD ["bash"]
