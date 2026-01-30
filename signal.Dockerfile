FROM alpine:latest

# Install dependencies
RUN apk add --no-cache \
    openjdk17-jre \
    wget \
    tar \
    dbus \
    libstdc++ \
    gcompat \
    curl

# Set signal-cli version
ENV SIGNAL_CLI_VERSION=0.13.9

# Download and install signal-cli
RUN VERSION=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/AsamK/signal-cli/releases/latest | sed -e 's/^.*\/v//') && \
    curl -L -O https://github.com/AsamK/signal-cli/releases/download/v"${VERSION}"/signal-cli-"${VERSION}".tar.gz && \
    tar -xzf /tmp/signal-cli.tar.gz -C /opt && \
    mv /opt/signal-cli-${VERSION} /opt/signal-cli && \
    ln -s /opt/signal-cli/bin/signal-cli /usr/local/bin/signal-cli && \
    rm /tmp/signal-cli.tar.gz

# Create signal-cli data directory
RUN mkdir -p /var/lib/signal-cli

# Set working directory
WORKDIR /var/lib/signal-cli

# Expose the daemon port
EXPOSE 8080

# Default device name for linking
ENV DEVICE_NAME="signal-cli"
ENV MODE="link"

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
