FROM haskell:8.6.5
LABEL group="file"

RUN mkdir -p /opt/app
WORKDIR /opt/app

RUN cabal update && cabal install ansi-terminal
RUN apt-get update
RUN apt-get install nano