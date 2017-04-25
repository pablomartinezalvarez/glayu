defmodule Glayu.Document do

	require EEx

	alias Glayu.Utils.Yaml

	def compile(md_file, tpls) do
		{yaml_doc, content} = parse md_file
		html = render(yaml_doc, content, tpls)
		create_destination_dir(yaml_doc)
		write_file(yaml_doc, html)
	end

	def parse(md_file) do
		md = File.read! md_file
		[frontmatter|content] = String.split md, "\n---\n"
		{Enum.concat([{'type', doc_type(md_file)}, {'md_file', md_file}] , Glayu.FrontMatter.parse frontmatter), content}
	end

	defp render(yaml_doc, content, tpls) do
		Yaml.get_string_value(yaml_doc, 'layout') || Yaml.get_string_value(yaml_doc, 'type')
		|> Glayu.Template.render(content, [page: Yaml.to_map(yaml_doc)], tpls)
	end

	defp create_destination_dir(yaml_doc) do
		yaml_doc
		|> Glayu.Permalink.permalink
		|> Glayu.Path.public_dir_from_permalink
		|> File.mkdir_p!
	end

	defp write_file(yaml_doc, html) do
		yaml_doc
		|> Glayu.Permalink.permalink
		|> Glayu.Path.public_from_permalink
		|> File.write!(html)
	end

	defp doc_type(md_file) do
		cond do
			String.starts_with?(md_file, Glayu.Path.source_root(:post)) -> 'post'
			String.starts_with?(md_file, Glayu.Path.source_root(:draft)) -> 'draft'
			true -> 'page'
		end
	end

end