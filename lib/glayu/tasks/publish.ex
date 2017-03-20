defmodule Glayu.Tasks.Publish do

	def run(file_name) do
		file_name
		|> parse_draft
		|> create_destination_dir
		|> mv_draft(file_name)
	end

	defp parse_draft(file_name) do
		file_name
		|> Glayu.Path.source_draft_path_from_file_name
		|> Glayu.Parser.parse
	end

	defp create_destination_dir(document) do
		document
		|> Glayu.Permalink.permalink
		|> Glayu.Path.public_dir_from_permalink
		|> File.mkdir_p!
		document
	end

	defp mv_draft(document, file_name) do 
		source = Glayu.Path.source_draft_path_from_file_name(file_name)
		destination = Glayu.Path.public_post_from_permalink(Glayu.Permalink.permalink(document)) 
		:ok = File.rename(source, destination)
	end

end