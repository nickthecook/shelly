FROM alpine:3

ARG SSH_PUB_KEY
ARG SSH_USER
ARG SSH_PASSWORD

ENV ZINIT_HOME="/home/$SSH_USER/.local/share/zinit/zinit.git"

# packages
RUN apk add openssh zsh starship git sudo iproute2-ss vim bind-tools netcat-openbsd tcpdump readline

# user
RUN adduser -s /bin/zsh -D $SSH_USER \
    && passwd -u nickthecook \
    && echo -e "$SSH_PASSWORD\n$SSH_PASSWORD" | passwd "$SSH_USER"

WORKDIR /home/$SSH_USER

# zinit
RUN mkdir -p $(dirname $ZINIT_HOME) \
    && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

# ssh
RUN mkdir .ssh \
    && chmod 700 .ssh \
    && echo "$SSH_PUB_KEY" > .ssh/authorized_keys \
    && chmod 600 .ssh/authorized_keys \
    && echo -e "PasswordAuthentication yes" >> /etc/ssh/sshd_config
# && echo "LogLevel DEBUG" >> /etc/ssh/sshd_config

RUN chown -R $SSH_USER .

RUN addgroup sudo \
    && adduser nickthecook sudo \
    && echo "%sudo	ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && passwd -l root

# config files
RUN mkdir .config
COPY starship.toml .config/
COPY zshrc .zshrc
COPY gitconfig .gitconfig
COPY motd /etc/

CMD ssh-keygen -A && echo "Starting SSHD..." && /usr/sbin/sshd -D -e
