defmodule UaiShot.Store.RankingTest do
  use ExUnit.Case

  alias UaiShot.Store.{Player, Ranking}

  setup do
    ranking = %{player_id: 1, nickname: "Bruce", value: 0}
    Player.clean()
    Ranking.clean()
    [ranking: ranking]
  end

  describe "all/0" do
    test "return empty" do
      assert Ranking.all() == []
    end

    test "return list with one ranking", context do
      ranking = context.ranking
      Ranking.put(ranking)
      assert Ranking.all() == [ranking]
      Ranking.delete(ranking.player_id)
    end
  end

  describe "put/1" do
    test "store ranking", context do
      ranking = context.ranking
      assert Ranking.put(ranking) == :ok
      assert Ranking.get(ranking.player_id) == ranking
      Ranking.delete(ranking.player_id)
    end
  end

  describe "get/1" do
    test "return ranking with default attributes" do
      assert Ranking.get(1) == %{player_id: 1, nickname: 1, value: 0}
    end

    test "return stored ranking", context do
      ranking = context.ranking
      Ranking.put(ranking)
      assert Ranking.get(1) == ranking
      Ranking.delete(ranking.player_id)
    end
  end

  describe "delete/1" do
    test "delete ranking by player_id", context do
      ranking = context.ranking
      Ranking.put(ranking)
      Ranking.delete(ranking.player_id)
      assert Ranking.get(ranking.player_id) == %{player_id: 1, nickname: 1, value: 0}
    end
  end

  describe "clean/0" do
    test "clean ranking positions" do
      Ranking.clean()
      assert Ranking.all() == []
    end
  end
end
