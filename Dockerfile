FROM alpine AS sdk

RUN apk add curl unzip

ENV FLEXSDK_VERSION 3.6a
RUN curl -fL -o /tmp/flexsdk.zip http://download.macromedia.com/pub/flex/sdk/flex_sdk_${FLEXSDK_VERSION}.zip \
    && unzip /tmp/flexsdk.zip -d /usr/lib/flex3 \
    && rm -rf /tmp/*

FROM ubuntu:jammy

# Install Dependencies
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get install -y  --no-install-recommends \
            default-jdk \
            ant \
    && apt-get purge -y --auto-remove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
              /tmp/*

ENV PATH /usr/lib/flex3/bin:$PATH
COPY --from=sdk /usr/lib/flex3 /usr/lib/flex3
