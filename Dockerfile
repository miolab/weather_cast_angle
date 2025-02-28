FROM node:22.14.0-alpine AS node-builder

WORKDIR /app/assets
COPY assets/package*.json ./
RUN npm i chart.js dayjs

FROM elixir:1.18.2-slim

RUN apt-get update && apt-get install -y git inotify-tools \
  python3.11 python3-pip python3.11-venv
RUN ln -s /usr/bin/python3 /usr/bin/python

WORKDIR /app

COPY mix.exs mix.lock ./
COPY config config

RUN mix deps.get
RUN mix deps.compile

COPY lib lib
COPY priv priv
COPY assets assets
COPY --from=node-builder /app/assets/node_modules assets/node_modules

RUN mix do compile, phx.digest

# In compliance with PEP 668, create a virtual environment and install Python packages in it.
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip3 install "erlport>=0.6"
RUN pip3 install "ephem>=4.1,<5.0"

CMD ["mix", "phx.server"]
