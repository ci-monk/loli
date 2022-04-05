FROM golang:1.16-alpine3.12 as builder
RUN apk add --no-cache alpine-sdk=1.0-r0
WORKDIR /build
COPY [ ".", "." ]
RUN make build

FROM alpine:3.15.4 as release
RUN apk --no-cache add \
  ca-certificates=20191127-r7 \
  bash=5.1.8-r0 \
  bash-completion=2.11-r4 && \
  echo "source <(loli completion bash)" >> ~/.bashrc
COPY --from=builder [ "/build/bin/loli", "/usr/local/bin/loli" ]
RUN chmod +x /usr/local/bin/loli
CMD ["loli"]
