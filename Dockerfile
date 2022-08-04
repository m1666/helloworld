FROM --platform=amd64 golang:1.16 as builder

WORKDIR /data
ENV GOPROXY=https://goproxy.cn,direct
ENV CGO_ENABLED=0



ADD go.mod .
ADD go.sum .

RUN go mod download

COPY . .
RUN go build -o helloworld && ls /data

FROM --platform=amd64 alpine:3.13 as final

EXPOSE 80
WORKDIR /app

RUN apk add --no-cache tzdata
ENV TZ Asia/Shanghai

COPY --from=builder /data/helloworld /bin/helloworld

ENTRYPOINT [ "/bin/helloworld" ]
