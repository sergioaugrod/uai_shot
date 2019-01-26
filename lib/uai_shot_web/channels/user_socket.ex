defmodule UaiShotWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel("game:lobby", UaiShotWeb.GameChannel)

  def connect(params, socket, _connect_info) do
    player_id = get_player_id(params["player_id"])
    nickname = get_nickname(params["nickname"])

    socket =
      socket
      |> assign(:nickname, nickname)
      |> assign(:player_id, player_id)

    {:ok, socket}
  end

  def id(socket), do: "users_socket:#{socket.assigns.player_id}"

  defp get_player_id(player_id) do
    if player_id, do: player_id, else: UUID.uuid4()
  end

  defp get_nickname(nickname) do
    if nickname && String.first(nickname), do: nickname, else: UUID.uuid4()
  end
end
