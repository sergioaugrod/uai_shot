defmodule UaiShot.Store.PlayerTest do
  use ExUnit.Case, async: true

  alias UaiShot.Store.Player

  setup_all do
    Player.start_link()
    :ok
  end

  setup do
    player = %{id: 1, nickname: "John", x: 1, y: 2, rotation: 1}
    Player.delete(player.id)
    [player: player]
  end

  describe "all/0" do
    test "return empty" do
      assert Player.all() == []
    end

    test "return list with one player", context do
      player = context.player
      Player.put(player)
      assert Player.all() == [player]
      Player.delete(player.id)
    end
  end

  describe "put/1" do
    test "store player", context do
      player = context.player
      assert Player.put(player) == :ok
      assert Player.get(player.id) == player
      Player.delete(player.id)
    end
  end

  describe "get/1" do
    test "return player with default attributes" do
      assert Player.get(1) == %{id: 1, nickname: 1}
    end

    test "return stored player", context do
      player = context.player
      Player.put(player)
      assert Player.get(1) == player
      Player.delete(player.id)
    end
  end

  describe "delete/1" do
    test "delete player by id", context do
      player = context.player
      Player.put(player)
      Player.delete(player.id)
      assert Player.get(player.id) == %{id: 1, nickname: 1}
    end
  end
end
