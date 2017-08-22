defmodule Glayu.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: :glayu_core_sup)
  end

  def init(:ok) do
    children = [
      worker(Glayu.ConfigStore, [])
    ]

    supervise(children, strategy: :one_for_all)
  end
end