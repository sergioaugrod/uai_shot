defmodule UaiShot.Store.Ranking do
  @moduledoc """
  Store the state of the game ranking.
  """

  use Agent

  alias UaiShot.Store.Player

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
      |> Enum.sort(&(&1.value > &2.value))
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
    Agent.get(__MODULE__, &Map.get(&1, player_id, default_attrs(player_id)))
  end

  @doc """
  Delete ranking position by player_id.
  """
  @spec delete(String.t) :: :ok
  def delete(player_id) do
    Agent.update(__MODULE__, &Map.delete(&1, player_id))
  end

  @doc """
  Clean ranking positions.
  """
  @spec clean() :: :ok
  def clean() do
    Agent.update(__MODULE__, fn _ -> %{} end)
  end

  @spec default_attrs(String.t) :: Map.t
  defp default_attrs(player_id) do
    nickname = Player.get(player_id).nickname
    %{player_id: player_id, nickname: nickname, value: 0}
  end
end
