FROM elixir:1.16.0-slim

RUN apt-get update && apt-get install -y git inotify-tools \
  python3 python3-pip

WORKDIR /app

COPY mix.exs mix.lock ./
COPY config config

RUN mix deps.get
RUN mix deps.compile

COPY lib lib
COPY priv priv
COPY assets assets

RUN mix do compile, phx.digest

RUN pip3 install erlport

CMD ["mix", "phx.server"]
