docker build -t mandrel-alpine-dynamic-glibc  -f Dockerfile.alpine-dynamic-glibc .   #
docker build -t mandrel-alpine-static-glibc  -f Dockerfile.alpine-static-glibc .
# docker build -t mandrel-alpine-static-musl  -f Dockerfile.alpine-static-musl .

docker build -t mandrel-scratch-static-glibc  -f Dockerfile.scratch-static-glibc .
# docker build -t scratch-static-musl  -f Dockerfile.scratch-static-musl .

docker build -t mandrel-distroless-dynamic  -f Dockerfile.distroless-dynamic .
docker build -t mandrel-distroless-static  -f Dockerfile.distroless-mostly-static .

docker build -t mandrel-debian-dynamic-glibc  -f Dockerfile.debian-dynamic-glibc .
docker build -t mandrel-debian-static-glibc  -f Dockerfile.debian-static-glibc .

docker run -d -p 9090:9090 mandrel-alpine-dynamic-glibc
docker run -d -p 9091:9090 mandrel-alpine-static-glibc

docker run -d -p 9092:9090 mandrel-scratch-static-glibc

docker run -d -p 9093:9090 mandrel-distroless-dynamic
docker run -d -p 9094:9090 mandrel-distroless-static 

docker run -d -p 9095:9090 mandrel-debian-dynamic-glibc 
docker run -d -p 9096:9090 mandrel-debian-static-glibc
