defmodule Glayu.Utils.Yaml do
	
	def get_value(yaml_doc, key) do
		found = List.keyfind(yaml_doc, key, 0)
		case found do
			nil -> nil
			{_key, value} -> value
		end
	end

	def get_string_value(yaml_doc, key) do
		found = List.keyfind(yaml_doc, key, 0)
		case found do
			nil -> nil
			{_key, value} -> to_string value
		end
	end

end