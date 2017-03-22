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
		|> format_result(task, node)
	end

	defp task_demonitor(response, task) do
    	Map.get(task, :ref) |> Process.demonitor([:flush])
    	response
  	end

  	defp format_result({:ok, state}, task, node) do
  		%Glayu.Build.Record{node: node, status: :ok, pid: Map.get(task, :pid), message: state}
  	end

  	defp format_result({:exit, reason}, task, node) do
  		%Glayu.Build.Record{node: node, status: :error, pid: Map.get(task, :pid), message: reason}
  	end

  	defp format_result(nil, task, node) do
  		%Glayu.Build.Record{node: node, status: :error, pid: Map.get(task, :pid), message: "Timeout"}
  	end

end