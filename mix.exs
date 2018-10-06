defmodule UaiShot.Mixfile do
  use Mix.Project

  def project do
    [
      app: :uai_shot,
      version: "0.2.0",
      elixir: "~> 1.7.3",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {UaiShot.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:credo, "~> 0.10", only: [:dev, :test], runtime: false},
      {:cowboy, "~> 1.0"},
      {:distillery, "~> 2.0"},
      {:phoenix, "~> 1.3.4"},
      {:phoenix_html, "~> 2.12"},
      {:phoenix_live_reload, "~> 1.1.6", only: :dev},
      {:phoenix_pubsub, "~> 1.1"},
      {:uuid, "~> 1.1"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      test: ["test"]
    ]
  end
end
