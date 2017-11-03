defmodule UaiShot.GameServer do
  @moduledoc """
  Update game data such as bullet positions and if the player
  has been hit by a bullet.
  """

  use GenServer

  alias UaiShot.Store.{Bullet, Player, Ranking}
  alias UaiShotWeb.Endpoint

  @worker_interval 20
  @game_width 800
  @game_height 600

  @doc """
  Start GameServer.
  """
  @spec start_link(State.t) :: :ok
  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
  Initialize GameServer scheduler.
  """
  @spec init(State.t) :: {:ok, State.t}
  def init(state) do
    :timer.send_interval(@worker_interval, :work)
    {:ok, state}
  end

  @doc """
  Update bullet positions and hit players.
  """
  @spec handle_info(:work, State.t) :: {:noreply, State.t}
  def handle_info(:work, state) do
    bullets = Bullet.all()
    |> Enum.map(&move_bullet(&1))
    |> Enum.reject(&bullet_is_far?(&1))

    Bullet.reset(bullets)
    Endpoint.broadcast("game:lobby", "update_bullets", %{bullets: bullets})

    {:noreply, state}
  end

  @spec move_bullet(Map.t) :: Map.t
  defp move_bullet(bullet) do
    bullet
    |> hited_players
    |> Enum.each(&process_hit(bullet, &1))

    bullet
    |> Map.put(:x, bullet.x + bullet.speed_x)
    |> Map.put(:y, bullet.y + bullet.speed_y)
  end

  @spec process_hit(Map.t, Map.t) :: :ok
  defp process_hit(bullet, player) do
    bullet.player_id
    |> Ranking.get
    |> Map.update!(:value, &(&1 + 10))
    |> Ranking.put

    Endpoint.broadcast("game:lobby", "hit_player", %{player_id: player.id})
  end

  @spec bullet_is_far?(Map.t) :: Boolean.t
  defp bullet_is_far?(bullet) do
    bullet.x < -10 || bullet.x > @game_width
    || bullet.y < -10 || bullet.y > @game_height
  end

  @spec hited_players(Map.t) :: Enum.t
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
