import Config

config :uai_shot, UaiShotWeb.Endpoint,
  url: [host: System.get_env("APP_NAME") <> ".gigalixirapp.com", port: 80],
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "80")],
  secret_key_base: System.get_env("SECRET_KEY_BASE")
