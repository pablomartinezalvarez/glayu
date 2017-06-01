defmodule Glayu.Tasks.Init do

  require Logger

  @behaviour Glayu.Tasks.Task

  @moduledoc """
  This task initializes a Glayu project.
  """

  def run(params) do
    dir = params[:folder]

    dir
    |> create_root_dir
    |> create_config
    |> create_dirs

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
    config_file = Path.join(dir, "_config.yml")
    unless File.exists?(config_file) do
      File.write(config_file, Glayu.Templates.Config.tpl)
    end
    Glayu.Config.load_config(dir)
    dir
  end

  defp create_dirs(dir) do
    create_dir(Path.join(dir, Glayu.Config.get('source_dir')))
    create_dir(Path.join([dir, Glayu.Config.get('source_dir'), "_drafts"]))
    create_dir(Path.join([dir, Glayu.Config.get('source_dir'), "_posts"]))
    create_dir(Path.join(dir, Glayu.Config.get('public_dir')))
    create_dir(Path.join(dir, "themes"))
  end

  defp create_dir(dir) do
    unless File.exists? dir do
      File.mkdir_p!(dir)
    end
  end

end