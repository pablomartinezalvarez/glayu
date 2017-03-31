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

    Initializes the web site. If no root folder is provided the current directory will be the site root folder
    """
  end

  def run(params) do
    [folder: ( List.first(params[:args]) || "./" )]
  	|> Init.run 
    |> build_result
  end

  defp build_result({:ok, %{path: path}}) do
    {:ok, IO.ANSI.format(["🐦  Your ", :light_cyan, "Glayu", :reset ," site has been created at ", :light_cyan, "#{path}"])}
  end

end