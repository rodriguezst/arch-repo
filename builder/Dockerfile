FROM lopsided/archlinux:latest

# Install dependencies and setup builder user
RUN pacman -Syu --noconfirm sudo git && \
    useradd -m builder -u 1001 && \
    echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    mkdir -p /__w /github/home /github/workflow

RUN pacman-key --recv-key 666411233117519B --keyserver keyserver.ubuntu.com && \
    pacman-key --lsign-key 666411233117519B && \
    echo "[nabu-alarm]" >> /etc/pacman.conf && \
    echo "SigLevel = Required DatabaseOptional" >> /etc/pacman.conf && \
    echo "Server = https://nabu-alarm.github.io/repo" >> /etc/pacman.conf && \
    pacman -Sy --noconfirm nabu-alarm-keyring && \
    pacman-key --populate
    

# Set environment variables
ENV HOME=/home/builder
USER builder
WORKDIR /home/builder
