FROM golang:alpine as build
WORKDIR /go/src/zvelo.io/oauth2_proxy
COPY . .
RUN go install -v

FROM alpine:latest
MAINTAINER Joshua Rubin <jrubin@zvelo.com>
RUN apk add --no-cache ca-certificates
ENTRYPOINT ["oauth2_proxy"]
CMD [ "--upstream=http://0.0.0.0:8080/", "--http-address=0.0.0.0:4180" ]
COPY --from=build /go/bin/oauth2_proxy /usr/local/bin/oauth2_proxy
