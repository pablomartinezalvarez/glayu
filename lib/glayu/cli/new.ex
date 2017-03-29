defmodule Glayu.CLI.New do

  @behaviour Glayu.CLI.Command

  alias Glayu.Tasks.New

  def options do
    []
  end

  def aliases do
    []
  end

  def help do
    """
    glayu new [layout] <title>

    Creates a new post or page.

    Args:

    [layout]
    "post" or "page". If no layout is provided, Glayu will use the "post" layout 

    <title>
    Article title. If the title contains spaces, surround it with quotation marks
    """
  end

  def run(params) do
  	params[:args]
    |> parse_args
    |> New.run
  end

  defp parse_args([title]) do
    [type: :post, title: title]
  end

  defp parse_args([layout, title]) do
    [type: String.to_atom(layout), title: title]
  end

end