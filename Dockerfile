FROM elixir:1.15.7-slim

WORKDIR /app

COPY mix.exs mix.lock ./
COPY config config

RUN mix deps.get
RUN mix deps.compile

COPY lib lib
COPY priv priv
COPY assets assets

RUN mix do compile, phx.digest

CMD ["mix", "phx.server"]
