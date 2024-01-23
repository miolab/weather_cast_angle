# WeatherCastAngle

![elixir ci workflow](https://github.com/miolab/weather_cast_angle/actions/workflows/elixir-ci.yml/badge.svg)
![docker build workflow](https://github.com/miolab/weather_cast_angle/actions/workflows/docker-build.yml/badge.svg)

## Overview

This app is specifically designed to provide comprehensive information on tide levels, wind, weather, and more to help a fishing plan. :fish:

Note: This repository and application are designed for **personal use** only.

## Features

[WIP]

- Screenshot during development

  <img width="599" alt="screenshot_during_development" src="https://github.com/miolab/weather_cast_angle/assets/33124627/7f6e3388-61d3-4517-9463-763aad64b26d">

---

## Development information

### Pre-required

Can build the Docker image and launch the application using the following commands:

- Prepare `.env` file and set [OpenWeather](https://openweathermap.org/) API key (required)

  ```sh
  cp .env.sample .env
  ```

- To start your Phoenix server:

  - Run `mix setup` to install and setup dependencies

  - Run `mix git_hooks.install` to prepare local development.

  - Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

### Start app using docker container

```sh
docker build -t weather_cast_angle .
```

```sh
docker run --rm -p 4000:4000 \
-v $(pwd):/app \
-e OPEN_WEATHER_API_KEY=$(cat .env | grep OPEN_WEATHER_API_KEY | cut -d '=' -f2) \
--name weather_cast_angle \
weather_cast_angle
```

- If want to run `iex -S mix`;

  ```sh
  docker exec -it weather_cast_angle iex -S mix
  ```

### Official References

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

- Learn more
  - Official website: https://www.phoenixframework.org/
  - Guides: https://hexdocs.pm/phoenix/overview.html
  - Docs: https://hexdocs.pm/phoenix
  - Forum: https://elixirforum.com/c/phoenix-forum
  - Source: https://github.com/phoenixframework/phoenix
