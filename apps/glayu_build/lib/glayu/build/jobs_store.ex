defmodule Glayu.Build.JobsStore do

  @name :jobs_store

  def start_link do
    Agent.start_link(fn -> %{} end, name: @name)
  end

  def put_record(record) do
    Agent.update(@name, fn map ->
      Map.update(map, record.job, %{record.node => record}, fn nodes ->
        Map.put(nodes, record.node , record)
      end)
    end)
  end

  def update_record({job, node}, args) do
    Agent.update(@name, fn map ->
      put_in(map, [job, node], Map.merge(map[job][node], args))
    end)
  end

  def get_record({job, node}) do
    Agent.get(@name, fn map -> map[job][node] end)
  end

  def get_nodes(job) do
    Agent.get(@name, fn map -> Map.keys(map[job]) end)
  end

  def get_values(job) do
    Agent.get(@name, fn map ->
      job_map = map[job]
      if job_map do
        Map.values(job_map)
      else
        []
      end
    end)
  end

end