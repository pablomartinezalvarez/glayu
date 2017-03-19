defmodule Glayu.Tasks.Init do

	@moduledoc """
	This task initializes a Glayu project.
  	"""

	def run(params) do
		params
		|> create_root_dir
		|> create_config
		|> create_dirs
		# \> download_default_theme
	end

	defp create_root_dir(dir) do
		unless File.exists? dir do
		   File.mkdir! dir
		end
		dir
	end

	defp create_config(dir) do
		config_file = Path.join(dir, "_config.yml")
		unless File.exists? config_file do
		   File.write! config_file, Glayu.Templates.Config.tpl
		end
		Glayu.Config.load_config(dir)
		dir
	end

	defp create_dirs(dir) do
		create_dir Path.join(dir, Glayu.Config.get('source_dir'))
		create_dir Path.join([dir, Glayu.Config.get('source_dir'), "_drafts"])
		create_dir Path.join([dir, Glayu.Config.get('source_dir'), "_posts"])
		create_dir Path.join(dir, Glayu.Config.get('public_dir'))
		create_dir Path.join(dir, "themes")
	end

	defp create_dir(dir) do
		unless File.exists? dir do
			File.mkdir! dir
		end
	end

end