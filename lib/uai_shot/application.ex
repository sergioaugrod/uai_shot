defmodule UaiShot.Application do
  @moduledoc false

  use Application

  alias UaiShot.{GameServer}
  alias UaiShot.Store.{Bullet, Player, Ranking}
  alias UaiShotWeb.{Endpoint}

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      Endpoint,
      {Bullet, []},
      {Player, %{}},
      {Ranking, %{}},
      {GameServer, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_all, name: UaiShot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
