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
  	Publish.run [filename: filename]
  end

end