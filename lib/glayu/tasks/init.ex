defmodule Glayu.Tasks.Init do

  require Logger

  @behaviour Glayu.Tasks.Task

  @moduledoc """
  This task initializes a Glayu project.
  """

  def run(params) do
    params[:folder]
    |> create_root_dir
    |> create_config
    |> create_dirs
    {:ok, %{path: params[:folder]}}
  end

  defp create_root_dir(dir) do
    if File.exists?(dir) do
      Logger.info fn ->
        IO.ANSI.format(["Directory ", :bright, "#{Path.absname(dir)}", :normal, " is not empty, its content will be preserved"], true)
      end
    else
      File.mkdir_p! dir
    end
    dir
  end

  defp create_config(dir) do
    config_file = Path.join(dir, "_config.yml")
    if File.exists?(config_file) do
      Logger.info fn ->
        IO.ANSI.format(["Loading config from existing ", :bright, "_config.yml", :normal, " file"], true)
      end
    else
      Logger.info fn ->
        IO.ANSI.format(["no ", :bright, "_config.yml", :normal, " file found, using defaults"], true)
      end

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