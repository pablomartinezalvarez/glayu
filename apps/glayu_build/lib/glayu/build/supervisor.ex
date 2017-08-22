defmodule Glayu.Build.Supervisor do

  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: :glayu_build_sup)
  end

  def init(:ok) do
    children = [
      :poolboy.child_spec(:worker, poolboy_config(), []),
      worker(Glayu.Build.TemplatesStore, []),
      worker(Glayu.Build.JobsStore, []),
      worker(Glayu.Build.SiteTree, []),
      supervisor(Task.Supervisor, [[name: :build_tasks_sup]])
    ]

    supervise(children, strategy: :one_for_all)

  end

  defp poolboy_config do
    [{:name, {:local, :worker}},
     {:worker_module, Glayu.Build.Worker},
     {:size, Application.get_env(:poolboy, :size)},
     {:max_overflow, Application.get_env(:poolboy, :max_overflow)}]
  end

end