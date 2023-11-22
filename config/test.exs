import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :weather_cast_angle, WeatherCastAngleWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "xJTJo4R6fTHiZlk5Zwg9XdFEkUYJEv708noWCuX8Xm8kdufI/afRxX9wFgmw4SGq",
  server: false

# In test we don't send emails.
config :weather_cast_angle, WeatherCastAngle.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
