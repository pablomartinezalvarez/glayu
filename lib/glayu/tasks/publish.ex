defmodule Glayu.Tasks.Publish do

	@yes ["y", "yes", "yea", "affirmative", "ok", "okay"]
	@no ["n", "no", "not", "nix", "negative", "never", "no way"]

	@behaviour Glayu.Tasks.Task

	def run(params) do
		params[:filename]
		|> parse_draft
		|> create_destination_dir
		|> mv_draft(params[:filename])
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
		if !File.exists?(destination) || override?(destination, nil) do
			:ok = File.rename(source, destination)
			{:ok, %{status: :ok, path: destination}}
		else
			{:ok, %{status: :canceled, path: destination}}
		end
	end

	defp override?(path, previous_answer) do
		answer = override_question(path, previous_answer)		
		cond do
			Enum.member?(@yes, String.trim(String.downcase(answer))) -> true
			Enum.member?(@no, String.trim(String.downcase(answer))) -> false
			true -> override?(path, :invalid)
		end
	end

	defp override_question(_, :invalid) do
		IO.gets(IO.ANSI.format(["Please use ", :light_cyan, "yes", :reset, " or ", :light_cyan, "no\n"]))
	end

	defp override_question(path, _) do
		IO.puts(IO.ANSI.format([:yellow, "⚠️  Destination file ", :bright, Path.absname(path), :normal, " already exists"]))
		IO.gets("Whould you like to override it? ")
	end

end