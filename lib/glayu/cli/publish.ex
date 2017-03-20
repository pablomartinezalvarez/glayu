defmodule Glayu.CLI.Publish do

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
  	List.first(params[:args]) # extract the filename
    |> Publish.run
  end

end