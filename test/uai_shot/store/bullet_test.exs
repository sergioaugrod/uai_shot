defmodule UaiShot.Store.BulletTest do
  use ExUnit.Case

  alias UaiShot.Store.Bullet

  setup do
    Bullet.reset([])
    :ok
  end

  describe "all/0" do
    test "return empty" do
      assert Bullet.all() == []
    end

    test "return list with one bullet" do
      bullet = %{player_id: 1, x: 1, y: 2, rotation: 1, speed_x: 1, speed_y: 2}
      Bullet.push(bullet)
      assert Bullet.all() == [bullet]
    end
  end

  describe "reset/1" do
    test "reset bullet to empty" do
      bullet = %{player_id: 5, x: 3, y: 5, rotation: 1, speed_x: 1, speed_y: 2}
      Bullet.push(bullet)
      Bullet.reset([])
      assert Bullet.all() == []
    end
  end

  describe "push/1" do
    test "push bullet to store" do
      bullet = %{player_id: 10, x: 1, y: 2, rotation: 1, speed_x: 1, speed_y: 2}
      bullet2 = %{player_id: 11, x: 1, y: 2, rotation: 1, speed_x: 1, speed_y: 2}
      Bullet.push(bullet)
      Bullet.push(bullet2)
      assert Bullet.all() == [bullet, bullet2]
    end
  end
end
