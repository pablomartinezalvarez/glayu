defmodule Glayu.Build.TaskSpawner do

  alias Glayu.Build.JobsStore

  @await_timeout 3_600_000 # 1h
  @transaction_timeout 3_600_000 # 1h

  def spawn(nodes, job, args) do
    nodes
    |> Enum.map(&spawn_task(&1, job, args))
    |> Enum.map(&handle_task(&1))
  end

  defp spawn_task(node, job, args) do
    task = Task.Supervisor.async_nolink(:build_tasks_sup, fn ->
      try do
        JobsStore.put_record(%Glayu.Build.Record{job: job.__info__(:module), node: node, status: :running, pid: self()})
        :poolboy.transaction(:worker, &(GenServer.call(&1, {job, node, args}, @transaction_timeout)), args[:timeout] || @transaction_timeout)
      rescue error ->
         exit {:shutdown, error}
      catch _, error ->
        case error do
          {{:shutdown, details}, _} ->
            exit {:shutdown, details}
          {:timeout, _} ->
            exit {:shutdown, "Timeout"}
          _ ->
            exit {:shutdown, error}
        end
      end
    end)
    {{job.__info__(:module), node}, task}
  end

  defp handle_task({key, task}) do
    response = Task.yield(task, @await_timeout)
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