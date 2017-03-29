defmodule Glayu.Tasks.Publish do

	@behaviour Glayu.Tasks.Task

	def run(params) do
		params[:filename]
		|> parse_draft
		|> create_destination_dir
		|> mv_draft(params[:filename])
		{:ok, ""}
	end

	defp parse_draft(filename) do
		draft = Glayu.Path.source_from_file_name(filename, :draft)
		{yaml_doc, _} = Glayu.Document.parse draft
		yaml_doc
	end

	defp create_destination_dir(yaml_doc) do
		yaml_doc
		|> Glayu.Permalink.permalink
		|> Glayu.Path.source_dir_from_permalink(:post)
		|> File.mkdir_p!
		yaml_doc
	end

	defp mv_draft(yaml_doc, filename) do 
		source = Glayu.Path.source_from_file_name(filename, :draft)
		destination = Glayu.Path.source_from_permalink(Glayu.Permalink.permalink(yaml_doc), :post) 
		:ok = File.rename(source, destination)
	end

end