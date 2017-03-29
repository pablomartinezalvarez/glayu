defmodule Glayu.Permalink do

	alias Glayu.Utils.Yaml

	def permalink(yaml_doc) do
		type = String.to_atom(Yaml.get_string_value(yaml_doc, 'type'))
		permalink(type, yaml_doc)
	end	

	defp permalink(:draft, yaml_doc) do
		permalink(:post, yaml_doc)	
	end

	defp permalink(:post, yaml_doc) do 
		pattern = to_string Glayu.Config.get('permalink')
		parse_permalink(pattern, yaml_doc)
	end

	defp permalink(:page, yaml_doc) do 
		Yaml.get_string_value(yaml_doc, 'md_file')
		|> remove_base_dir
		|> Path.split
		|> List.delete_at(0)
	end

	defp remove_base_dir(file) do
		file_no_ext = String.replace_prefix(file,".md", "")
		cond do 
			String.starts_with?(file_no_ext, Glayu.Path.source_root()) ->
				String.replace_prefix(file,Glayu.Path.source_root(), "")
			String.starts_with?(file_no_ext, Glayu.Path.public_root()) ->
				String.replace_prefix(file, Glayu.Path.public_root(), "")
			true ->
				file_no_ext	
		end
	end

	defp parse_permalink(pattern, yaml_doc) do
		parse(String.split(pattern, "/"), [], yaml_doc)
	end

	defp parse([], permalink, _) do 
		permalink
	end

	defp parse([token|more_tokens], permalink, yaml_doc) do
		parse(more_tokens, permalink ++ eval(String.to_atom(token), yaml_doc), yaml_doc)
	end

	defp eval(:categories, yaml_doc) do
		categories = Yaml.get_value(yaml_doc, 'categories')
		case categories do
		 	nil -> []
		 	categories -> 
            	Enum.map(categories, fn(category) -> Glayu.Slugger.slug(to_string category) end)
        end
	end

	defp eval(:year, yaml_doc) do
		date = Yaml.get_string_value(yaml_doc, 'date')
		case date do
		 	nil -> []
            date -> 
            	datetime = Glayu.Date.parse(date)
            	[Glayu.Date.year datetime]
        end
	end

	defp eval(:month, yaml_doc) do
		date = Yaml.get_string_value(yaml_doc, 'date')
		case date do
		 	nil -> []
            date -> 
            	datetime = Glayu.Date.parse(date)
            	[Glayu.Date.month datetime]
        end
	end

	defp eval(:day, yaml_doc) do
		date = Yaml.get_string_value(yaml_doc, 'date')
		case date do
		 	nil -> []
            date -> 
            	datetime = Glayu.Date.parse(date)
            	[Glayu.Date.day datetime]
        end
	end

	defp eval(:title, yaml_doc) do
		title = Yaml.get_string_value(yaml_doc, 'title')
		case title do
		 	nil -> []
            title -> [Glayu.Slugger.slug(title)]
        end
	end

end