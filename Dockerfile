FROM golang:1.11.5 as builder

WORKDIR /go/src/github.com/gregory-vc/vessel-service

COPY . .

RUN go build

FROM alpine:latest

RUN apk --no-cache add ca-certificates

RUN mkdir /app
WORKDIR /app
COPY --from=builder /go/src/github.com/gregory-vc/vessel-service/vessel-service .

CMD ["./vessel-service"]
