defmodule Glayu.Build.Store do

  	def start_link do
    	Agent.start_link(fn -> %{} end, name: __MODULE__)
    end

    def put_record(record) do
       Agent.update(__MODULE__, fn map ->
            Map.put(map, record.node , record)
        end)
    end

    def get_record(node) do
        Agent.get(__MODULE__, fn map -> map[node] end)
    end

    def get_nodes() do
        Agent.get(__MODULE__, fn map -> Map.keys(map) end)
    end

    def get_all() do
       Agent.get(__MODULE__, fn map -> Map.to_list(map) end) 
    end

end