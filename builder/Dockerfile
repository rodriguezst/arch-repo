FROM alpine AS rootfs-downloader
RUN apk add --no-cache libarchive-tools wget && \
    wget "http://fl.us.mirror.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz" && \
    mkdir /rootfs && \
    bsdtar -xpf ArchLinuxARM-aarch64-latest.tar.gz -C /rootfs

FROM scratch
COPY --from=rootfs-downloader /rootfs/ /

RUN pacman-key --init && \
    pacman-key --populate archlinuxarm && \
    useradd -m builder -u 1001 && \
    echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    mkdir -p /__w /github/home /github/workflow && \
    pacman-key --recv-key 864C084CBA72A871 --keyserver keyserver.ubuntu.com && \
    pacman-key --lsign-key 864C084CBA72A871 && \
    echo "[rodriguezst]" >> /etc/pacman.conf && \
    echo "SigLevel = Required DatabaseOptional" >> /etc/pacman.conf && \
    echo "Server = https://github.com/rodriguezst/arch-repo/releases/download/aarch64" >> /etc/pacman.conf && \
    sed -i 's|mirror.archlinuxarm.org|fl.us.mirror.archlinuxarm.org|g' /etc/pacman.d/mirrorlist && \
    sed -i -e 's~#IgnorePkg.*~IgnorePkg = filesystem~g' '/etc/pacman.conf' && \
    #pacman -Sy --noconfirm rodriguezst-keyring && \
    pacman-key --populate && \
    pacman -Syu --noconfirm sudo git base-devel jq gnupg github-cli

ENV HOME=/home/builder LANG=C.UTF-8
USER builder
WORKDIR /home/builder

RUN git clone https://github.com/rodriguezst/alpm-html.git alpm-html && \
    cd alpm-html && makepkg -s -i --noconfirm && cd ../ && rm -rf alpm-html

CMD ["/usr/bin/bash"]
