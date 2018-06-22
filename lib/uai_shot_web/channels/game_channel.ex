defmodule UaiShotWeb.GameChannel do
  @moduledoc """
  Receive all the events of the game.
  """

  use Phoenix.Channel

  alias UaiShot.Store.{Bullet, Player, Ranking}

  def join("game:lobby", _message, socket) do
    {:ok, %{player_id: socket.assigns.player_id}, socket}
  end

  def join("game:" <> _private_game_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_player", state, socket) do
    state = format_state(state)
    nickname = socket.assigns.nickname
    player_id = socket.assigns.player_id

    state
    |> Map.put(:id, player_id)
    |> Map.put(:nickname, nickname)
    |> Player.put()

    Ranking.put(%{player_id: socket.assigns.player_id, nickname: nickname, value: 0})

    broadcast(socket, "update_players", %{players: Player.all()})
    broadcast(socket, "update_bullets", %{bullets: Bullet.all()})
    broadcast(socket, "update_ranking", %{ranking: Ranking.all()})

    {:noreply, socket}
  end

  def handle_in("move_player", state, socket) do
    state
    |> format_state
    |> Map.put(:id, socket.assigns.player_id)
    |> Map.put(:nickname, socket.assigns.nickname)
    |> Player.put()

    broadcast(socket, "update_players", %{players: Player.all()})

    {:noreply, socket}
  end

  def handle_in("shoot_bullet", state, socket) do
    state
    |> format_state
    |> Map.put(:player_id, socket.assigns.player_id)
    |> Bullet.push()

    broadcast(socket, "update_bullets", %{bullets: Bullet.all()})

    {:noreply, socket}
  end

  def terminate(_msg, socket) do
    player_id = socket.assigns.player_id
    Player.delete(player_id)
    Ranking.delete(player_id)

    broadcast(socket, "update_players", %{players: Player.all()})
    broadcast(socket, "update_ranking", %{ranking: Ranking.all()})
  end

  @spec format_state(Map.t()) :: Map.t()
  defp format_state(state) do
    for {key, val} <- state, into: %{}, do: {String.to_atom(key), val}
  end
end
