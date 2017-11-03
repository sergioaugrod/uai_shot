defmodule UaiShotWeb.GameChannel do
  @moduledoc """
  Receive all the events of the game.
  """

  use Phoenix.Channel

  alias UaiShot.Store.{Bullet, Player, Ranking}
  alias Ecto.UUID

  def join("game:lobby", _message, socket) do
    player_id = UUID.generate()
    {:ok, %{player_id: player_id}, assign(socket, :player_id, player_id)}
  end

  def join("game:" <> _private_game_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_player", state, socket) do
    state
    |> format_state
    |> Map.put(:id, socket.assigns.player_id)
    |> Player.put

    broadcast(socket, "update_players", %{players: Player.all})
    broadcast(socket, "update_bullets", %{bullets: Bullet.all})

    {:noreply, socket}
  end

  def handle_in("move_player", state, socket) do
    state
    |> format_state
    |> Map.put(:id, socket.assigns.player_id)
    |> Player.put

    broadcast(socket, "update_players", %{players: Player.all})

    {:noreply, socket}
  end

  def handle_in("shoot_bullet", state, socket) do
    state
    |> format_state
    |> Map.put(:player_id, socket.assigns.player_id)
    |> Bullet.push

    broadcast(socket, "update_bullets", %{bullets: Bullet.all})

    {:noreply, socket}
  end

  def terminate(_msg, socket) do
    player_id = socket.assigns.player_id
    Player.delete(player_id)
    Ranking.delete(player_id)

    broadcast(socket, "update_players", %{players: Player.all})
  end

  @spec format_state(Map.t) :: Map.t
  defp format_state(state) do
    for {key, val} <- state, into: %{}, do: {String.to_atom(key), val}
  end
end
