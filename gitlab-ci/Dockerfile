FROM ruby:2.4.2
RUN apt-get update && apt-get install lsb-release -y && \
    export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && apt-get -f install google-cloud-sdk -y && \
    base=https://github.com/docker/machine/releases/download/v0.16.0 && \
    curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine && \
    install /tmp/docker-machine /usr/local/bin/docker-machine && \
    curl -fsSL https://get.docker.com -o get-docker.sh && \
    bash get-docker.sh
RUN rm -rf /var/lib/apt/lists/*
