# Signal CLI Setup Guide

## Step 1: Link as Secondary Device

First, you need to link signal-cli as a secondary device to your Signal account.

1. Make sure the external volume and network exist:
   ```bash
   docker volume create signal-data
   docker network create signal
   ```

2. Set the device name (optional, defaults to "signal-cli"):
   ```bash
   export DEVICE_NAME="MySignalBot"
   ```

3. Start the container in link mode:
   ```bash
   docker compose -f docker-compose.signal.yml up
   ```

4. The container will display a linking URL. You have two options:
   - Scan the QR code displayed in the terminal (if your terminal supports it)
   - Copy the `tsdevice://` URL and enter it in Signal app:
     - Open Signal on your phone
     - Go to Settings → Linked Devices → Link New Device
     - Click the menu (⋮) and select "Link by URL"
     - Paste the URL

5. Once linking is complete, the container will exit. Press Ctrl+C if needed.

## Step 2: Run in Daemon Mode

After successfully linking, you can run signal-cli in daemon mode to send/receive messages.

1. Set the MODE to daemon and provide your phone number:
   ```bash
   export MODE=daemon
   export SIGNAL_NUMBER="+1234567890"  # Your phone number in E.164 format
   ```

2. Start the container:
   ```bash
   docker compose -f docker-compose.signal.yml up -d
   ```

3. The Signal CLI daemon will be available at `http://localhost:8086`

## Switching Between Modes

To switch modes, update the environment variables in your shell or in a `.env` file:

### Link Mode (default)
```bash
MODE=link
```

### Daemon Mode
```bash
MODE=daemon
SIGNAL_NUMBER="+1234567890"
```

## Environment Variables

- `MODE`: Either `link` (for initial setup) or `daemon` (for normal operation)
- `DEVICE_NAME`: Name for the linked device (default: "signal-cli")
- `SIGNAL_NUMBER`: Your phone number in E.164 format (required for daemon mode)
- `SIGNAL_CLI_VERSION`: Version of signal-cli to use (default: set in Dockerfile)

## Troubleshooting

- If linking fails, make sure the `signal-data` volume is properly mounted
- The linked device data is stored in the `signal-data` volume and persists between container restarts
- To re-link, you'll need to clear the data volume or unlink the device from your phone first
