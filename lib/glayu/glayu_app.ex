defmodule GlayuApp do

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Glayu.ConfigStore, []),
      worker(Task.Supervisor, [[name: :build_task_supervisor]]),
      worker(Glayu.Build.JobsStore, []),
      worker(Glayu.Build.SiteTree, []),
      worker(Glayu.Build.TemplatesStore, []),
      :poolboy.child_spec(:worker, poolboy_config(), [])
    ]

    opts = [strategy: :one_for_one, name: Glayu.Supervisor]

    Supervisor.start_link(children, opts)
    
  end

  defp poolboy_config do
    [{:name, {:local, :worker}},
     {:worker_module, Glayu.Build.Worker},
     {:size, 5},
     {:max_overflow, 2}]
  end

end