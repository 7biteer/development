FROM ubuntu:22.04

# Set non-interactive mode to avoid tzdata prompts
ENV DEBIAN_FRONTEND=noninteractive

# Node and 
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y \
    curl \
    git \
    bash

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Set environment variables for nvm and node to work properly
ENV NVM_DIR=/root/.nvm
ENV PATH="$NVM_DIR/versions/node/v22.14.0/bin:$NVM_DIR/bin:$PATH"

# Install Node.js v22.14.0 using nvm
RUN bash -c "source $NVM_DIR/nvm.sh && nvm install 22.14.0 && nvm alias default 22.14.0"

# Install Yarn globally using npm
RUN bash -c "source $NVM_DIR/nvm.sh && npm install -g yarn"

# Python
RUN apt-get install -y \
    python3 \
    python3-pip

# Install Poetry (latest version)
RUN curl -sSL https://install.python-poetry.org | python3 -

# Add Poetry to PATH (this is where poetry gets installed by default for root)
ENV PATH="/root/.local/bin:$PATH"

# Java
RUN apt-get install -y \
    openjdk-17-jdk \
    unzip

# Install Gradle (latest stable version)
ENV GRADLE_VERSION=8.7
ENV GRADLE_HOME=/opt/gradle
ENV PATH=$GRADLE_HOME/gradle-$GRADLE_VERSION/bin:$PATH

RUN curl -fsSL https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o gradle.zip && \
    mkdir -p ${GRADLE_HOME} && \
    unzip -d ${GRADLE_HOME} gradle.zip && \
    rm gradle.zip

# Confirm installations (optional - for debugging purposes)
RUN bash -c "\
    source $NVM_DIR/nvm.sh && \
    node -v && \
    npm -v && \
    yarn -v && \
    python3 --version && \
    poetry --version && \
    java -version && \
    gradle --version"

# Expose optional port
EXPOSE 3000
    
CMD ["bash"]