FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update &&
    apt upgrade -y &&
    apt install -y software-properties-common curl git build-essential &&
    apt-add-repository -y ppa:ansible/ansible &&
    apt update &&
    apt install -y curl git ansible build-essential &&
    apt clean autoclean &&
    apt autoremove --yes

FROM base AS via
ARG TAGS
RUN addgroup --gid 1000 via
RUN adduser --gecos via --uid 1000 --gid 1000 --disabled-password via
USER via
WORKDIR /home/via

FROM via
COPY . .
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml"]
