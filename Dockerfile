ARG GOVERSION
FROM golang:$GOVERSION-alpine
RUN apk add --no-cache git && go get -u golang.org/x/lint/golint
RUN mv /go/bin/* /usr/local/go/bin
RUN mkdir /.cache && chmod 777 /.cache
