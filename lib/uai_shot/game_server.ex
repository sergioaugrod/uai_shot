defmodule UaiShot.GameServer do
  @moduledoc """
  GameServer loop. Executes all game engines.
  """

  use GenServer

  alias UaiShot.Engine.Battle

  @worker_interval 20

  @doc """
  Start GameServer.
  """
  @spec start_link(Keyword.t()) :: :ok
  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
  Initialize GameServer scheduler.
  """
  @spec init(Keyword.t()) :: {:ok, Keyword.t()}
  def init(state) do
    :timer.send_interval(@worker_interval, :work)
    {:ok, state}
  end

  @doc """
  Executes all game engines.
  """
  @spec handle_info(:work, Keyword.t()) :: {:noreply, Keyword.t()}
  def handle_info(:work, state) do
    Battle.run()
    {:noreply, state}
  end
end
