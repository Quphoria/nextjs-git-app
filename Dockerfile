FROM alpine:3.14
ARG TARGETPLATFORM

RUN apk add --no-cache dos2unix nodejs npm curl git bash openssh

# we need build tools on arm for building node modules
RUN if [[ $TARGETPLATFORM == linux/arm* ]]; then \
    apk add --no-cache make gcc g++; \
  fi

WORKDIR /

COPY docker-entrypoint.sh .
RUN dos2unix docker-entrypoint.sh

ARG VERSION
RUN echo ${VERSION} >> VERSION

EXPOSE 3000

LABEL org.opencontainers.image.authors="quphoria.dev@gmail.com"

ENV REPO_URL= \
    REPO_ACCESS_TOKEN=

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -s --fail http://localhost:3000 || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]