FROM alpine:latest

# Install dependencies
RUN apk add --no-cache \
    openjdk17-jre \
    wget \
    tar \
    dbus \
    libstdc++ \
    gcompat

# Set signal-cli version
ENV SIGNAL_CLI_VERSION=0.13.9

# Download and install signal-cli
RUN wget -O /tmp/signal-cli.tar.gz \
    "https://github.com/AsamK/signal-cli/releases/download/v${SIGNAL_CLI_VERSION}/signal-cli-${SIGNAL_CLI_VERSION}-Linux.tar.gz"
RUN tar -xzf /tmp/signal-cli.tar.gz -C /opt
RUN mv /opt/signal-cli-${SIGNAL_CLI_VERSION} /opt/signal-cli
RUN ln -s /opt/signal-cli/bin/signal-cli /usr/local/bin/signal-cli
RUN rm /tmp/signal-cli.tar.gz

# Create signal-cli data directory
RUN mkdir -p /var/lib/signal-cli

# Set working directory
WORKDIR /var/lib/signal-cli

# Expose the daemon port
EXPOSE 8080

# Start dbus and signal-cli in daemon mode
CMD ["sh", "-c", "dbus-daemon --system --fork && signal-cli -a ${SIGNAL_NUMBER} daemon --http 0.0.0.0:8080"]
