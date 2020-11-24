# Experiments with building [Go](https://golang.org/) in Docker on Mac

There are a number of examples knocking around, but piecing them together into something working took longer than it should've, hence this repo.

## Non Docker build (don't try this at home)

First step is to read up a bit on how to build outside of Docker (but not actually install anything). Digital Ocean have a good intro [here](https://www.digitalocean.com/community/tutorials/how-to-build-and-install-go-programs).

So the ubiquitous hello.go is:

```
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
```

Executed with

`go run main.go` 

which will [fetch the packages](https://golang.org/pkg/cmd/go/internal/get/) needed and install them locally. Then

`go run hello.go`

Then to create an executable:

`go build hello.go` 

There's also a `go install hello.go` to put exe files into $GOPATH/bin etc

Note that you can follow these commands with `./..` [which is like a Go */* wildcard](https://stackoverflow.com/questions/28031603/what-do-three-dots-mean-in-go-command-line-invocations).

## Docker build (do try this at home)

So enough background, onto a much better way to build and run Go, using the containerisation powers of Docker. There are a few resoruces like the [official golang image](https://hub.docker.com/_/gola). There are some useful bits in [here](https://levelup.gitconnected.com/complete-guide-to-create-docker-container-for-your-golang-application-80f3fb59a15e) and [here](https://github.com/qorbani/docker-golang-hello-world) too.

This was probably the most useful [Docker + Golang](https://www.docker.com/blog/docker-golang/) resource covering more of the cross-compilation options that will allow us to compile and build in Docker and generate a Mac executable.

First step is to create a Dockerfile.
You can run the compile build etc commands from the Dockerfile (commented out in this repo), and then build the Docker image from the command line with

`Docker build . -t nicksgolang`

Next run the image with

`docker run -it --rm --name insert-random-container-name nicksgolang`

This will open an interactive shell in the docker container based on the `nicksgolang` Docker image.

You can run the commands listed at the top of this README now.

We could install [nano](https://www.nano-editor.org/) in the image to edit the `hello.go` inside the shell, or more easily mount the local drive and edit in eg [VSCode on Mac](https://code.visualstudio.com/download). So to do this we instead run

`docker run -it --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp --name insert-random-container-name nicksgolang`

Now we can edit the message in `hello.go` and rebuild in the Docker shell and see the change.

## Cross compiling Golang in a Docker image

You will have noticed that the Dockerfile has a couple of environment variables set, you can see these in the shell by entering `printenv`, they are `GOOS` and `GOARCH`.

We have them set to `darwin` and `amd64` so the generated `./hello` binary is executable in a Mac terminal, but not in the Docker shell. Hence we have [cross compiled](https://en.wikipedia.org/wiki/Cross_compiler). 

## Docker Compose with Golang and Docker on Mac

Finally, we want to use the power of [docker-compose](https://docs.docker.com/compose/) to make it easier to manage our containers. For this we add a `docker-compose.yml` file which includes the volume mapping and a command line, in this case:

`command: sh -c "go get -d -v ./...  && go build -v ./... "`

Which gets the dependencies and builds the cross compiled binary for us. If we've modified the Dockerfile, rebuild the image with 

`Docker build . -t nicksgolang`

Then run with (--build flag rebuilds too)

`docker-compose up `

Check in the current directory for the freshly generated executable.

[QED](https://en.wikipedia.org/wiki/Q.E.D.)