FROM fedora:38

RUN dnf -y install \
        meson \
        ninja-build \
        rsync \
        git \
        cmake \
        g++  \
        libadwaita-devel \
        desktop-file-utils \
        libappstream-glib \
        pulseaudio-libs-devel

ADD scripts/build.sh /opt/build/build.sh

WORKDIR /opt/build/

CMD ./build.sh
