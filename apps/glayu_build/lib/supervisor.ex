defmodule Glayu.Build.Supervisor do

  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      :poolboy.child_spec(:worker, poolboy_config(), []),
      supervisor(Task.Supervisor, [[name: :build_tasks_sup]]),
      worker(Glayu.Build.JobsStore, []),
      worker(Glayu.Build.SiteTree, []),
      worker(Glayu.Build.TemplatesStore, [])
    ]

    supervise(children, strategy: :one_for_one)

  end

  defp poolboy_config do
    [{:name, {:local, :worker}},
     {:worker_module, Glayu.Build.Worker},
     {:size, Application.get_env(:poolboy, :size)},
     {:max_overflow, Application.get_env(:poolboy, :max_overflow)}]
  end

end