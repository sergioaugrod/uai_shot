defmodule UaiShotWeb.UserSocket do
  use Phoenix.Socket

  alias Ecto.UUID

  ## Channels
  # channel "room:*", UaiShotWeb.RoomChannel
  channel "game:lobby", UaiShotWeb.GameChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  def connect(params, socket) do
    player_id = UUID.generate()
    nickname = params["nickname"]

    nickname = if nickname && String.first(nickname) do
      params["nickname"]
    else
      player_id
    end

    socket =
      socket
      |> assign(:nickname, nickname)
      |> assign(:player_id, player_id)

    {:ok, socket}
  end

  def id(socket), do: "users_socket:#{socket.assigns.player_id}"
end
