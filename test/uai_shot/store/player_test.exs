defmodule UaiShot.Store.PlayerTest do
  use ExUnit.Case, async: true

  alias UaiShot.Store.Player

  setup do
    Player.start_link()
    :ok
  end

  describe "all/0" do
    test "return empty" do
      assert Player.all() == []
    end

    test "return list with one player" do
      player = %{id: 1, nickname: "John", x: 1, y: 2, rotation: 1}
      Player.put(player)
      assert Player.all() == [player]
      Player.delete(player.id)
    end
  end

  describe "put/1" do
    test "store player" do
      player = %{id: 400, nickname: "Snow", x: 7, y: 10, rotation: 10}
      assert Player.put(player) == :ok
      assert Player.get(player.id) == player
      Player.delete(player.id)
    end
  end

  describe "get/1" do
    test "return player with default attributes" do
      assert Player.get(1) == %{id: 1, nickname: 1}
    end

    test "return stored player" do
      player = %{id: 100, nickname: "Sergio", x: 5, y: 3, rotation: 5}
      Player.put(player)
      assert Player.get(100) == player
      Player.delete(player.id)
    end
  end

  describe "delete/1" do
    test "delete player by id" do
      player = %{id: 100, nickname: "Sergio", x: 5, y: 3, rotation: 5}
      Player.put(player)
      Player.delete(player.id)
      assert Player.get(100) == %{id: 100, nickname: 100}
    end
  end
end
