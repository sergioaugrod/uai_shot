defmodule UaiShot.Application do
  @moduledoc """
  Set the application.
  """

  use Application

  alias UaiShot.{GameServer, Repo, Store}
  alias Store.{Bullet, Player}
  alias UaiShotWeb.{Endpoint}

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(Repo, []),
      supervisor(Endpoint, []),
      worker(Player, []),
      worker(Bullet, []),
      worker(GameServer, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UaiShot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
