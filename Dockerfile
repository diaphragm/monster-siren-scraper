FROM ruby:3.1-slim
WORKDIR /develop
RUN apt update && apt install -y build-essential libtag1-dev
