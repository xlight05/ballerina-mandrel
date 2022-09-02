# FROM ghcr.io/graalvm/native-image:ol8-java11-22.2.0 AS build
# COPY hello_svc.jar build/
# COPY jni-config.json build/
# COPY proxy-config.json build/
# COPY reflect-config.json build/
# COPY resource-config.json build/
# COPY serialization-config.json build/

# RUN cd build && native-image -jar hello_svc.jar \
#  --no-fallback \
#  --enable-url-protocols=http,https \
#  --initialize-at-build-time=org.slf4j \
#  --initialize-at-run-time=io.netty.handler.ssl.BouncyCastleAlpnSslUtils \
#  --initialize-at-run-time=io.netty.handler.codec.http2 \
#  --initialize-at-run-time=io.netty.handler.codec.compression.ZstdOptions \
#  --initialize-at-run-time=io.netty.handler.ssl.OpenSsl \
#  --initialize-at-run-time=io.netty.handler.ssl.OpenSslPrivateKeyMethod \
#  --initialize-at-run-time=io.netty.handler.ssl.ReferenceCountedOpenSslEngine  \
#  --initialize-at-run-time=io.netty.internal.tcnative \
#  --initialize-at-run-time=io.netty.handler.ssl.OpenSslAsyncPrivateKeyMethod \
#  -H:ResourceConfigurationFiles=resource-config.json \
#  -H:ReflectionConfigurationFiles=reflect-config.json\
#  -H:JNIConfigurationFiles=jni-config.json \
#  -H:DynamicProxyConfigurationFiles=proxy-config.json \
#  -H:SerializationConfigurationFiles=serialization-config.json \
#  -H:MaxDuplicationFactor=25.0 \
#  -H:Name=output


FROM ubuntu AS build

COPY hello_svc.jar build/
COPY jni-config.json build/
COPY proxy-config.json build/
COPY reflect-config.json build/
COPY resource-config.json build/
COPY serialization-config.json build/

RUN apt update
RUN apt upgrade -y
RUN apt install curl git g++ zlib1g-dev libfreetype6-dev lib32stdc++6 -y

RUN curl -sL https://github.com/graalvm/mandrel/releases/download/mandrel-22.2.0.0-Final/mandrel-java11-linux-amd64-22.2.0.0-Final.tar.gz -o mandrel-java11-linux-amd64-22.2.0.0-Final.tar.gz
RUN tar -xf mandrel-java11-linux-amd64-22.2.0.0-Final.tar.gz

RUN export TEMP_PATH=$(pwd)
ENV JAVA_HOME="/mandrel-java11-22.2.0.0-Final"
ENV GRAALVM_HOME="${JAVA_HOME}"
ENV PATH="${JAVA_HOME}/bin:${PATH}"

RUN cd build && native-image -jar hello_svc.jar \
 --no-fallback \
 --enable-url-protocols=http,https \
 --initialize-at-build-time=org.slf4j \
 --initialize-at-run-time=io.netty.handler.ssl.BouncyCastleAlpnSslUtils \
 --initialize-at-run-time=io.netty.handler.codec.http2 \
 --initialize-at-run-time=io.netty.handler.codec.compression.ZstdOptions \
 --initialize-at-run-time=io.netty.handler.ssl.OpenSsl \
 --initialize-at-run-time=io.netty.handler.ssl.OpenSslPrivateKeyMethod \
 --initialize-at-run-time=io.netty.handler.ssl.ReferenceCountedOpenSslEngine  \
 --initialize-at-run-time=io.netty.internal.tcnative \
 --initialize-at-run-time=io.netty.handler.ssl.OpenSslAsyncPrivateKeyMethod \
 -H:ResourceConfigurationFiles=resource-config.json \
 -H:ReflectionConfigurationFiles=reflect-config.json\
 -H:JNIConfigurationFiles=jni-config.json \
 -H:DynamicProxyConfigurationFiles=proxy-config.json \
 -H:SerializationConfigurationFiles=serialization-config.json \
 -H:MaxDuplicationFactor=25.0 \
 -H:Name=output

FROM alpine

ENV GLIBC_VERSION=2.35-r0

RUN apk add --no-cache libstdc++6

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    &&  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-$GLIBC_VERSION.apk" \
    &&  apk --no-cache add "glibc-$GLIBC_VERSION.apk" \
    &&  rm "glibc-$GLIBC_VERSION.apk" \
    &&  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-bin-$GLIBC_VERSION.apk" \
    &&  apk --no-cache add "glibc-bin-$GLIBC_VERSION.apk" \
    &&  rm "glibc-bin-$GLIBC_VERSION.apk" 
    # &&  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-i18n-$GLIBC_VERSION.apk" \
    # &&  apk --no-cache add "glibc-i18n-$GLIBC_VERSION.apk" \
    # &&  rm "glibc-i18n-$GLIBC_VERSION.apk"

COPY --from=build /build/output /

EXPOSE 9090

CMD ["/output"]

