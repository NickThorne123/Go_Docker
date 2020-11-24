FROM golang:1.14
ENV GOOS=darwin \
    GOARCH=amd64

WORKDIR /go/src/hello
COPY . .

# RUN touch afile.txt
# RUN cat nt.txt
# RUN go get -d -v ./...
# RUN go install -v ./...
# CMD ["hello"]