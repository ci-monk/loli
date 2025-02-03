FROM golang:1.20.4-alpine3.16 as builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o loli ./cmd/loli/main.go

FROM alpine:3.21
WORKDIR /app
COPY --from=builder /app/loli ./
ENTRYPOINT [ "/app/loli" ]
