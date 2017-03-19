defmodule Glayu.Config do

  	def start_link do
    	Agent.start_link(fn -> _load_config("./_config.yml") end, name: __MODULE__)
    end

    def load_config do
        Agent.update(__MODULE__, 
            fn _ -> 
                _load_config("./_config.yml")
            end)
    end

    def load_config(dir) do
    	Agent.update(__MODULE__, 
            fn _ -> 
                _load_config(Path.join(dir, "./_config.yml"))
            end)
    end

  	def get(key) do
    	Agent.get(__MODULE__, 
            fn list ->
                found = List.keyfind(list, key, 0)
                case found do
                    nil -> nil
                    {_key, value} -> to_string value
                end
            end)
	end

    defp _load_config(path) do
        if File.exists? path do
            List.flatten(:yamerl_constr.file path)
        else
            []
        end
    end

end