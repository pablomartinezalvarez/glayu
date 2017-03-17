defmodule Glayu.Tasks.Init do

	@moduledoc """
	This task initializes a glayu project.
  	"""

	def run(params) do
		(List.first(params[:args]) || ".") # The directory is the first argument
		|> create_root_dir
		|> handle_config
		|> create_dirs
		# \> download_default_theme
	end

	defp create_root_dir(dir) do
		unless File.exists? dir do
		   File.mkdir! dir
		end
		dir
	end

	defp handle_config(dir) do
		config_file = Path.join(dir, "_config.yml")
		unless File.exists? config_file do
		   File.write! config_file, Glayu.Templates.Config.tpl
		end
		{dir, List.first(:yamerl_constr.file config_file)}
	end

	def create_dirs({dir, config}) do
		{_ , source_dir } = List.keyfind(config, 'source_dir', 0)
		File.mkdir Path.join(dir, List.to_string(source_dir))
		{_ , public_dir } = List.keyfind(config, 'public_dir', 0)
		File.mkdir Path.join(dir, List.to_string(public_dir))
		{dir, config}
		File.mkdir Path.join(dir, "themes")
	end

end