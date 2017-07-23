defmodule Glayu.Tasks.Init do

  require Logger

  @behaviour Glayu.Tasks.Task
  @default_config_file "_config.yml"

  @moduledoc """
  This task initializes a Glayu project.
  """

  def run(params) do
    dir = params[:folder]

    dir
    |> create_root_dir
    |> create_config
    create_dirs()

    theme_uri = Glayu.Config.get('theme_uri')
    if theme_uri do
      result = Glayu.Theme.download_theme(Glayu.Config.get('theme'), theme_uri)
      case result do
        :ok ->
          Glayu.SiteChecker.check_theme!()
        :error ->
          result
      end
    else
      Glayu.SiteChecker.check_theme!()
    end

  end

  defp create_root_dir(dir) do
    create_dir(dir)
    dir
  end

  defp create_config(dir) do
    config_file = Path.join(dir, @default_config_file)
    unless File.exists?(config_file) do
      File.write(config_file, Glayu.Templates.Config.tpl)
    end
    Glayu.Config.load_config_file(config_file, dir)
    dir
  end

  defp create_dirs() do
    create_dir(Glayu.Path.source_root())
    create_dir(Glayu.Path.source_root(:draft))
    create_dir(Glayu.Path.source_root(:post))
    create_dir(Glayu.Path.public_root())
    create_dir(Glayu.Path.themes_dir())
  end

  defp create_dir(dir) do
    unless File.exists? dir do
      File.mkdir_p!(dir)
    end
  end

end