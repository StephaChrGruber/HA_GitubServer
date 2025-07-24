FROM alpine:latest

RUN apk add --no-cache git openssh bash

# Create git user
RUN adduser -D git && \
    mkdir -p /home/git/.ssh && \
    chown -R git:git /home/git

WORKDIR /home/git

COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 22

CMD ["/run.sh"]
