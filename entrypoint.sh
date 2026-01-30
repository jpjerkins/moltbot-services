#!/bin/sh

# Start dbus
dbus-daemon --system --fork

# Wait for dbus to be ready
sleep 1

if [ "$MODE" = "link" ]; then
    echo "========================================="
    echo "Signal CLI - Device Linking Mode"
    echo "========================================="
    echo "Device name: $DEVICE_NAME"
    echo ""
    echo "Starting linking process..."
    echo "Scan the QR code or enter the URL shown below in the Signal app on your phone."
    echo ""
    signal-cli link -n "$DEVICE_NAME"
    echo ""
    echo "========================================="
    echo "Linking complete!"
    echo "To start the daemon, set MODE=daemon and restart the container."
    echo "========================================="
elif [ "$MODE" = "daemon" ]; then
    echo "Starting Signal CLI in daemon mode..."
    exec signal-cli -a "$SIGNAL_NUMBER" daemon --http 0.0.0.0:8080
else
    echo "Error: MODE must be either 'link' or 'daemon'"
    exit 1
fi
