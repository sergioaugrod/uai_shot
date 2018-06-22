defmodule UaiShot.Engine.Battle do
  @moduledoc """
  Game battle logic.
  """

  alias UaiShot.Store.{Bullet, Player, Ranking}
  alias UaiShotWeb.Endpoint

  @game_width 800
  @game_height 600

  @doc """
  Run game battle logic.
  """
  @spec run() :: :ok
  def run do
    bullets =
      Bullet.all()
      |> Enum.map(&move_bullet(&1))
      |> Enum.reject(&bullet_is_far?(&1))

    Bullet.reset(bullets)
    Endpoint.broadcast("game:lobby", "update_bullets", %{bullets: bullets})
  end

  @spec move_bullet(Map.t()) :: Map.t()
  defp move_bullet(bullet) do
    bullet
    |> hited_players
    |> Enum.each(&process_hit(bullet, &1))

    bullet
    |> Map.put(:x, bullet.x + bullet.speed_x)
    |> Map.put(:y, bullet.y + bullet.speed_y)
  end

  @spec process_hit(Map.t(), Map.t()) :: :ok
  defp process_hit(bullet, player) do
    update_ranking(bullet.player_id, 10)
    update_ranking(player.id, -10)

    Endpoint.broadcast("game:lobby", "update_ranking", %{ranking: Ranking.all()})
    Endpoint.broadcast("game:lobby", "hit_player", %{player_id: player.id})
  end

  @spec update_ranking(String.t(), Integer.t()) :: :ok
  defp update_ranking(player_id, value) do
    player_id
    |> Ranking.get()
    |> Map.update!(:value, &(&1 + value))
    |> Ranking.put()
  end

  @spec bullet_is_far?(Map.t()) :: Boolean.t()
  defp bullet_is_far?(bullet) do
    bullet.x < -10 || bullet.x > @game_width || bullet.y < -10 || bullet.y > @game_height
  end

  @spec hited_players(Map.t()) :: Enum.t()
  defp hited_players(bullet) do
    Player.all()
    |> Enum.filter(&(bullet.player_id != &1.id))
    |> Enum.filter(fn player ->
      dx = player.x - bullet.x
      dy = player.y - bullet.y
      :math.sqrt(dx * dx + dy * dy) < 30
    end)
  end
end
