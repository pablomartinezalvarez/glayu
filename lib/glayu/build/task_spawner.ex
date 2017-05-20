defmodule Glayu.Build.TaskSpawner do

  alias Glayu.Build.JobsStore

  @node_build_timeout 300_000

  def spawn(nodes, job, args) do
    nodes
    |> Enum.map(&spawn_task(&1, job, args))
    |> Enum.map(&handle_task(&1))
  end

  defp spawn_task(node, job, args) do
    task = Task.Supervisor.async_nolink(:build_task_supervisor, fn ->
      try do
        JobsStore.put_record(%Glayu.Build.Record{job: job.__info__(:module), node: node, status: :running, pid: self()})
        job.run(node, args)
      rescue error ->
        exit {:shutdown, error}
      catch key, error ->
        exit {:shutdown, {key, error}}
      end
    end)
    {{job.__info__(:module), node}, task}
  end

  defp handle_task({key, task}) do
    response = Task.yield(task, @node_build_timeout)
    task_demonitor(task)
    store_result(response, key)
  end

  defp task_demonitor(task) do
    Process.demonitor(Map.get(task, :ref), [:flush])
  end

  defp store_result({:ok, state}, key) do
    JobsStore.update_record(key, %{status: :ok, details: state})
  end

  defp store_result({:exit, reason}, key) do
    JobsStore.update_record(key, %{status: :error, details: reason})
  end

  defp store_result(nil, key) do
    JobsStore.update_record(key, %{status: :error, details: "Timeout"})
  end

end