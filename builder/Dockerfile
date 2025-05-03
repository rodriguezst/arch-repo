FROM alpine AS rootfs-downloader
RUN apk add --no-cache libarchive-tools wget && \
    wget "http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz" && \
    mkdir /rootfs && \
    bsdtar -xpf ArchLinuxARM-aarch64-latest.tar.gz -C /rootfs

FROM scratch
COPY --from=rootfs-downloader /rootfs/ /

RUN echo "Installing dependencies..." && \
    pacman-key --init && \
    pacman-key --populate archlinuxarm && \
    pacman -Syu --noconfirm sudo git base-devel jq gnupg && \
    useradd -m builder -u 1001 && \
    echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    mkdir -p /__w /github/home /github/workflow && \
    echo "Adding custom repository..." && \
    pacman-key --recv-key 666411233117519B --keyserver keyserver.ubuntu.com && \
    pacman-key --lsign-key 666411233117519B && \
    echo "[nabu-alarm]" >> /etc/pacman.conf && \
    echo "SigLevel = Required DatabaseOptional" >> /etc/pacman.conf && \
    echo "Server = https://nabu-alarm.github.io/repo" >> /etc/pacman.conf && \
    pacman -Sy --noconfirm nabu-alarm-keyring && \
    pacman-key --populate

ENV HOME=/home/builder LANG=C.UTF-8
USER builder
WORKDIR /home/builder
CMD ["/usr/bin/bash"]
