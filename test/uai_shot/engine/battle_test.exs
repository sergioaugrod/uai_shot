defmodule UaiShot.Engine.BattleTest do
  use UaiShotWeb.ChannelCase

  alias UaiShot.Engine.Battle
  alias UaiShot.Store.{Bullet, Player, Ranking}
  alias UaiShotWeb.GameChannel
  alias UaiShotWeb.UserSocket

  setup do
    Bullet.reset([])
    Player.clean()
    Ranking.clean()

    {:ok, _, socket} =
      UserSocket
      |> socket("1", %{player_id: 1})
      |> subscribe_and_join(GameChannel, "game:lobby")

    [socket: socket]
  end

  describe "run/0" do
    test "broadcast empty bullets" do
      Battle.run()
      assert_broadcast("update_bullets", %{bullets: []})
    end

    test "broadcast bullets" do
      bullet = %{player_id: 1, x: 1, y: 2, rotation: 1, speed_x: 1, speed_y: 2}
      Bullet.push(bullet)

      Battle.run()

      assert_broadcast(
        "update_bullets",
        %{bullets: [%{player_id: 1, x: 2, y: 4, rotation: 1, speed_x: 1, speed_y: 2}]}
      )
    end

    test "hit player and update ranking" do
      player = %{id: 1, nickname: "John", x: 1, y: 2, rotation: 1}
      player2 = %{id: 2, nickname: "Bruce", x: 1, y: 10, rotation: 1}

      bullet = %{player_id: 1, x: 1, y: 10, rotation: 1, speed_x: 1, speed_y: 2}

      Bullet.push(bullet)
      Player.put(player)
      Player.put(player2)

      assert_broadcast(
        "update_ranking",
        %{
          ranking: [
            %{nickname: "John", player_id: 1, value: 10},
            %{nickname: "Bruce", player_id: 2, value: -10}
          ]
        }
      )

      assert_broadcast("hit_player", %{player_id: 2})
    end
  end
end
