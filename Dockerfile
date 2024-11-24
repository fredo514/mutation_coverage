# start from a base debian install with latest ruby2
FROM ruby:2.7.8

# Download tools
RUN apt-get update && \
        apt-get clean && \ 
        apt-get install -y \
            build-essential \
            wget \
            curl \
            file \
            git \
            coreutils \
            gcc \
            gcovr \
            valgrind \
            libc-dev \
            gdb \
            lsb-release \
            software-properties-common \
            gnupg \
            python \
            gcc-multilib \
            g++-multilib

# install llvm-12
RUN wget https://apt.llvm.org/llvm.sh
RUN chmod +x llvm.sh
RUN ./llvm.sh 12

# install mull
RUN wget https://dl.cloudsmith.io/public/mull-project/mull-stable/deb/ubuntu/pool/focal/main/M/Mu/mull-12_0.23.0/Mull-12-0.23.0-LLVM-12.0-ubuntu-20.04.deb
RUN apt install ./Mull-12-0.23.0-LLVM-12.0-ubuntu-20.04.deb 

# install brew and klee
RUN wget https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
RUN chmod +x install.sh
RUN CI=1 ./install.sh
RUN echo >> /root/.bashrc && \
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /root/.bashrc && \
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \
    brew install klee

# install ceedling
RUN gem install ceedling

RUN mkdir /project

## Add base project path to $PATH (for help scripts, etc.)
ENV PATH "/project:$PATH"

# Create empty project directory (to be mapped by source code volume)
WORKDIR /project
ADD . /project

# When the container launches, run a shell that launches in WORKDIR
CMD ["/bin/sh"]