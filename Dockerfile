FROM registry.access.redhat.com/ubi8/ubi:8.1

ENV \
    APP_ROOT=/opt/app-root \
    HOME=/opt/app-root/src \
    PATH=/opt/app-root/src/bin:/opt/app-root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    PLATFORM="el8" \
    PYTHON_VERSION=3.6 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LANG=C.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=off

RUN mkdir -p ${HOME} && \
    useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin \
      -c "Default Application User" default && \
    chown -R 1001:0 ${APP_ROOT}

RUN INSTALL_PKGS="tar \
        unzip \
        xz \
        python36 \
        python36-devel \
        python3-setuptools \
        python3-pip \
        python3-virtualenv \
        gcc-gfortran \
        libffi-devel" && \
    yum -y --setopt=tsflags=nodocs install yum && \
    yum -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*'

RUN \
    # fix-permissions ${APP_ROOT} -P && \
    # rpm-file-permissions && \
    virtualenv-$PYTHON_VERSION ${APP_ROOT}

USER 1001

WORKDIR ${HOME}
