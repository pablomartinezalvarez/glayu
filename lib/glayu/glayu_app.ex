defmodule GlayuApp do

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Glayu.Config, []),
      worker(Task.Supervisor, [[name: :build_task_supervisor]]),
      worker(Glayu.Build.JobsStore, []),
      worker(Glayu.Build.SiteTree, []),
      worker(Glayu.Build.TemplatesStore, []),
      worker(Glayu.Build.ProgressMonitor, [])
    ]

    opts = [strategy: :one_for_one, name: Glayu.Supervisor]

    Supervisor.start_link(children, opts)
    
  end
end