defmodule Glayu.PreviewServer.Supervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args)
  end

  def init(args) do

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Glayu.PreviewServer.Plug.Server, [], port: args[:port]),
      supervisor(Glayu.Build.Supervisor, [])
    ]

    supervise(children, strategy: :one_for_one)

  end
end