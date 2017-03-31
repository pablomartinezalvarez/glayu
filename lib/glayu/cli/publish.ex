defmodule Glayu.CLI.Publish do

  @behaviour Glayu.CLI.Command

  alias Glayu.Tasks.Publish

  def options do
    []
  end

  def aliases do
    []
  end

  def help do
    """
    glayu publish <filename>

    Publishes a draft.

    Args:

    <filename>
    The draft filename
    """
  end

  def run(params) do
    [filename] = params[:args]
  	result = Publish.run [filename: filename]
    build_result(result)
  end

  defp build_result({:ok, %{status: :ok, path: path}}) do 
    {:ok, IO.ANSI.format(["🐦  Draft published to ", :light_cyan, "#{path}"])}
  end

  defp build_result({:ok, %{status: :canceled, path: path}}) do 
    {:ok, IO.ANSI.format(["🐦  Previous published file ", :light_cyan, "#{path}", :reset, " has been preserved."])}
  end

end