FROM fedora:38

RUN dnf update -y \
    && \
    dnf groupinstall -y \
        "Development Tools" \
        "Development Libraries"

RUN dnf -y install \
        meson \
        ninja-build \
        rsync \
        cmake \
        g++  \
        libadwaita-devel \
        desktop-file-utils \
        libappstream-glib \
        pulseaudio-libs-devel

ADD scripts/build.sh /opt/build/build.sh

WORKDIR /opt/build/

CMD ./build.sh
