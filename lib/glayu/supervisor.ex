defmodule Glayu.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      supervisor(Glayu.Build.Supervisor, []),
      worker(Glayu.ConfigStore, [])
    ]

    supervise(children, strategy: :one_for_all)
  end
end