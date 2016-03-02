defmodule StatHat do
  use Application
  require Logger

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    ez_key = Application.get_env(:stathat, :ez_key)
    children = [
      worker(StatHat.Server, [[ez_key: ez_key]])
    ]
    opts = [strategy: :one_for_one, name: StatHat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Count the stat.
  """
  def ez_count(stat, count) do
    GenServer.cast(StatHat, {:ez_count, stat, count})
  end

  @doc """
  Track the stat with the given value.
  """
  def ez_value(stat, value) do
    GenServer.cast(StatHat, {:ez_value, stat, value})
  end
end

