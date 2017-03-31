defmodule Glayu.Build.TaskSpawner do
	
	alias Glayu.Build.NodeProcessor

	@node_build_timeout 300_000

	def spawn(nodes) do
		nodes
		|> Enum.map(&spawn_task(&1))
		|> Enum.map(&handle_task(&1))
	end

	defp spawn_task(node) do
		task = Task.Supervisor.async_nolink(:build_task_supervisor, fn -> NodeProcessor.process(node) end)
		{node, task}
	end

	defp handle_task({node, task}) do
		task
		|> Task.yield(@node_build_timeout)
		|> task_demonitor(task)
		|> store_result(node)
	end

	defp task_demonitor(response, task) do
    	Map.get(task, :ref) |> Process.demonitor([:flush])
    	response
  	end

  	defp store_result({:ok, state}, node) do
  		Glayu.Build.Store.update_record(node, %{status: :ok, details: state})
  	end

  	defp store_result({:exit, reason}, node) do
  		Glayu.Build.Store.update_record(node, %{status: :error, details: reason})
  	end

  	defp store_result(nil, node) do
  		Glayu.Build.Store.update_record(node, %{status: :error, details: "Timeout"})
  	end

end