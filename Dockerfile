# Use lightweight Alpine as base
FROM alpine:latest

# Install git, OpenSSH server, and bash
RUN apk add --no-cache git openssh bash

# Create a 'git' user with a valid shell
RUN adduser -D -s /bin/sh git && \
    mkdir -p /home/git/.ssh && \
    chown -R git:git /home/git

# Copy startup script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Expose SSH on port 22 (to avoid port 22 conflicts with host)
EXPOSE 22

# Start the script
CMD ["/run.sh"]
