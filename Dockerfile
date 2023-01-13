FROM golang:1.19-alpine AS builder
RUN apk add sqlite-dev build-base

ENV HONK_VERSION honk-0.9.8

WORKDIR /tmp/src
RUN wget "https://humungus.tedunangst.com/r/honk/d/${HONK_VERSION}.tgz" -O honk.tgz
RUN tar -xvf honk.tgz
RUN mv "$HONK_VERSION" honk
RUN cd honk && go build -o /tmp/honk .

FROM alpine:3.17.1
RUN apk add sqlite sqlite-dev

WORKDIR /opt
COPY --from=builder /tmp/honk/ /bin/
COPY --from=builder /tmp/src/honk/views/ views/
COPY start-honk /bin

ENV HONK_VIEW_DIR "/opt/"
ENV HONK_DATA_DIR "/opt/data"

ENV HONK_USERNAME ""
ENV HONK_PASSWORD ""
ENV HONK_LISTEN_ADDR "0.0.0.0:80"
ENV HONK_SERVER_NAME ""
ENV HONK_MASQNAME ""

CMD ["/bin/start-honk"]
