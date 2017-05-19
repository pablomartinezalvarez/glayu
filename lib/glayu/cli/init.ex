defmodule Glayu.CLI.Init do

  @behaviour Glayu.CLI.Command

  alias Glayu.Tasks.Init

  def options do
    []
  end

  def aliases do
    []
  end

  def help do
    """
    glayu init [folder]

    Initializes the website.

    If no `folder` is provided, the website will be configured in the current directory.

    If the destination folder exists and contains a `_config.yml` file, this configuration file will be used to initialize the site.

    ARGUMENTS

    [folder]

    Website destination folder. If the destination folder doesn't exists the full path to it will be created.

    """
  end

  def run(params) do
    [folder: (List.first(params[:args]) || "./")]
  	|> Init.run 
    |> build_result
  end

  defp build_result({:ok, %{path: path}}) do
    {:ok, IO.ANSI.format(["🐦  Your ", :light_cyan, "Glayu", :reset , " site has been created at ", :light_cyan, "#{path}"])}
  end

end