# Use an official lightweight base image
FROM alpine:latest

# Install iperf3 and procps (for lightweight process checks)
RUN apk add --no-cache iperf3 procps \
  && adduser -S iperf

# Switch to the non-root user
USER iperf

# Expose the default iperf3 server ports for both TCP and UDP
EXPOSE 5201/tcp 5201/udp

# Use ENTRYPOINT to specify the binary, making the container behave like an iperf3 executable
ENTRYPOINT ["iperf3"]

# Default command: run in server mode
CMD ["-s"]

# Label for maintainer information
LABEL maintainer="inquisitor"

# Health check: check if the iperf3 process is running
# this reduces performance impact and log flooding
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD pgrep iperf3 || exit 1

