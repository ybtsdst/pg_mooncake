FROM ubuntu:22.04

ARG HTTP_PROXY
ARG DEV_USERNAME
ARG USER_UID
ARG USER_GID

ENV DEBIAN_FRONTEND=noninteractive
ENV http_proxy=${HTTP_PROXY}
ENV https_proxy=${HTTP_PROXY}
ENV HTTP_PROXY=${HTTP_PROXY}
ENV HTTPS_PROXY=${HTTP_PROXY}
ENV ALL_PROXY=${HTTP_PROXY}
ENV TZ=Asia/Shanghai
ENV CARGO_HOME=/opt/cargo
ENV RUSTUP_HOME=/opt/rustup
ENV PATH=${CARGO_HOME}/bin:${PATH}
ENV RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup    
ENV RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup 

RUN \
    # prepare apt
    sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    echo 'Acquire::ForceIPv4 "true";' >> /etc/apt/apt.conf.d/1000-force-ipv4-transport && \
    echo 'Acquire::Retries "100";' >> /etc/apt/apt.conf.d/80-retries && \
    # echo 'Acquire::http::Proxy "${HTTP_PROXY}";' >> /etc/apt/apt.conf.d/99-proxy && \
    # echo 'Acquire::https::Proxy "${HTTPS_PROXY}";' >> /etc/apt/apt.conf.d/99-proxy && \
    apt-get update -y && \
    # basics
    PKGS="software-properties-common" && \
    apt-get install -y ${PKGS} && \
    PKGS="vim sudo locales git curl unzip wget zip iputils-ping iproute2 tzdata tree jq bear" && \
    PKGS="${PKGS} gdb net-tools telnet pkg-config linux-tools-common linux-tools-generic" && \
    # pg dev for pgrx
    PKGS="${PKGS} flex bison libreadline-dev zlib1g-dev libssl-dev libxml2-dev libxslt1-dev libicu-dev \
    libldap2-dev liblz4-dev libzstd-dev libnuma-dev liburing-dev uuid-dev libkrb5-dev libsystemd-dev \
    libpam0g-dev libselinux1-dev llvm-15-dev clang-15 python3-dev systemtap-sdt-dev libcurl4-openssl-dev \
    gettext tcl tcl-dev libperl-dev libipc-run-perl libtest-simple-perl" && \
    apt-get install -y ${PKGS} && \
    # pg_mooncake deps
    apt-get install -y \
      bison \
      cmake \
      flex \
      libclang-dev \
      liblz4-dev \
      mold \
      ninja-build \
      proxychains4 && \
    locale-gen en_US.UTF-8 && \
    echo ${TZ} > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    dpkg-reconfigure tzdata && \
    rm -rf /var/lib/apt/lists/* && \
    ln -sf /usr/bin/mold /usr/bin/ld && \
    apt-get autoclean

RUN \
    # proxy for wget
    echo "use_proxy = on" >> /etc/wgetrc && \
    echo "http_proxy = ${http_proxy}" >> /etc/wgetrc && \
    echo "https_proxy = ${http_proxy}" >> /etc/wgetrc && \
    # misc
    echo "* soft core unlimited" >>/etc/security/limits.conf && \
    mkdir /coredumps && \
    chmod o+rwx /coredumps

ENV LC_ALL="en_US.UTF-8"
ENV LANG="en_US.UTF-8"

RUN \
  # Create the user
  groupadd --gid $USER_GID $DEV_USERNAME \
  && useradd --uid $USER_UID --gid $USER_GID -m --shell /bin/bash $DEV_USERNAME \
  #
  # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
  && echo $DEV_USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$DEV_USERNAME \
  && chmod 0440 /etc/sudoers.d/$DEV_USERNAME

RUN \
  mkdir -p ${RUSTUP_HOME} && \
  chown -R $DEV_USERNAME:$DEV_USERNAME ${RUSTUP_HOME} && \
  mkdir -p ${CARGO_HOME} && \
  chown -R $DEV_USERNAME:$DEV_USERNAME ${CARGO_HOME}

USER $DEV_USERNAME

ADD config.toml ${CARGO_HOME}/config.toml

# rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y 

# RUN cargo install --locked cargo-pgrx@0.16.1 \
#  && cargo pgrx init

# RUN cd ~ \
#  && git clone https://github.com/microsoft/vcpkg.git \
#  && sh ./vcpkg/scripts/bootstrap.sh -disableMetrics

ENV VCPKG_TOOLCHAIN_PATH=/home/${DEV_USERNAME}/vcpkg/scripts/buildsystems/vcpkg.cmake

RUN wget -P ~ https://raw.githubusercontent.com/cmrschwarz/rust-prettifier-for-lldb/refs/heads/main/rust_prettifier_for_lldb.py

ENV http_proxy=
ENV https_proxy=