defmodule Glayu.Document do

	require EEx

	alias Glayu.Utils.Yaml

	def compile(md_file) do
		{yaml_doc, content} = parse md_file
		html = render(yaml_doc, content)
		create_destination_dir(yaml_doc)
		write_file(yaml_doc, html)
	end

	def parse(md_file) do
		md = File.read! md_file
		[frontmatter|content] = String.split md, "\n---\n"
		{Enum.concat([{'type', doc_type(md_file)}, {'md_file', md_file}] , Glayu.FrontMatter.parse frontmatter), content}
	end

	defp render(yaml_doc, content) do
		content_layout = Yaml.get_string_value(yaml_doc, 'layout') || Yaml.get_string_value(yaml_doc, 'type')
		content_tpl = Glayu.Layout.load(content_layout)
		content_html = Earmark.as_html!(content)
		content = EEx.eval_string(content_tpl, assigns: [content: content_html]) 
		page_tpl = Glayu.Layout.load("layout")
		EEx.eval_string(page_tpl, assigns: [title: Yaml.get_string_value(yaml_doc, 'title'), content: content])
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