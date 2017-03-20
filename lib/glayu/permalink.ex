defmodule Glayu.Permalink do
	
	def permalink(document) do
		pattern = to_string Glayu.Config.get('permalink')
		parse_permalink(pattern, document)
	end

	defp parse_permalink(pattern, document) do
		parse(String.split(pattern, "/"), [], document)
	end

	defp parse([], permalink, _) do 
		permalink
	end

	defp parse([token|more_tokens], permalink, document) do
		parse(more_tokens, permalink ++ eval(token,document), document)
	end

	defp eval(":category", document) do
		 found = List.keyfind(document, 'categories', 0)
		 case found do
		 	nil -> []
            {_key, categories} -> 
            	Enum.map(categories, fn(category) -> Glayu.Slugger.slug(to_string category) end)
         end
	end

	defp eval(":year", document) do
		found = List.keyfind(document, 'date', 0)
		case found do
		 	nil -> []
            {_key, value} -> 
            	datetime = Glayu.Date.parse(to_string value)
            	[Glayu.Date.year datetime]
        end
	end

	defp eval(":month", document) do
		found = List.keyfind(document, 'date', 0)
		case found do
		 	nil -> []
            {_key, value} -> 
            	datetime = Glayu.Date.parse(to_string value)
            	[Glayu.Date.month datetime]
        end
	end

	defp eval(":day", document) do
		found = List.keyfind(document, 'date', 0)
		case found do
		 	nil -> []
            {_key, value} -> 
            	datetime = Glayu.Date.parse(to_string value)
            	[Glayu.Date.day datetime]
        end
	end

	defp eval(":title", document) do
		found = List.keyfind(document, 'title', 0)
		case found do
		 	nil -> []
            {_key, value} -> [Glayu.Slugger.slug(to_string value)]
        end
	end

end