FROM golang:alpine as grpcurl

RUN apk update \
  && apk add --virtual build-dependencies git \
  && apk add bash curl jq \
  && go install github.com/fullstorydev/grpcurl@latest \
  && go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest

FROM alpine:latest
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories && \
    apk update && \
    apk add --no-cache vim bash tcpdump curl wget strace mysql-client iproute2 redis jq iftop tzdata tar nmap bind-tools htop && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN wget -O /usr/bin/httpstat https://github.com/davecheney/httpstat/releases/download/v1.0.0/httpstat-linux-amd64-v1.0.0 && \
    chmod +x /usr/bin/httpstat
COPY --from=grpcurl  /go/bin/grpcurl /usr/bin/grpcurl
ENV TZ=Asia/Shanghai LC_ALL=C.UTF-8 LANG=C.UTF-8 LANGUAGE=C.UTF-8
ENTRYPOINT [ "/bin/bash" ]
