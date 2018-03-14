FROM golang:latest as build
ENV CGO_ENABLED=0
RUN go get -v github.com/golang/dep/cmd/dep
RUN go get -d -v github.com/bitly/oauth2_proxy
WORKDIR /go/src/github.com/bitly/oauth2_proxy
RUN dep ensure
RUN go install -v

FROM alpine:latest
MAINTAINER Joshua Rubin <jrubin@zvelo.com>
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
ENTRYPOINT ["oauth2_proxy"]
CMD [ "--upstream=http://0.0.0.0:8080/", "--http-address=0.0.0.0:4180" ]
EXPOSE 8080 4180
COPY --from=build /go/bin/oauth2_proxy /usr/local/bin/oauth2_proxy
