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
  	Init.run [folder: ( List.first(params[:args]) || "." )]
  end

end