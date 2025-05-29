# ArchLinux Repository
Run the following command to add this repository:
```bash
pacman-key --recv-key 864C084CBA72A871 --keyserver keyserver.ubuntu.com && \
pacman-key --lsign-key 864C084CBA72A871 && \
echo "[rodriguezst]" >> /etc/pacman.conf && \
echo "SigLevel = Required DatabaseOptional" >> /etc/pacman.conf && \
echo "Server = https://github.com/rodriguezst/arch-repo/releases/download/aarch64" >> /etc/pacman.conf && \
pacman-key --populate
```
