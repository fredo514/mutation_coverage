FROM ruby:2.7.8

# Download tools
RUN apt-get update && \
        apt-get clean && \ 
        apt-get install -y \
            build-essential \
            wget \
            curl \
            clang-format \
            coreutils \
            gcc \
            gcovr \
            valgrind \
            libc-dev \
            gdb

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