FROM ubuntu:20.04

# install utils
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
  bash-completion \
  build-essential \
  cmake \
  gdb \
  git \
  pylint3 \
  python3-argcomplete \
  python3-pip \
  python3-opencv \
  libopencv-dev \
  nano \
  wget \
  sudo \
  curl \
  srecord \ 
  libboost-all-dev

ARG USERNAME=lulav
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create a non-root user
RUN groupadd --gid $USER_GID $USERNAME \
  && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
  # [Optional] Add sudo support for the non-root user
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
  && chmod 0440 /etc/sudoers.d/$USERNAME \
  # Cleanup
  && rm -rf /var/lib/apt/lists/* \
  && echo "source /usr/share/bash-completion/completions/git" >> /home/$USERNAME/.bashrc

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN pip install cython numpy scipy matplotlib

WORKDIR /home/lulav

# Install GTSAM
RUN git clone https://github.com/borglab/gtsam.git \
    && cd gtsam \
    && mkdir build && cd build \
    && cmake -DGTSAM_ALLOW_DEPRECATED_SINCE_V42:=OFF -DGTSAM_BUILD_PYTHON=1 .. \
    && make -j8 \ 
    && make install \
    && echo 'export LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}' >> ~/.bashrc \
    && echo 'export LD_LIBRARY_PATH=/usr/local/share:${LD_LIBRARY_PATH}' >> ~/.bashrc

# Install GPMP2
 RUN git clone https://github.com/borglab/gpmp2.git && \
     cd gpmp2 && mkdir build && cd build \
    && export gtwap_DIR=/gtsam/wrap/cmake \
    && cmake -DGPMP2_BUILD_PYTHON_TOOLBOX:=ON .. \
    && make -j8  # optional, run unit tests \
    && make python-install 

RUN pip install --force-reinstall numpy==1.20

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

RUN chown -R lulav:lulav /home/lulav/gtsam

RUN chown -R lulav:lulav /home/lulav/gpmp2

RUN echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib' >> ~/.bashrc

COPY install-dev-tools.sh /home/lulav/scripts/install-dev-tools.sh