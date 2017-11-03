defmodule UaiShot.Store.Ranking do
  @moduledoc """
  Store the state of the game ranking.
  """

  use Agent

  @doc """
  Start Store.
  """
  @spec start_link() :: :ok
  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
  Return ranking.
  """
  @spec all() :: List.t
  def all do
    Agent.get(__MODULE__, fn players ->
      players
      |> Map.to_list
      |> Enum.map(&elem(&1, 1))
      |> Enum.sort_by(&(&1.value))
    end)
  end

  @doc """
  Update or insert a ranking position.
  """
  @spec put(Map.t) :: :ok
  def put(position) do
    Agent.update(__MODULE__, &Map.put(&1, position.player_id, position))
  end

  @doc """
  Get ranking position by player_id.
  """
  @spec get(String.t) :: Map.t
  def get(player_id) do
    Agent.get(__MODULE__, &Map.get(&1, player_id, %{player_id: player_id, value: 0}))
  end

  @doc """
  Delete ranking position by player_id.
  """
  @spec delete(String.t) :: :ok
  def delete(player_id) do
    Agent.update(__MODULE__, &Map.delete(&1, player_id))
  end
end
