# ipmi-server-standalone docker image

This is a docker image to run `ipmi-server` as a standalone image.

    docker pull ghcr.io/ateodorescu/ipmi-server-standalone:latest

# Run the container

    docker run -d -p 9595:80 --name ipmi-server-standalone ghcr.io/ateodorescu/ipmi-server-standalone:latest