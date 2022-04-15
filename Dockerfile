FROM golang:alpine
RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup
#Working directory in docker
WORKDIR $GOPATH/src/gin_docker
#Synchronize the current directory to the docker working directory, or configure only the required directories and files (configuration directory, compiled program, etc.)
ADD . ./
#For well-known reasons, some packages will have download timeouts. The proxy service of go module is also used in docker
ENV GOPROXY="https://goproxy.io"
RUN apk update; apk add git # Required for go 1.18 vcs stamping
#Specify the file name after compilation. You can use the default file name without setting. The last step is to execute the file name
RUN go build -o gin_docker .
EXPOSE 8080
RUN chown -R appuser:appgroup /app
USER 1000
#This is consistent with the compiled file name
ENTRYPOINT  ["./gin_docker"]
