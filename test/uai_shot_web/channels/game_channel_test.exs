defmodule UaiShotWeb.GameChannelTest do
  use UaiShotWeb.ChannelCase

  alias UaiShotWeb.GameChannel
  alias UaiShot.Store.{Bullet, Player, Ranking}

  setup do
    Bullet.reset([])
    Player.clean()
    Ranking.clean()

    {:ok, _, socket} = socket("10", %{player_id: 10, nickname: "John"})
    |> subscribe_and_join(GameChannel, "game:lobby")
    [socket: socket]
  end

  test "push new_player event", context do
    push context.socket, "new_player", %{"rotation" => 0, "x" => 400, "y" => 30}

    assert_broadcast "update_players",
      %{players: [%{id: 10, nickname: "John", rotation: 0, x: 400, y: 30}]}

    assert_broadcast "update_bullets",
      %{bullets: []}

    assert_broadcast "update_ranking",
      %{ranking: [%{nickname: "John", player_id: 10, value: 0}]}
  end

  test "push move_player event", context do
    push context.socket, "move_player", %{"rotation" => 0, "x" => 600, "y" => 40}

    assert_broadcast "update_players",
      %{players: [%{id: 10, nickname: "John", rotation: 0, x: 600, y: 40}]}
  end

  test "push shoot_bullet event", context do
    push context.socket, "shoot_bullet",
      %{"rotation" => 0.5235987755982988, "speed_x" => 17.320508075688775,
        "speed_y" => 9.999999999999998, "x" => 400, "y" => 30}

    assert_broadcast "update_bullets",
      %{bullets: [%{player_id: 10, rotation: 0.5235987755982988,
                    speed_x: 17.320508075688775, speed_y: 9.999999999999998, x: 400, y: 30}]}
  end
end
