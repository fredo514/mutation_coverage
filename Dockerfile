# start from a base debian install with latest ruby2
FROM ubuntu:24.04

# Download tools
RUN apt-get update && \
        apt-get clean && \ 
        apt-get install -y \
            build-essential \
            lsb-release \
            software-properties-common \
            git \
            curl \
            ruby-full \
            wget \
            gnupg \
            clang-format \
            python3
            # file \
            # coreutils \
            # gcc \
            # gcovr \
            # valgrind \
            # libc-dev \
            # gdb \
            # python \
            # gcc-multilib \
            # g++-multilib

# install homebrew
# RUN export CI=1 && \
#         /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

# download more tools
# RUN brew install \
#         wget \
#         gnupg \
#         clang-format
        
# ENV PATH="/home/linuxbrew/.linuxbrew/opt/clang-format/bin:$PATH"
            
# install ceedling
RUN gem install ceedling

# install llvm
RUN wget https://apt.llvm.org/llvm.sh
RUN chmod +x llvm.sh
RUN ./llvm.sh 18

# install mull
RUN wget https://github.com/mull-project/mull/releases/download/0.24.0/Mull-18-0.24.0-LLVM-18.1-ubuntu-24.04.deb
RUN apt install -y ./Mull-18-0.24.0-LLVM-18.1-ubuntu-24.04.deb

# # Install klee
# RUN brew install klee

# RUN mkdir /project

## Add base project path to $PATH (for help scripts, etc.)
# ENV PATH="/project:$PATH"

# # Create empty project directory (to be mapped by source code volume)
# WORKDIR /project
# ADD . /project

# When the container launches, run a shell that launches in WORKDIR
CMD ["/bin/sh"]
