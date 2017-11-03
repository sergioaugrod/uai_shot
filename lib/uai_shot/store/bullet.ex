defmodule UaiShot.Store.Bullet do
  @moduledoc """
  Store the state of the game bullets.
  """

  use Agent

  @doc """
  Start Store.
  """
  @spec start_link() :: :ok
  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  @doc """
  Return all game bullets.
  """
  @spec all() :: List.t
  def all do
    Agent.get(__MODULE__, fn players -> players end)
  end

  @doc """
  Start a new state.
  """
  @spec reset(List.t) :: :ok
  def reset(bullets) do
    Agent.update(__MODULE__, fn _ -> bullets end)
  end

  @doc """
  Push a bullet to state.
  """
  @spec push(Map.t) :: :ok
  def push(bullet) do
    Agent.update(__MODULE__, &List.insert_at(&1, -1, bullet))
  end
end
