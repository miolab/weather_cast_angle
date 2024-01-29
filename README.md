# WeatherCastAngle

![elixir ci workflow](https://github.com/miolab/weather_cast_angle/actions/workflows/elixir-ci.yml/badge.svg)
![docker build workflow](https://github.com/miolab/weather_cast_angle/actions/workflows/docker-build.yml/badge.svg)

## Overview

This app is specifically designed to provide comprehensive information on tide levels, wind, weather, and more to help a fishing plan. :fish:

<small>Note: This repository and application are designed for **personal use** only.</small>

## Features

- Screenshot during development;

  <img width="607" alt="screenshot_during_development" src="https://github.com/miolab/weather_cast_angle/assets/33124627/6e37434d-09a4-40cb-8de4-be27cf313a9d">

- The information provided by this application;

  - Tide graph
  - Weather
  - Wind speed
  - Temperature
  - Moon age
  - Humidity
  - Seawater temperature

---

## Development information

### Pre-required

Can build the Docker image and launch the application using the following commands:

- Prepare `.env` file and set [OpenWeather](https://openweathermap.org/) API key (required)

```sh
cp .env.sample .env
```

- Run `mix git_hooks.install` to prepare local development

- Run `mix setup` to install and setup dependencies

### Start this application using docker container

To start the Phoenix server,

- Build the application container

```sh
docker build -t weather_cast_angle .
```

- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server` using docker;

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
