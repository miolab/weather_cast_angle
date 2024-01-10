FROM elixir:1.16.0-slim

RUN apt-get update && apt-get install -y git inotify-tools \
  python3 python3-pip
RUN ln -s /usr/bin/python3 /usr/bin/python

WORKDIR /app

COPY mix.exs mix.lock ./
COPY config config

RUN mix deps.get
RUN mix deps.compile

COPY lib lib
COPY priv priv
COPY assets assets

RUN mix do compile, phx.digest

RUN pip3 install "erlport>=0.6" "ephem>=4.1,<5.0"

CMD ["mix", "phx.server"]
