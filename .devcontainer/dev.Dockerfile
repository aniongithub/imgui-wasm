FROM ubuntu

RUN apt-get update &&\
    apt-get install -y \
        nano git git-lfs \
        build-essential \
        python3 python3-pip

# Install latest version of cmake from pip
RUN pip3 install cmake

ARG EMSDK_TAG=main
WORKDIR /usr/local/src/emsdk
RUN cd /usr/local/src &&\
    git clone https://github.com/emscripten-core/emsdk.git &&\
    cd emsdk &&\
    git checkout ${EMSDK_TAG} &&\
    ./emsdk install latest &&\
    ./emsdk activate latest &&\
    chmod +x emsdk_env.sh
RUN echo 'source "/usr/local/src/emsdk/emsdk_env.sh"' >> $HOME/.bash_profile
ENV EMSDK_ROOT="/usr/local/src/emsdk"

ARG IMGUI_TAG=v1.89
WORKDIR /usr/local/src/imgui
RUN cd /usr/local/src/ &&\
    git clone https://github.com/ocornut/imgui.git &&\
    cd imgui &&\
    git checkout ${IMGUI_TAG}
ENV IMGUI_ROOT="/usr/local/src/imgui"