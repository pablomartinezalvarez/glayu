defmodule Glayu.PreviewServer.Supervisor do
  use Supervisor

  @default_port 4000

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: :glayu_prev_serv_sup)
  end

  def init(args) do

    merged_args = Keyword.merge([
      port: @default_port,
      dirs: [Glayu.Path.source_root(), Glayu.Path.active_theme_dir()]
    ], Application.get_env(:glayu_preview_server, :args))

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Glayu.PreviewServer.Plug.Server, merged_args, port: merged_args[:port]),
      worker(Glayu.PreviewServer.Watcher, [[dirs: merged_args[:dirs], name: :preview_watcher]])
    ]

    supervise(children, strategy: :one_for_one)

  end
end