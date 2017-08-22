defmodule Glayu.PreviewServer.Supervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: :glayu_prev_serv_sup)
  end

  def init(args) do

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Glayu.PreviewServer.Plug.Server, [], port: args[:port]),
      worker(Glayu.PreviewServer.Watcher, [[dirs: [Glayu.Path.source_root(), Glayu.Path.active_theme_dir()], name: :preview_watcher]])
    ]

    supervise(children, strategy: :one_for_all)

  end
end