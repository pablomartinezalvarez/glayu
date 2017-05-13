defmodule Glayu.Build.JobsStore do

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def put_record(record) do
    Agent.update(__MODULE__, fn map ->
      Map.update(map, record.job, %{record.node => record}, fn nodes ->
        Map.put(nodes, record.node , record)
      end)
    end)
  end

  def update_record({job, node}, args) do
    Agent.update(__MODULE__, fn map ->
      put_in(map, [job, node], Map.merge(map[job][node], args))
    end)
  end

  def get_record({job, node}) do
    Agent.get(__MODULE__, fn map -> map[job][node] end)
  end

  def get_nodes(job) do
    Agent.get(__MODULE__, fn map -> Map.keys(map[job]) end)
  end

  def get_values(job) do
    Agent.get(__MODULE__, fn map -> Map.values(map[job]) end)
  end

end